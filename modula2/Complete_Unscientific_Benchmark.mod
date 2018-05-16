MODULE CompletelyUnscientificBenchmark;

FROM SYSTEM IMPORT TSIZE;
FROM StrIO IMPORT WriteLn;
FROM NumberIO IMPORT WriteInt;
FROM libc IMPORT srand, rand, time;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;

TYPE

   NodePtr = POINTER TO Node;
   Node = RECORD
      left, right: NodePtr;
      x, y: INTEGER;
   END; (* Node *)

   Tree = RECORD
      root: NodePtr;
   END; (* Tree *)

PROCEDURE InitNode(VAR node: NodePtr; val: INTEGER);
BEGIN
   ALLOCATE(node, TSIZE(Node));
   node^.x := val;
   node^.y := rand();
END InitNode;

PROCEDURE DeleteNode(node: NodePtr);
BEGIN
   IF node # NIL THEN
      IF node^.left # NIL THEN DeleteNode(node^.left);
      ELSIF node^.right # NIL THEN DeleteNode(node^.right);
      END; (* IF *)
      DEALLOCATE(node, TSIZE(Node));
   END; (* IF *)
END DeleteNode;

PROCEDURE Merge(lower, greater: NodePtr): NodePtr;
BEGIN
   IF lower   = NIL THEN RETURN greater; END;
   IF greater = NIL THEN RETURN lower;   END;
   IF lower^.y < greater^.y THEN
      lower^.right := Merge(lower^.right, greater);
      RETURN lower;
   ELSE
      greater^.left := Merge(lower, greater^.left);
      RETURN greater;
   END;
END Merge;

PROCEDURE MergeThree(lower, equal, greater: NodePtr): NodePtr;
BEGIN
   RETURN Merge(Merge(lower, equal), greater);
END MergeThree;

PROCEDURE Split2(orig: NodePtr; VAR lower, greaterOrEqual: NodePtr; val: INTEGER);
BEGIN
   IF orig = NIL THEN
      lower := orig;
      greaterOrEqual := NIL;
      RETURN;
   END;
   IF orig^.x < val THEN
      lower := orig;
      Split2(lower^.right, lower^.right, greaterOrEqual, val);
   ELSE
      greaterOrEqual := orig;
      Split2(greaterOrEqual^.left, lower, greaterOrEqual^.left, val);
   END;
END Split2;

PROCEDURE Split3(orig: NodePtr; VAR lower, equal, greater: NodePtr; val: INTEGER);
VAR
  equalOrGreater: NodePtr;
BEGIN
   Split2(orig, lower, equalOrGreater, val);
   Split2(equalOrGreater, equal, greater, val + 1);
END Split3;

PROCEDURE Insert(VAR t: Tree; val: INTEGER);
VAR
   lower, equal, greater: NodePtr;
BEGIN
   Split3(t.root, lower, equal, greater, val);
   IF equal = NIL THEN InitNode(equal, val); END;
   t.root := MergeThree(lower, equal, greater);
END Insert;

PROCEDURE Erase(VAR t: Tree; val: INTEGER);
VAR
   lower, equal, greater: NodePtr;
BEGIN
   Split3(t.root, lower, equal, greater, val);
   t.root := Merge(lower, greater);
   DeleteNode(equal);
END Erase;

PROCEDURE HasValue(t: Tree; val: INTEGER): INTEGER;
VAR
   lower, equal, greater: NodePtr;
   result: INTEGER;
BEGIN
   Split3(t.root, lower, equal, greater, val);
   IF equal = NIL THEN result := 0; ELSE result := 1; END;
   t.root := MergeThree(lower, equal, greater);
   RETURN result;
END HasValue;

VAR
   t: Tree;
   i, cur, res, mode: INTEGER;

BEGIN

   srand(time(NIL));
   cur := 5; res := 0;
   FOR i := 1 TO 999999 DO
      mode := i MOD 3;
      cur := (cur * 57 + 43) MOD 10007;
      IF mode = 0 THEN Insert(t, cur);
      ELSIF mode = 1 THEN Erase(t, cur);
      ELSE res := res + HasValue(t, cur);
      END; (* IF *)
   END; (* FOR *)
   WriteInt(res, 0); WriteLn;

END CompletelyUnscientificBenchmark.
