UNSAFE MODULE Pooled EXPORTS Main;

(*
  This uses UNTRACED REF and is a lot faster than REF.
  In fact, it is essentially equivalent to C++ timings
  (but about 10 times larger).

  We mark the module as UNSAFE because it DISPOSE's objects.
*)

IMPORT IO, NodeMemoryPool AS MP, Node, Random;

TYPE

  Tree = RECORD
    root: Node.URef;
  END;

VAR

  random: Random.T := NEW(Random.Default).init();

PROCEDURE CreateNode(value: INTEGER): Node.URef =
VAR
  result: Node.URef := MP.Create();
BEGIN
  (*RETURN NEW(Node.URef, x := value, y := random.integer());*)
  result.x := value;
  result.y := random.integer();
  RETURN result;
END CreateNode;

PROCEDURE Merge(VAR lower, greater: Node.URef): Node.URef =
BEGIN
  IF lower   = NIL THEN RETURN greater; END;
  IF greater = NIL THEN RETURN lower;   END;
  IF lower.y < greater.y THEN
    lower.right := Merge(lower.right, greater);
    RETURN lower;
  ELSE
    greater.left := Merge(lower, greater.left);
    RETURN greater;
  END;
END Merge;

PROCEDURE MergeThree(VAR lower, equal, greater: Node.URef): Node.URef =
VAR
  tmp: Node.URef;
BEGIN
  tmp := Merge(lower, equal);
  RETURN Merge(tmp, greater);
END MergeThree;

PROCEDURE Split2(orig: Node.URef; VAR lower, greaterOrEqual: Node.URef; value: INTEGER) =
BEGIN
  IF orig = NIL THEN
    lower := orig;
    greaterOrEqual := NIL;
    RETURN;
  END;
  IF orig.x < value THEN
    lower := orig;
    Split2(lower.right, lower.right, greaterOrEqual, value);
  ELSE
    greaterOrEqual := orig;
    Split2(greaterOrEqual.left, lower, greaterOrEqual.left, value);
  END;
END Split2;

PROCEDURE Split3(orig: Node.URef; VAR lower, equal, greater: Node.URef; value: INTEGER) =
VAR
  equalOrGreater: Node.URef := NIL;
BEGIN
  Split2(orig, lower, equalOrGreater, value);
  Split2(equalOrGreater, equal, greater, value + 1);
END Split3;

PROCEDURE Insert(VAR t: Tree; value: INTEGER) =
VAR
  lower, equal, greater: Node.URef := NIL;
BEGIN
  Split3(t.root, lower, equal, greater, value);
  IF equal = NIL THEN equal := CreateNode(value); END;
  t.root := MergeThree(lower, equal, greater);
END Insert;

PROCEDURE Erase(VAR t: Tree; value: INTEGER) =
VAR
  lower, equal, greater: Node.URef := NIL;
BEGIN
  Split3(t.root, lower, equal, greater, value);
  t.root := Merge(lower, greater);
  IF equal # NIL THEN MP.Dispose(equal); END;
END Erase;

PROCEDURE HasValue(t: Tree; value: INTEGER): BOOLEAN =
VAR
  lower, equal, greater: Node.URef := NIL;
  result: BOOLEAN;
BEGIN
  Split3(t.root, lower, equal, greater, value);
  IF equal = NIL THEN result := FALSE; ELSE result := TRUE; END;
  t.root := MergeThree(lower, equal, greater);
  RETURN result;
END HasValue;

VAR
  t: Tree;
  cur, res, mode: INTEGER;

BEGIN

  cur := 5; res := 0;
  FOR i := 1 TO 999999 DO
    mode := i MOD 3;
    cur := (cur * 57 + 43) MOD 10007;
    IF    mode = 0 THEN
      Insert(t, cur);
    ELSIF mode = 1 THEN
      Erase(t, cur);
    ELSE
      IF HasValue(t, cur) THEN INC(res);
      END;
    END;
  END;
  IO.PutInt(res); IO.PutChar('\n'); 

END Pooled.
