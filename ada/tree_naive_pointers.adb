with Ada.Unchecked_Deallocation;

package body Tree_Naive_Pointers is

procedure initialize is
begin
  Reset(g);
end;

procedure make_node(n: out NodePtr; x: Integer) is
begin
  n := new Node;
  n.x := x;
  n.y := Random(g);
end make_node;

procedure delete_node(n: in out NodePtr) is
  procedure free is new Ada.Unchecked_Deallocation(Object => Node, Name => NodePtr);
begin
  if n /= null then
    if n.left /= null then delete_node(n.left); end if;
    if n.right /= null then delete_node(n.right); end if;
    free(n);
  end if;
end delete_node;

function merge(lower, greater: NodePtr) return NodePtr is
begin

  if lower = null then return greater; end if;
  if greater = null then return lower; end if;

  if lower.y < greater.y then
    lower.right := merge(lower.right, greater);
    return lower;
  else
    greater.left := merge(lower, greater.left);
    return greater;
  end if;  

end merge;

function merge(lower, equal, greater: NodePtr) return NodePtr is
begin
  return merge(merge(lower, equal), greater);
end merge;

procedure split(orig: NodePtr; lower, greaterOrEqual: in out NodePtr; val: Integer) is
begin
  if orig = null then
    lower := null;
    greaterOrEqual := null;
    return;
  end if;
  if orig.x < val then
    lower := orig;
    split(lower.right, lower.right, greaterOrEqual, val);
  else
    greaterOrEqual := orig;
    split(greaterOrEqual.left, lower, greaterOrEqual.left, val);
  end if;
end split;

procedure split(orig: NodePtr; lower, equal, greater: in out NodePtr; val: Integer) is
  equalOrGreater: NodePtr;
begin
  split(orig, lower, equalOrGreater, val);
  split(equalOrGreater, equal, greater, val + 1);
end split;

function hasValue(t: in out Tree; x: Integer) return Boolean is
  lower, equal, greater: NodePtr;
  result: Boolean;
begin
  split(t.root, lower, equal, greater, x);
  result := equal /= null;
  t.root := merge(lower, equal, greater);
  return result;
end hasValue;

procedure insert(t: in out Tree; x: Integer) is
  lower, equal, greater: NodePtr;
begin
  split(t.root, lower, equal, greater, x);
  if equal = null then make_node(equal, x); end if;
  t.root := merge(lower, equal, greater);
end insert;

procedure erase(t: in out Tree; x: Integer) is
  lower, equal, greater: NodePtr;
begin
  split(t.root, lower, equal, greater, x);
  t.root := merge(lower, greater);
  -- commenting out the following line
  -- doesn't seem to affect running time by much, if at all
  delete_node(equal);
end erase;

end Tree_Naive_Pointers;
