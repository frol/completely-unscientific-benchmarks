import random

type Node = ref object
  x, y: int32
  left, right: Node

proc newNode(x: int32): Node =
  return Node(x: x, y: rand(high(int32).int).int32, left: nil, right: nil)

proc merge(lower, greater: Node): Node =
  if lower.isNil:
    return greater

  if greater.isNil:
    return lower

  if lower.y < greater.y:
    lower.right = merge(lower.right, greater)
    return lower
  else:
    greater.left = merge(lower, greater.left)
    return greater

proc splitBinary(orig: Node, value: int32): (Node, Node) =
  if orig.isNil:
    return (nil, nil)

  if orig.x < value:
    let splitPair = splitBinary(orig.right, value)
    orig.right = splitPair[0]
    return (orig, splitPair[1])
  else:
    let splitPair = splitBinary(orig.left, value)
    orig.left = splitPair[1]
    return (splitPair[0], orig)

proc merge3(lower, equal, greater: Node): Node =
  return merge(merge(lower, equal), greater)

proc split(orig: Node, value: int32): tuple[lower, equal, greater: Node] =
  let (lower, equalGreater) = splitBinary(orig, value)
  let (equal, greater) = splitBinary(equalGreater, value + 1)
  return (lower: lower, equal: equal, greater: greater)


type Tree = ref object
  root: Node

proc hasValue(self: Tree, x: int32): bool =
  let splited = split(self.root, x)
  let res = not splited.equal.isNil
  self.root = merge3(splited.lower, splited.equal, splited.greater)
  return res

proc insert(self: Tree, x: int32) =
  var splited = split(self.root, x)
  if splited.equal.isNil:
    splited.equal = newNode(x)
  self.root = merge3(splited.lower, splited.equal, splited.greater)

proc erase(self: Tree, x: int32) =
  let splited = split(self.root, x)
  self.root = merge(splited.lower, splited.greater)

proc main() =
  let tree = Tree()
  var cur = 5'i32
  var res = 0

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
      continue
  echo res

when isMainModule:
  main()
