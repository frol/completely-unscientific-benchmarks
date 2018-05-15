import random

type Node = ref object
  x, y: int32
  left, right: Node

proc newNode(x: int32): Node =
  result = Node(x: x, y: rand(high int32).int32)

proc merge(lower, greater: Node): Node =
  if lower.isNil:
    result = greater
  elif greater.isNil:
    result = lower
  elif lower.y < greater.y:
    lower.right = merge(lower.right, greater)
    result = lower
  else:
    greater.left = merge(lower, greater.left)
    result = greater

proc splitBinary(orig: Node, value: int32): (Node, Node) =
  if orig.isNil:
    result = (nil, nil)
  elif orig.x < value:
    let splitPair = splitBinary(orig.right, value)
    orig.right = splitPair[0]
    result = (orig, splitPair[1])
  else:
    let splitPair = splitBinary(orig.left, value)
    orig.left = splitPair[1]
    result = (splitPair[0], orig)

proc merge3(lower, equal, greater: Node): Node =
  merge(merge(lower, equal), greater)

proc split(orig: Node, value: int32): tuple[lower, equal, greater: Node] =
  let
    (lower, equalGreater) = splitBinary(orig, value)
    (equal, greater) = splitBinary(equalGreater, value + 1)
  result = (lower, equal, greater)

type Tree = object
  root: Node

proc hasValue(self: var Tree, x: int32): bool =
  let splited = split(self.root, x)
  result = not splited.equal.isNil
  self.root = merge3(splited.lower, splited.equal, splited.greater)

proc insert(self: var Tree, x: int32) =
  var splited = split(self.root, x)
  if splited.equal.isNil:
    splited.equal = newNode(x)
  self.root = merge3(splited.lower, splited.equal, splited.greater)

proc erase(self: var Tree, x: int32) =
  let splited = split(self.root, x)
  self.root = merge(splited.lower, splited.greater)

proc main() =
  var
    tree = Tree()
    cur = 5'i32
    res = 0

  for i in 1 ..< 1000000:
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
  echo res

when isMainModule:
  main()
