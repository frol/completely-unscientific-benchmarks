import random

type Node = ref object
    x: int
    y: int
    left: Node
    right: Node

proc new_node(x: int): Node =
    return Node(x: x, y: rand(2147483647), left: nil, right: nil)

proc merge(lower: Node, greater: Node): Node =
    if lower == nil:
        return greater
    
    if greater == nil:
        return lower
    
    if lower.y < greater.y:
        lower.right = merge(lower.right, greater)
        return lower
    else:
        greater.left = merge(lower, greater.left)
        return greater

proc splitBinary(orig: Node, value: int): (Node, Node) =
    if orig == nil:
        return (nil, nil)
    
    if orig.x < value:
        let splitPair = splitBinary(orig.right, value)
        orig.right = splitPair[0]
        return (orig, splitPair[1])
    else:
        let splitPair = splitBinary(orig.left, value)
        orig.left = splitPair[1]
        return (splitPair[0], orig)

proc merge3(lower: Node, equal: Node, greater: Node): Node =
    return merge(merge(lower, equal), greater)


type SplitResult = object
    lower: Node
    equal: Node
    greater: Node


proc split(orig: Node, value: int): SplitResult =
    let (lower, equalGreater) = splitBinary(orig, value)
    let (equal, greater) = splitBinary(equalGreater, value + 1)
    return SplitResult(lower: lower, equal: equal, greater: greater)


type Tree = ref object
    root: Node

proc has_value(self: Tree, x: int): bool =
    let splited = split(self.root, x)
    let res = splited.equal != nil
    self.root = merge3(splited.lower, splited.equal, splited.greater)
    return res

proc insert(self: Tree, x: int) =
    var splited = split(self.root, x)
    if splited.equal == nil:
        splited.equal = new_node(x)
    self.root = merge3(splited.lower, splited.equal, splited.greater)

proc erase(self: Tree, x: int) =
    let splited = split(self.root, x)
    self.root = merge(splited.lower, splited.greater)

proc main() =
    let tree = Tree()
    var cur = 5
    var res = 0

    for i in countup(1, 1000000):
        let a = cur mod 3
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
