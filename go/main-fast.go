package main

import "math/rand"

type Node struct {
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
	}
}

type Tree struct {
	Root *Node
}

func (t *Tree) HasValue(v int) bool {
	splitted := split(t.Root, v)
	res := splitted.Equal != nil
	t.Root = merge3(splitted.Lower, splitted.Equal, splitted.Greater)
	return res
}

func (t *Tree) Insert(v int) error {
	splitted := split(t.Root, v)
	if splitted.Equal == nil {
		splitted.Equal = NewNode(v)
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
	Lower   *Node
	Equal   *Node
	Greater *Node
}

func merge(lower, greater *Node) *Node {
	if lower == nil {
		return greater
	}

	if greater == nil {
		return lower
	}

	if lower.Y < greater.Y {
		right := merge(lower.Right, greater)
		lower.Right = right
		return lower
	}
	left := merge(lower, greater.Left)
	greater.Left = left
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

func split(original *Node, value int) SplitResult {
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

	println(res)
}
