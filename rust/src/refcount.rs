use rand::{self, Rng};
use std::cell::RefCell;
use std::rc::Rc;

type NodePtr = Option<Rc<RefCell<Node>>>;

struct Node {
    x: i32,
    y: i32,
    left: NodePtr,
    right: NodePtr,
}

impl Node {
    fn new<R: Rng>(rng: &mut Rng, x: i32) -> Self {
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
    let mut result = (None, None);
    if let Some(orig_val) = orig {
        if orig_val.borrow().x < value {
            {
                let mut orig_node = orig_val.borrow_mut();
                let split_pair = split_binary(orig_node.right.take(), value);
                orig_node.right = split_pair.0;
                result.1 = split_pair.1;
            }
            result.0 = Some(orig_val);
        } else {
            {
                let mut orig_node = orig_val.borrow_mut();
                let split_pair = split_binary(orig_node.left.clone(), value);
                orig_node.left = split_pair.1;
                result.0 = split_pair.0;
            }
            result.1 = Some(orig_val);
        }
    }
    result
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

pub struct Tree {
    root: NodePtr,
}

impl Tree {
    pub fn new() -> Self {
        Self { root: None }
    }

    pub fn has_value(&mut self, x: i32) -> bool {
        let splited = split(self.root.take(), x);
        let res = splited.equal.is_some();
        self.root = merge3(splited.lower, splited.equal, splited.greater);
        res
    }

    pub fn insert<R: Rng>(&mut self, rng: &mut R, x: i32) {
        let mut splited = split(self.root.take(), x);
        if splited.equal.is_none() {
            splited.equal = Some(Rc::new(RefCell::new(Node::new(rng, x))))
        }
        self.root = merge3(splited.lower, splited.equal, splited.greater);
    }

    pub fn erase(&mut self, x: i32) {
        let splited = split(self.root.take(), x);
        self.root = merge(splited.lower, splited.greater);
    }
}
