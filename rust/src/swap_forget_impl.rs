use std::mem;

type NodeCell = Option<Box<Node>>;

struct Node {
    x: i32,
    y: i32,
    left: NodeCell,
    right: NodeCell,
}

impl Node {
    fn new(x: i32) -> Self {
        Self {
            x,
            y: rand::random::<i32>(),
            left: None,
            right: None,
        }
    }
}

fn merge(lower: NodeCell, greater: NodeCell) -> NodeCell {
    match (lower, greater) {
        (None, greater) => greater,

        (lower, None) => lower,

        (Some(mut lower_node), Some(mut greater_node)) => {
            if lower_node.y < greater_node.y {
                let mut merged = merge(lower_node.right.take(), Some(greater_node));
                mem::swap(&mut lower_node.right, &mut merged);
                mem::forget(merged);
                Some(lower_node)
            } else {
                let mut merged = merge(Some(lower_node), greater_node.left.take());
                mem::swap(&mut greater_node.left, &mut merged);
                mem::forget(merged);
                Some(greater_node)
            }
        }
    }
}

fn split_binary(orig: NodeCell, value: i32) -> (NodeCell, NodeCell) {
    if let Some(mut orig_node) = orig {
        if orig_node.x < value {
            let mut split_pair = split_binary(orig_node.right.take(), value);
            mem::swap(&mut orig_node.right, &mut split_pair.0);
            debug_assert!(split_pair.0.is_none());
            mem::forget(split_pair.0);
            (Some(orig_node), split_pair.1)
        } else {
            let mut split_pair = split_binary(orig_node.left.take(), value);
            mem::swap(&mut orig_node.left, &mut split_pair.1);
            debug_assert!(split_pair.1.is_none());
            mem::forget(split_pair.1);
            (split_pair.0, Some(orig_node))
        }
    } else {
        (None, None)
    }
}

fn merge3(lower: NodeCell, equal: NodeCell, greater: NodeCell) -> NodeCell {
    merge(merge(lower, equal), greater)
}

struct SplitResult {
    lower: NodeCell,
    equal: NodeCell,
    greater: NodeCell,
}

fn split(orig: NodeCell, value: i32) -> SplitResult {
    let (lower, equal_greater) = split_binary(orig, value);
    let (equal, greater) = split_binary(equal_greater, value + 1);
    SplitResult {
        lower,
        equal,
        greater,
    }
}

pub struct Tree {
    root: NodeCell,
}

impl crate::TreeTrait for Tree {
    fn new() -> Self {
        Self { root: None }
    }

    fn has_value(&mut self, x: i32) -> bool {
        let splited = split(self.root.take(), x);
        let res = splited.equal.is_some();
        self.root = merge3(splited.lower, splited.equal, splited.greater);
        res
    }

    fn insert(&mut self, x: i32) {
        let mut splited = split(self.root.take(), x);
        if splited.equal.is_none() {
            splited.equal = Some(Box::new(Node::new(x)));
        }
        self.root = merge3(splited.lower, splited.equal, splited.greater);
    }

    fn erase(&mut self, x: i32) {
        let splited = split(self.root.take(), x);
        self.root = merge(splited.lower, splited.greater);
    }
}
