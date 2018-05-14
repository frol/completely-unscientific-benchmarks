import Foundation

class Node {
    var x: Int
    var y: Int
    var left: Node? = nil
    var right: Node? = nil

    init(x: Int) {
        self.x = x
        self.y = Int(rand())
    }
}

func merge(lower: Node?, greater: Node?) -> Node?
{
    if let lower = lower, let greater = greater {   
        if lower.y < greater.y {
            lower.right = merge(lower: lower.right, greater: greater)
            return lower
        } else {
            greater.left = merge(lower: lower, greater: greater.left)
            return greater
        }
    } else if lower == nil {
    	return greater
    } else {
    	return lower
    }
 
}

func splitBinary(orig: Node?, value: Int) -> (Node?, Node?)
{
    if let orig = orig {
        if orig.x < value {
            let splitPair = splitBinary(orig: orig.right, value: value)
            orig.right = splitPair.0
            return (orig, splitPair.1)
        } else {
            let splitPair = splitBinary(orig: orig.left, value: value)
            orig.left = splitPair.1
            return (splitPair.0, orig)
        }
    } else {
    	return (nil, nil)
    }
}

func merge(lower: Node?, equal: Node?, greater: Node?) -> Node?
{
    return merge(lower: merge(lower: lower, greater: equal), greater: greater)
}

class SplitResult {
    var lower: Node?
    var equal: Node?
    var greater: Node?

    init(lower: Node?, equal: Node?, greater: Node?) {
        self.lower = lower
        self.equal = equal
        self.greater = greater
    }
}

func split(orig: Node?, value: Int) -> SplitResult
{
    let (lower, equalGreater) = splitBinary(orig: orig, value: value)
    let (equal, greater) = splitBinary(orig: equalGreater, value: value + 1)
    return SplitResult(lower: lower, equal: equal, greater: greater)
}

class Tree
{
    public func hasValue(x: Int) -> Bool
    {
        let splited = split(orig: mRoot, value: x)
        let res = splited.equal != nil
        mRoot = merge(lower: splited.lower, equal: splited.equal, greater: splited.greater)
        return res
    }
    
    public func insert(x: Int)
    {
        let splited = split(orig: mRoot, value: x)
        if splited.equal == nil {
        	splited.equal = Node(x: x)
        }
        mRoot = merge(lower: splited.lower, equal: splited.equal, greater: splited.greater)
    }
    
    public func erase(x: Int)
    {
        let splited = split(orig: mRoot, value: x)
        mRoot = merge(lower: splited.lower, greater: splited.greater)
    }
    
    private var mRoot: Node? = nil
}

func main() 
{
    let tree = Tree()
    var cur = 5;
    var res = 0

    for i in 1..<1000000 {
        let a = i % 3
        cur = (cur * 57 + 43) % 10007
        switch a {
            case 0: tree.insert(x: cur)
            case 1: tree.erase(x: cur)
            case 2: if tree.hasValue(x: cur) { res += 1 }
            default: break
        }
    }
    print(res)
}

main()
