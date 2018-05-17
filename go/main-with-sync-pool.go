package main

import (
	"fmt"
	"math/rand"
	"sync"
)

type Node struct {
	X     int
	Y     int
	Left  *Node
	Right *Node
}

func (n *Node) Set(v int) {
	n.X = v
	n.Y = rand.Int()
}

type Tree struct {
	Root *Node
	pool *sync.Pool
}

func NewTree() *Tree {

	pool := sync.Pool{
		New: func() interface{} { return &Node{} },
	}
	return &Tree{
		Root: nil,
		pool: &pool,
	}
}

func (t *Tree) HasValue(v int) bool {
	lower, equal, greater := split(t.Root, v)
	res := equal != nil
	t.Root = merge3(lower, equal, greater)
	return res
}

func (t *Tree) Insert(v int) {
	lower, equal, greater := split(t.Root, v)
	if equal == nil {
		node := t.pool.Get().(*Node)
		node.Set(v)
		equal = node
	}
	t.Root = merge3(lower, equal, greater)
}

func (t *Tree) Erase(v int) {
	lower, equal, greater := split(t.Root, v)
	if equal != nil {
		t.pool.Put(equal)
	}
	t.Root = merge(lower, greater)
}

func merge(lower, greater *Node) *Node {
	if lower == nil {
		return greater
	}

	if greater == nil {
		return lower
	}

	if lower.Y < greater.Y {
		lower.Right = merge(lower.Right, greater)
		return lower
	}

	greater.Left = merge(lower, greater.Left)
	return greater
}

func merge3(lower, equal, greater *Node) *Node {
	return merge(merge(lower, equal), greater)
}

func splitBinary(original *Node, value int) (*Node, *Node) {
	if original == nil {
		return nil, nil
	}

	if original.X < value {
		splitPair0, splitPair1 := splitBinary(original.Right, value)
		original.Right = splitPair0
		return original, splitPair1
	}

	splitPair0, splitPair1 := splitBinary(original.Left, value)
	original.Left = splitPair1
	return splitPair0, original
}

func split(original *Node, value int) (lower, equal, greater *Node) {
	var equalGreater *Node
	lower, equalGreater = splitBinary(original, value)
	equal, greater = splitBinary(equalGreater, value+1)
	return lower, equal, greater
}

func treap(n int) int {
	t := NewTree()

	cur := 5
	res := 0

	for i := 1; i < n; i++ {
		a := i % 3
		cur = (cur*57 + 43) % 10007
		if a == 0 {
			t.Insert(cur)
		} else if a == 1 {
			t.Erase(cur)
		} else if a == 2 {
			has := t.HasValue(cur)
			if has {
				res++
			}
		}
	}
	return res
}
func main() {
	fmt.Println(treap(1000000))
}
