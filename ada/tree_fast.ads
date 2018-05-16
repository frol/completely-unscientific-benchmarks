with Ada.Numerics.Discrete_Random;

package Tree_Fast is

type Node is private;

type NodePtr is access Node;

type Tree is private;

procedure initialize;

function hasValue(t: in out Tree; x: Integer) return Boolean;

procedure insert(t: in out Tree; x: Integer);

procedure erase(t: in out Tree; x: Integer);

private

function merge(lower, greater: NodePtr) return NodePtr;

function merge(lower, equal, greater: NodePtr) return NodePtr;

procedure split(orig: NodePtr; lower, greaterOrEqual: in out NodePtr; val: Integer);

procedure split(orig: NodePtr; lower, equal, greater: in out NodePtr; val: Integer);

procedure make_node(n: out NodePtr; x: Integer);

type Tree is record
  root: NodePtr := null;
end record;

package Integer_Random is new Ada.Numerics.Discrete_Random(Integer);
use Integer_Random;

g: Generator;

type Node is record
  left, right: NodePtr;
  x: Integer := 0;
  y: Integer := Random(g);
end record;

end Tree_Fast;
