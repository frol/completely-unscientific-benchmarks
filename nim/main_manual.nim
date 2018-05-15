import random

type
  NodeObj = object
    x, y: int32
    left, right: Node
  Node = ptr NodeObj

proc destroy(self: Node) =
  if not self.isNil:
    if not self.left.isNil:
      destroy self.left
      self.left = nil
    if not self.right.isNil:
      destroy self.right
      self.right = nil

    dealloc self

proc createNode(x: int32): Node =
  result = create NodeObj
  result.x = x
  result.y = int32 rand(high int32)

proc merge(lower, greater: Node): Node =
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

proc splitBinary(orig: Node, value: int32): (Node, Node) =
  if orig.isNil:
    (nil, nil)
  elif orig.x < value:
    let splitPair = splitBinary(orig.right, value)
    orig.right = splitPair[0]
    (orig, splitPair[1])
  else:
    let splitPair = splitBinary(orig.left, value)
    orig.left = splitPair[1]
    (splitPair[0], orig)

proc merge3(lower, equal, greater: Node): Node =
  merge(merge(lower, equal), greater)

proc split(orig: Node, value: int32): tuple[lower, equal, greater: Node] =
  let
    (lower, equalGreater) = splitBinary(orig, value)
    (equal, greater) = splitBinary(equalGreater, value + 1)
  (lower, equal, greater)

type Tree = object
  root: Node

proc destroy(self: var Tree) =
  destroy self.root
  self.root = nil

proc hasValue(self: var Tree, x: int32): bool =
  let splited = split(self.root, x)
  result = not splited.equal.isNil
  self.root = merge3(splited.lower, splited.equal, splited.greater)

proc insert(self: var Tree, x: int32) =
  var splited = split(self.root, x)
  if splited.equal.isNil:
    splited.equal = createNode(x)
  self.root = merge3(splited.lower, splited.equal, splited.greater)

proc erase(self: var Tree, x: int32) =
  let splited = split(self.root, x)
  self.root = merge(splited.lower, splited.greater)
  if not splited.equal.isNil:
    destroy splited.equal

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
  stdout.write res
  destroy tree

when isMainModule:
  main()
