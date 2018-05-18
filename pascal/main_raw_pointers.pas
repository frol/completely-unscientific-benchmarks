program main;

Type Node = Object
public
     constructor Create(newX: Longint);
     destructor Destroy();

public
     x, y: Longint;
     left, right: ^Node;
End;

constructor Node.Create(newX: Longint);
begin
  x := newX;
  y := Random(2147483647);
  left := nil;
  right := nil;
end;

destructor Node.Destroy();
begin
  if left <> nil then
    left^.Destroy();
  if right <> nil then
    right^.Destroy();
end;

type NodePtr = ^Node;

function merge(lower, greater: NodePtr) : NodePtr;
begin
  if lower = nil then
    merge := greater
  else if greater = nil then
    merge := lower
  else
  begin
    if lower^.y < greater^.y then
    begin
      lower^.right := merge(lower^.right, greater);
      merge := lower;
    end
    else
    begin
      greater^.left := merge(lower, greater^.left);
      merge := greater;
    end;
  end;
end;

procedure split(orig: NodePtr; var lower, greaterOrEqual: NodePtr; val : Longint);
begin
  if orig = nil then
  begin
    lower := nil;
    greaterOrEqual := nil;
  end
  else if orig^.x < val then
  begin
    lower := orig;
    split(lower^.right, lower^.right, greaterOrEqual, val);
  end
  else
  begin
    greaterOrEqual := orig;
    split(greaterOrEqual^.left, lower, greaterOrEqual^.left, val);
  end;
end;

function merge3(lower, equal, greater: NodePtr): NodePtr;
begin
  merge3 := merge(merge(lower, equal), greater);
end;

procedure split3(orig: NodePtr; var lower, equal, greater: NodePtr; val: Longint);
var
  equalOrGreater: NodePtr;
begin
  split(orig, lower, equalOrGreater, val);
  split(equalOrGreater, equal, greater, val + 1);
end;

Type Tree = Object
public
      constructor Create();
      destructor Destroy();

      procedure insert(val: Longint);
      procedure erase(val: Longint);
      function hasValue(val: Longint): Boolean;

private
     mRoot: NodePtr;
End;

constructor Tree.Create();
begin
  mRoot := nil;
end;

destructor Tree.Destroy();
begin
  if mRoot <> nil then
    mRoot^.Destroy();
end;

procedure Tree.insert(val: Longint);
var
  lower, equal, greater: NodePtr;
begin
  split3(mRoot, lower, equal, greater, val);
  if equal = nil then
    equal := new(NodePtr, Create(val));

  mRoot := merge3(lower, equal, greater);
end;

procedure Tree.erase(val: Longint);
var
  lower, equal, greater: NodePtr;
begin
  split3(mRoot, lower, equal, greater, val);
  mRoot := merge(lower, greater);
  if equal <> nil then
    dispose(equal, Destroy);
end;

function Tree.hasValue(val: Longint): Boolean;
var
  lower, equal, greater: NodePtr;
begin
  split3(mRoot, lower, equal, greater, val);
  hasValue := equal <> nil;
  mRoot := merge3(lower, equal, greater);
end;

var
  curTree: Tree;
  cur, res, i, mode: Longint;
begin
  Randomize();

  curTree.Create();

  cur := 5;
  res := 0;

  for i := 1 to 1000000 do
  begin
    mode := i mod 3;
    cur := (cur * 57 + 43) mod 10007;
    if mode = 0 then
      curTree.insert(cur)
    else if mode = 1 then
      curTree.erase(cur)
    else if mode = 2 then
    begin
      if curTree.hasValue(cur) then
        res := res + 1;
    end;
  end;

  WriteLn(res);
end.
