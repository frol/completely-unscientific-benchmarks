package main

import (
	"fmt"
	"math/rand"
	"time"
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

// Tree represents a treap
type Tree struct {
	root *Node
}

// Insert inserts a value into the treap
func (t *Tree) Insert(v int) {
	t.root = t.root.Insert(v)
}

// Erase removes a value from the treap
func (t *Tree) Erase(v int) {
	t.root = t.root.Erase(v)
}

// HasValue checks if the treap contains a value
func (t *Tree) HasValue(v int) bool {
	return t.root.HasValue(v)
}

// Node represents a node in the treap
type Node struct {
	X, Y        int
	Left, Right *Node
}

// NewNode creates a new node with a value and a random weight
func NewNode(v int) *Node {
	return &Node{
		X: v,
		Y: rand.Int(),
	}
}

// HasValue checks if the current node, or related nodes, contain a value
func (n *Node) HasValue(v int) bool {
	lower, equal, greater := n.split(v)
	merge(merge(lower, equal), greater)
	return equal != nil
}

// Insert inserts a value in the correct place in or below the current node
func (n *Node) Insert(v int) *Node {
	lower, equal, greater := n.split(v)
	if equal == nil {
		equal = NewNode(v)
	}
	return merge(merge(lower, equal), greater)
}

// Erase deletes a node with a specified value from the tree
func (n *Node) Erase(v int) *Node {
	lower, _, greater := n.split(v)

	return merge(lower, greater)
}

// split splits the tree between binary equal and greater node-links
func (n *Node) split(v int) (lower, equal, greater *Node) {
	var equalGreater *Node

	lower, equalGreater = n.splitBinary(v)
	equal, greater = equalGreater.splitBinary(v + 1)

	return
}

// splitbinary splits the tree in twain on a value
func (n *Node) splitBinary(v int) (left, right *Node) {
	if n == nil {
		return
	}

	if n.X < v {
		left = n
		n.Right, right = n.Right.splitBinary(v)
	} else {
		right = n
		left, n.Left = n.Left.splitBinary(v)
	}

	return
}

// merge two nodes
func merge(left, right *Node) (result *Node) {
	if left == nil {
		result = right
	} else if right == nil {
		result = left
	} else if left.Y > right.Y {
		result, left.Right = left, merge(left.Right, right)
	} else {
		result, right.Left = right, merge(left, right.Left)
	}

	return
}

func main() {
	t := &Tree{}

	cur := 5
	res := 0

	for i := 1; i < 1000000; i++ {
		a := i % 3
		cur = (cur*57 + 43) % 10007
		if a == 0 {
			t.Insert(cur)
		} else if a == 1 {
			t.Erase(cur)
		} else if a == 2 {
			if t.HasValue(cur) {
				res++
			}
		}
	}

	fmt.Println(res)
}
