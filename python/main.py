#!/usr/bin/env python
import random

class Node:
    __slots__ = ['x', 'y', 'left', 'right']

    def __init__(self, x):
        self.x = x
        self.y = random.random()
        self.left = None
        self.right = None


def merge(lower, greater):
    if lower is None:
        return greater

    if greater is None:
        return lower

    if lower.y < greater.y:
        lower.right = merge(lower.right, greater)
        return lower
    else:
        greater.left = merge(lower, greater.left)
        return greater

def splitBinary(orig, value):
    if orig is None:
        return (None, None)

    if orig.x < value:
        splitPair = splitBinary(orig.right, value)
        orig.right = splitPair[0]
        return (orig, splitPair[1])
    else:
        splitPair = splitBinary(orig.left, value)
        orig.left = splitPair[1]
        return (splitPair[0], orig)

def merge3(lower, equal, greater):
    return merge(merge(lower, equal), greater)


class SplitResult:
    __slots__ = ('lower', 'equal', 'greater')

    def __init__(self, lower, equal, greater):
        self.lower = lower
        self.equal = equal
        self.greater = greater


def split(orig, value):
    lower, equalGreater = splitBinary(orig, value)
    equal, greater = splitBinary(equalGreater, value + 1)
    return SplitResult(lower, equal, greater)


class Tree:
    __slots__ = ['root']

    def __init__(self):
        self.root = None

    def has_value(self, x):
        splited = split(self.root, x)
        res = splited.equal is not None
        self.root = merge3(splited.lower, splited.equal, splited.greater)
        return res

    def insert(self, x):
        splited = split(self.root, x)
        if splited.equal is None:
            splited.equal = Node(x)
        self.root = merge3(splited.lower, splited.equal, splited.greater)

    def erase(self, x):
        splited = split(self.root, x)
        self.root = merge(splited.lower, splited.greater)

def main():
    tree = Tree()
    cur = 5
    res = 0

    for i in range(1, 1000000):
        a = i % 3
        cur = (cur * 57 + 43) % 10007
        if a == 0:
            tree.insert(cur)
        elif a == 1:
            tree.erase(cur)
        elif a == 2:
            res += 1 if tree.has_value(cur) else 0
    print(res)

if __name__ == '__main__':
    main()
