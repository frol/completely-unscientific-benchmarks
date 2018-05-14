import random

type Node = ref object
  x: int
  y: int
  left: Node
  right: Node

proc new_node(x: int): Node {.noinit.}=
  new result
  result.x = x
  result.y = rand(2147483647)
  result.left = nil
  result.right = nil

proc merge(lower: Node, greater: Node): Node {.noinit.}=
  if lower.isNil:
    return greater
  elif greater.isNil:
    return lower
  elif lower.y < greater.y:
    lower.right = merge(lower.right, greater)
    return lower
  else:
    greater.left = merge(lower, greater.left)
    return greater

proc splitBinary(orig: Node, value: int): (Node, Node) {.noinit.}=
  if orig.isNil:
    return (nil, nil)
  elif orig.x < value:
    let splitPair = splitBinary(orig.right, value)
    orig.right = splitPair[0]
    return (orig, splitPair[1])
  else:
    let splitPair = splitBinary(orig.left, value)
    orig.left = splitPair[1]
    return (splitPair[0], orig)

proc merge3(lower: Node, equal: Node, greater: Node): Node {.noInit.}=
  result = merge(merge(lower, equal), greater)

proc split(orig: Node, value: int): tuple[lower, equal, greater: Node] =
  let (lower, equalGreater) = splitBinary(orig, value)
  result.lower = lower
  (result.equal, result.greater) = splitBinary(equalGreater, value + 1)

type Tree = ref object
  root: Node

proc has_value(self: Tree, x: int): bool =
  let splited = split(self.root, x)
  result = not splited.equal.isNil
  self.root = merge3(splited.lower, splited.equal, splited.greater)

proc insert(self: Tree, x: int) =
  var splited = split(self.root, x)
  if splited.equal.isNil:
    splited.equal = new_node(x)
  self.root = merge3(splited.lower, splited.equal, splited.greater)

proc erase(self: Tree, x: int) =
  let splited = split(self.root, x)
  self.root = merge(splited.lower, splited.greater)

proc main() =
  let tree = Tree()
  var cur = 5
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
      if tree.has_value(cur):
        res += 1
    else:
      continue
  echo res

when isMainModule:
  main()
