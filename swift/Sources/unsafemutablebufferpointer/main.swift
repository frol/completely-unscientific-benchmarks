import Foundation

typealias NodeIndex = Int


// MARK: -Node
fileprivate struct Node {
    // MARK: properties
    var x: Int
    var y: Int = Int.random(in: 0...Int.max)
    var left: NodeIndex?
    var right: NodeIndex?
}


// MARK: -Tree
fileprivate class Tree {
    // MARK: methods
    func contains(_ value: Int) -> Bool {
        let splitted = split(root: mRoot, value: value)
        mRoot = merge(lower: splitted.lower, equal: splitted.equal, greater: splitted.greater)
        return splitted.equal != nil
    }
    
    func insert(_ value: Int) {
        var splitted = split(root: mRoot, value: value)
        if splitted.equal == nil {
            splitted.equal = nextNodeIndex
            nodeHolder[nextNodeIndex] = Node(x: value)
            nextNodeIndex += 1
        }
        mRoot = merge(lower: splitted.lower, equal: splitted.equal, greater: splitted.greater)
    }
    
    func erase(_ value: Int) {
        let splited = split(root: mRoot, value: value)
        mRoot = merge(lower: splited.lower, greater: splited.greater)
    }

    func merge(lower: NodeIndex?, equal: NodeIndex?, greater: NodeIndex?) -> NodeIndex? {
        return merge(lower: merge(lower: lower, greater: equal), greater: greater)
    }

    func merge(lower: NodeIndex?, greater: NodeIndex?) -> NodeIndex? {
        if let lower = lower, let greater = greater {
            if nodeHolder[lower]!.y < nodeHolder[greater]!.y {
                nodeHolder[lower]!.right = merge(lower: nodeHolder[lower]!.right, greater: greater)
                return lower
            } else {
                nodeHolder[greater]!.left = merge(lower: lower, greater: nodeHolder[greater]!.left)
                return greater
            }
        } else if lower == nil {
            return greater
        } else {
            return lower
        }

    }

    func split(root: NodeIndex?, value: Int) -> (lower: NodeIndex?, equal: NodeIndex?, greater: NodeIndex?) {
        let (lower, equalGreater) = splitBinary(root: root, value: value)
        let (equal, greater) = splitBinary(root: equalGreater, value: value + 1)
        return (lower: lower, equal: equal, greater: greater)
    }

    func splitBinary(root: NodeIndex?, value: Int) -> (NodeIndex?, NodeIndex?) {
        guard let root = root else { return (nil, nil) }

        if nodeHolder[root]!.x < value {
            let splitPair = splitBinary(root: nodeHolder[root]!.right, value: value)
            nodeHolder[root]!.right = splitPair.0
            return (root, splitPair.1)
        } else {
            let splitPair = splitBinary(root: nodeHolder[root]!.left, value: value)
            nodeHolder[root]!.left = splitPair.1
            return (splitPair.0, root)
        }
    }


    // MARK: private properties
    private var mRoot: NodeIndex?
    private var nodeHolder = UnsafeMutableBufferPointer<Node?>.allocate(capacity: 1_000_000)
    private var nextNodeIndex: NodeIndex = 0
}


// MARK: -The Test
func runNaive() -> Int
{
    let tree = Tree()
    var current = 5
    var result = 0

    for i in 1..<1_000_000 {
        current = (current * 57 + 43) % 10007
        switch i % 3 {
            case 0: tree.insert(current)
            case 1: tree.erase(current)
            case 2: if tree.contains(current) { result += 1 }
            default: break
        }
    }
    return result
}

print("Naive result \(runNaive())")
