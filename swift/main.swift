import Foundation

private func OSReadRandom(into buffer: UnsafeMutableRawPointer, size: Int) {
#if os(Linux)
    let fd = open("/dev/urandom", O_RDONLY)
    precondition(fd >= 0)
    defer { close(fd) }
    let status = read(fd, buffer, size)
    precondition(status > 0)
#elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    arc4random_buff(buffer, size)
#endif
}

public struct SplitMix64 {
    var state: UInt64

    public init() {
        var seed: UInt64 = 0
        OSReadRandom(into: &seed, size: MemoryLayout<UInt64>.size)
        state = seed
    }

    public mutating func next() -> UInt64 {
        state = state &+ 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9;
	    z = (z ^ (z >> 27)) &* 0x94d049bb133111eb;
	    return z ^ (z >> 31);
    }
}

public struct XoroShiro128Plus {
    var state: (UInt64, UInt64)

    public init() {
        var seeds = SplitMix64()
        repeat {
            state = (seeds.next(), seeds.next())
        } while state == (0, 0)
    }

    public mutating func next() -> UInt64 {
        func rotl(_ x: UInt64, _ n: UInt64) -> UInt64 {
            return (x << n) | (x >> (64 - n))
        }
	    
	    let result = state.0 &+ state.1
	    let t = state.0 ^ state.1
	    state = (rotl(state.0, 24) ^ t ^ (t << 16), rotl(t, 37))
	    return result
    }

    public mutating func next(upTo limit: Int) -> Int {
        return Int(truncatingIfNeeded: next()).multipliedFullWidth(by: limit).high
    }
}

var priorities = XoroShiro128Plus()

final class Node {
    let key: Int
    let priority: Int
    var left: Node?
    var right: Node?

    init(_ key: Int, priority: Int = priorities.next(upTo: 100)) {
        self.key = key
        self.priority = priority
    }
}

extension Node {
    static func rotateRight(_ root: inout Node) {
        let newRoot = root.left!
        root.left = newRoot.right
        newRoot.right = root
        root = newRoot
    }

    static func rotateLeft(_ root: inout Node) {
        let newRoot = root.right!
        root.right = newRoot.left
        newRoot.left = root
        root = newRoot
    }

    static func insert(_ node: Node, into root: inout Node?) {
        guard var newRoot = root else { root = node; return }
        defer { root = newRoot }
        if node.key < newRoot.key {
            insert(node, into: &newRoot.left)
            if newRoot.priority < newRoot.left!.priority { rotateRight(&newRoot) }
        } else {
            insert(node, into: &newRoot.right)
            if newRoot.priority < newRoot.right!.priority { rotateLeft(&newRoot) }
        }
    }

    static func found(_ key: Int, in root: Node?) -> Bool {
        guard let root = root else { return false }
        guard root.key != key else { return true }
        let next = key < root.key ? root.left : root.right
        return found(key, in: next)
    }

    static func remove(_ key: Int, from root: inout Node?) {
        guard let current = root else { return }
        guard key != current.key else { delete(&root); return }
        if key < current.key {
            remove(key, from: &current.left)
        } else {
            remove(key, from: &current.right)
        }
    }

    static func delete(_ node: inout Node?) {
        guard var current = node else { return }

        switch (current.left, current.right) {
        case (nil, nil): node = nil
        case let (left?, nil): node = left
        case let (nil, right?): node = right
        case let (left?, right?) where left.priority < right.priority:
            let key = current.key
            rotateLeft(&current)
            remove(key, from: &current.left)
            node = current
        case (_, _):
            let key = current.key
            rotateRight(&current)
            remove(key, from: &current.right)
            node = current
        }
    }

    func deepCopy() -> Node {
        let root = Node(key, priority: priority)
        root.left = left?.deepCopy()
        root.right = right?.deepCopy()
        return root
    }
}

public struct Treap {
    var root: Node?

    public init() { }

    public mutating func insert(_ value: Int) {
        if !isKnownUniquelyReferenced(&root) {
            root = root?.deepCopy()
        }
        Node.insert(Node(value), into: &root)
    }

    public func contains(_ value: Int) -> Bool {
        return Node.found(value, in: root)
    }

    public mutating func remove(_ value: Int) {
        if !isKnownUniquelyReferenced(&root) {
            root = root?.deepCopy()
        }
        Node.remove(value, from: &root)
    }
}

func main() {
    var tree = Treap()
    var current = 5, matches = 0

    for i in 1..<1_000_000 {
        current = (current * 57 + 43) % 10007
        switch i % 3 {
        case 0: tree.insert(current)
        case 1: tree.remove(current)
        case _: if tree.contains(current) { matches += 1 }
        }
    }
    print(matches)
}

main()
