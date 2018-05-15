import random

type Node = ref object
  x, y: int32
  left, right: Node

template newNode(value: int32): Node =
  Node(x: value, y: rand(high int32).int32)

proc merge(lower, greater: Node): Node {.noInit.} =
  if lower.isNil:
    greater
  elif greater.isNil:
    lower
  elif lower.y < greater.y:
    lower.right = merge(lower.right, greater)
    lower
  else:
    greater.left = merge(lower, greater.left)
    greater

template merge(lower, equal, greater: Node): Node =
  merge(merge(lower, equal), greater)

proc splitBinary(orig: Node, lower, equalGreater: var Node, value: int32) =
  if orig.isNil:
    lower = nil
    equalGreater = nil
  elif orig.x < value:
    lower = orig
    splitBinary(lower.right, lower.right, equalGreater, value)
  else:
    equalGreater = orig
    splitBinary(equalGreater.left, lower, equalGreater.left, value)

template split(orig: Node, value: int32, lower, equal, greater: var Node) =
  var equalGreater: Node
  splitBinary(orig, lower, equalGreater, value)
  splitBinary(equalGreater, equal, greater, value + 1)

type Tree = object
  root: Node

template hasValue(self: var Tree, x: int32): bool =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  let ret = not equal.isNil
  self.root = merge(lower, equal, greater)
  ret

template insert(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  if equal.isNil:
    equal = newNode(x)
  self.root = merge(lower, equal, greater)

template erase(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  self.root = merge(lower, greater)

proc main() =
  var tree = Tree()
  var cur = 5'i32
  var res = 0'i32

  for i in 1'i32 ..< 1000000'i32:
    let a = i mod 3
    cur = (cur * 57 + 43) mod 10007
    case a:
    of 0:
      tree.insert(cur)
    of 1:
      tree.erase(cur)
    of 2:
      if tree.hasValue(cur):
        res += 1
    else:
      discard

  stdout.write res

when isMainModule:
  main()
