
import Foundation


fileprivate class Node {
    var x: Int
    var y: Int
    var left: Unmanaged<Node>? = nil
    var right: Unmanaged<Node>? = nil
    
    init(x: Int) {
        self.x = x
        self.y = Int.random(in: 0...Int.max)
    }
}

fileprivate class Tree
{
    var root: Unmanaged<Node>? = nil
}


fileprivate func merge(lower: Unmanaged<Node>?, greater: Unmanaged<Node>?) -> Unmanaged<Node>?
{
    if let lower = lower, let greater = greater {
        return lower._withUnsafeGuaranteedRef { lowerRef in
            return greater._withUnsafeGuaranteedRef { greaterRef in
                if lowerRef.y < greaterRef.y {
                    lowerRef.right = merge(lower: lowerRef.right, greater: greater)
                    return lower
                } else {
                    greaterRef.left = merge(lower: lower, greater: greaterRef.left)
                    return greater
                }
            }
        }
    } else if lower == nil {
        return greater
    } else {
        return lower
    }
    
}

fileprivate func splitBinary(orig: Unmanaged<Node>?, value: Int) -> (Unmanaged<Node>?, Unmanaged<Node>?)
{
    if let orig = orig {
        return orig._withUnsafeGuaranteedRef {
            if $0.x < value {
                let splitPair = splitBinary(orig: $0.right, value: value)
                $0.right = splitPair.0
                return (orig, splitPair.1)
            } else {
                let splitPair = splitBinary(orig: $0.left, value: value)
                $0.left = splitPair.1
                return (splitPair.0, orig)
            }
        }

    } else {
        return (nil, nil)
    }
}

fileprivate func merge(lower: Unmanaged<Node>?, equal: Unmanaged<Node>?, greater: Unmanaged<Node>?) -> Unmanaged<Node>?
{
    return merge(lower: merge(lower: lower, greater: equal), greater: greater)
}

fileprivate class SplitResult {
    var lower: Unmanaged<Node>?
    var equal: Unmanaged<Node>?
    var greater: Unmanaged<Node>?
    
    init(lower: Unmanaged<Node>?, equal: Unmanaged<Node>?, greater: Unmanaged<Node>?) {
        self.lower = lower
        self.equal = equal
        self.greater = greater
    }
}

fileprivate func split(orig: Unmanaged<Node>?, value: Int) -> SplitResult
{
    let (lower, equalGreater) = splitBinary(orig: orig, value: value)
    let (equal, greater) = splitBinary(orig: equalGreater, value: value + 1)
    return SplitResult(lower: lower, equal: equal, greater: greater)
}

fileprivate func hasValue(_ tree: Unmanaged<Tree>, x: Int) -> Bool {
    return tree._withUnsafeGuaranteedRef {
        let splited = split(orig: $0.root, value: x)
        let res = splited.equal != nil
        $0.root = merge(lower: splited.lower, equal: splited.equal, greater: splited.greater)
        return res
    }
}

fileprivate func insert(_ tree: Unmanaged<Tree>, x: Int)
{
    // 1. split into greater, equal, lower trees
    // 2. if there is no equal tree, create it,
    // 3. merge into lower, equal, greater
    tree._withUnsafeGuaranteedRef {
        let splited = split(orig: $0.root, value: x)
        if splited.equal == nil {
            splited.equal = Unmanaged.passRetained(Node(x: x))
        }
        $0.root = merge(lower: splited.lower, equal: splited.equal, greater: splited.greater)
    }
}

fileprivate func erase(_ tree: Unmanaged<Tree>, x: Int)
{
    // 1. split into greater, equal, lower trees
    // 2. merge greater and lower trees
    // 3. equal is left out.
    tree._withUnsafeGuaranteedRef {
        let splited = split(orig: $0.root, value: x)
        $0.root = merge(lower: splited.lower, greater: splited.greater)
        if splited.equal != nil {
            splited.equal!.release()
        }
    }
}

fileprivate func cleanup(_ node: Unmanaged<Node>?) {
    if let node = node {
        node._withUnsafeGuaranteedRef {
            cleanup($0.left)
            cleanup($0.right)
        }
        node.release()
    }
}

func runUnmanaged() -> Int {
    let tree = Tree()
    var cur = 5;
    var res = 0
    
    let Ref = Unmanaged.passUnretained(tree)
    
    for i in 1..<1000000 {
        let a = i % 3
        cur = (cur * 57 + 43) % 10007
        switch a {
        case 0: insert(Ref, x: cur)
        case 1: erase(Ref, x: cur)
        case 2: if hasValue(Ref, x: cur) { res += 1 }
        default: break
        }
    }
    cleanup(tree.root)
    return res
}

print("Unmanaged result \(runUnmanaged())")