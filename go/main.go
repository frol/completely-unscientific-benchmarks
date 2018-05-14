package main

import (
	"fmt"
	"math/rand"
)

type Node struct {
	notEmpty bool
	X        int
	Y        int
	Left     *Node
	Right    *Node
}

func NewNode(v int) *Node {
	y := rand.Int()
	return &Node{
		X:        v,
		Y:        y,
		notEmpty: true,
	}
}

type Tree struct {
	Root Node
}

func (t *Tree) HasValue(v int) bool {
	splitted := split(t.Root, v)
	res := splitted.Equal.notEmpty
	t.Root = merge3(splitted.Lower, splitted.Equal, splitted.Greater)
	return res
}

func (t *Tree) Insert(v int) error {
	splitted := split(t.Root, v)
	if !splitted.Equal.notEmpty {
		splitted.Equal = *NewNode(v)
	}
	t.Root = merge3(splitted.Lower, splitted.Equal, splitted.Greater)
	return nil
}

func (t *Tree) Erase(v int) error {
	splitted := split(t.Root, v)
	t.Root = merge(splitted.Lower, splitted.Greater)
	return nil
}

type SplitResult struct {
	Lower   Node
	Equal   Node
	Greater Node
}

func merge(lower, greater Node) Node {
	if !lower.notEmpty {
		return greater
	}

	if !greater.notEmpty {
		return lower
	}

	if lower.Y < greater.Y {
		if lower.Right == nil {
			lower.Right = &Node{}
		}
		right := merge(*lower.Right, greater)
		lower.Right = &right
		return lower
	}

	if greater.Left == nil {
		greater.Left = &Node{}
	}
	left := merge(lower, *greater.Left)
	greater.Left = &left
	return greater
}

func merge3(lower, equal, greater Node) Node {
	return merge(merge(lower, equal), greater)
}

func splitBinary(original Node, value int) (Node, Node) {
	if original == (Node{}) || !original.notEmpty {
		return Node{}, Node{}
	}

	if original.X < value {
		if original.Right == nil {
			original.Right = &Node{}
		}
		splitPair0, splitPair1 := splitBinary(*original.Right, value)
		original.Right = &splitPair0
		return original, splitPair1
	}

	if original.Left == nil {
		original.Left = &Node{}
	}
	splitPair0, splitPair1 := splitBinary(*original.Left, value)
	original.Left = &splitPair1
	return splitPair0, original
}

func split(original Node, value int) SplitResult {
	lower, equalGreater := splitBinary(original, value)
	equal, greater := splitBinary(equalGreater, value+1)
	return SplitResult{lower, equal, greater}
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
			has := t.HasValue(cur)
			if has {
				res += 1
			}
		}
	}

	fmt.Println(res)
}
