MODULE Main;

(* This uses garbage-collected objects (REF). *)

IMPORT IO, Random;

TYPE

  Node = REF NodeT;

  NodeT = RECORD
    left, right: Node;
    x, y: INTEGER;
  END;

  Tree = RECORD
    root: Node;
  END;

VAR

  random: Random.T := NEW(Random.Default).init();

PROCEDURE CreateNode(value: INTEGER): Node =
BEGIN
  RETURN NEW(Node, x := value, y := random.integer());
END CreateNode;

PROCEDURE Merge(VAR lower, greater: Node): Node =
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

PROCEDURE MergeThree(VAR lower, equal, greater: Node): Node =
VAR
  tmp: Node;
BEGIN
  tmp := Merge(lower, equal);
  RETURN Merge(tmp, greater);
END MergeThree;

PROCEDURE Split2(orig: Node; VAR lower, greaterOrEqual: Node; value: INTEGER) =
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

PROCEDURE Split3(orig: Node; VAR lower, equal, greater: Node; value: INTEGER) =
VAR
  equalOrGreater: Node := NIL;
BEGIN
  Split2(orig, lower, equalOrGreater, value);
  Split2(equalOrGreater, equal, greater, value + 1);
END Split3;

PROCEDURE Insert(VAR t: Tree; value: INTEGER) =
VAR
  lower, equal, greater: Node := NIL;
BEGIN
  Split3(t.root, lower, equal, greater, value);
  IF equal = NIL THEN equal := CreateNode(value); END;
  t.root := MergeThree(lower, equal, greater);
END Insert;

PROCEDURE Erase(VAR t: Tree; value: INTEGER) =
VAR
  lower, equal, greater: Node := NIL;
BEGIN
  Split3(t.root, lower, equal, greater, value);
  t.root := Merge(lower, greater);
END Erase;

PROCEDURE HasValue(t: Tree; value: INTEGER): BOOLEAN =
VAR
  lower, equal, greater: Node := NIL;
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
(*  FOR i := 1 TO 99 DO
    mode := i MOD 3;
    cur := (cur * 57 + 43) MOD 100; *)
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

END Main.
