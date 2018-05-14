#![feature(rustc_private)]
use std::cell::RefCell;
use std::rc::Rc;

extern crate rand;

type NodePtr = Option<Rc<RefCell<Node>>>;

struct Node {
    x: i32,
    y: i32,
    left: NodePtr,
    right: NodePtr,
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

fn merge(lower: NodePtr, greater: NodePtr) -> NodePtr {
    match (lower, greater) {
        (None, greater) => greater,

        (lower, None) => lower,

        (Some(lower_rc), Some(greater_rc)) => {
            if lower_rc.borrow().y < greater_rc.borrow().y {
                {
                    let mut lower_node = lower_rc.borrow_mut();
                    lower_node.right = merge(lower_node.right.take(), Some(greater_rc));
                }
                Some(lower_rc)
            } else {
                {
                    let mut greater_node = greater_rc.borrow_mut();
                    greater_node.left = merge(Some(lower_rc), greater_node.left.take());
                }
                Some(greater_rc)
            }
        }
    }
}

fn split_binary(orig: NodePtr, value: i32) -> (NodePtr, NodePtr) {
    if let Some(orig_rc) = orig.clone() {
        let mut orig_node = orig_rc.borrow_mut();
        if orig_node.x < value {
            let split_pair = split_binary(orig_node.right.clone(), value);
            orig_node.right = split_pair.0;
            (orig, split_pair.1)
        } else {
            let split_pair = split_binary(orig_node.left.clone(), value);
            orig_node.left = split_pair.1;
            (split_pair.0, orig)
        }
    } else {
        (None, None)
    }
}

fn merge3(lower: NodePtr, equal: NodePtr, greater: NodePtr) -> NodePtr {
    merge(merge(lower, equal), greater)
}

struct SplitResult {
    lower: NodePtr,
    equal: NodePtr,
    greater: NodePtr,
}

fn split(orig: NodePtr, value: i32) -> SplitResult {
    let (lower, equal_greater) = split_binary(orig, value);
    let (equal, greater) = split_binary(equal_greater, value + 1);
    SplitResult {
        lower,
        equal,
        greater,
    }
}

struct Tree {
    root: NodePtr,
}

impl Tree {
    pub fn new() -> Self {
        Self { root: None }
    }

    pub fn has_value(&mut self, x: i32) -> bool {
        let splited = split(self.root.clone(), x);
        let res = splited.equal.is_some();
        self.root = merge3(splited.lower, splited.equal, splited.greater);
        res
    }

    pub fn insert(&mut self, x: i32) {
        let mut splited = split(self.root.clone(), x);
        if splited.equal.is_none() {
            splited.equal = Some(Rc::new(RefCell::new(Node::new(x))))
        }
        self.root = merge3(splited.lower, splited.equal, splited.greater);
    }

    pub fn erase(&mut self, x: i32) {
        let splited = split(self.root.clone(), x);
        self.root = merge(splited.lower, splited.greater);
    }
}

fn main() {
    let mut tree = Tree::new();
    let mut cur = 5;
    let mut res = 0;
    for i in 1..1000000 {
        let a = i % 3;
        cur = (cur * 57 + 43) % 10007;
        match a {
            0 => tree.insert(cur),
            1 => tree.erase(cur),
            2 => res += if tree.has_value(cur) { 1 } else { 0 },
            _ => {}
        }
    }
    println!("{}", res);
}
