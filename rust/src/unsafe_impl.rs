use std::ptr::null_mut;

type NodePtr = *mut Node;

struct Node {
    x: i32,
    y: i32,
    left: NodePtr,
    right: NodePtr,
}

impl Drop for Node {
    fn drop(&mut self) {
        if !self.left.is_null() {
            drop(unsafe { Box::from_raw(self.left) });
        }
        if !self.right.is_null() {
            drop(unsafe { Box::from_raw(self.right) });
        }
    }
}

impl Node {
    fn new(x: i32) -> Self {
        Self {
            x,
            y: rand::random::<i32>(),
            left: null_mut(),
            right: null_mut(),
        }
    }
}

fn merge(lower: NodePtr, greater: NodePtr, res: &mut NodePtr) {
    *res = {
        if lower.is_null() {
            greater
        } else if greater.is_null() {
            lower
        } else {
            unsafe {
                if (*lower).y < (*greater).y {
                    merge((*lower).right, greater, &mut (*lower).right);
                    lower
                } else {
                    merge(lower, (*greater).left, &mut (*greater).left);
                    greater
                }
            }
        }
    };
}

fn merge3(lower: NodePtr, equal: NodePtr, greater: NodePtr, res: &mut NodePtr) {
    merge(lower, equal, res);
    merge(*res, greater, res);
}

fn split(orig: NodePtr, val: i32, lower: &mut NodePtr, greater_or_equal: &mut NodePtr) {
    if orig.is_null() {
        *lower = null_mut();
        *greater_or_equal = null_mut();
    } else {
        unsafe {
            if (*orig).x < val {
                *lower = orig;
                split((**lower).right, val, &mut (**lower).right, greater_or_equal);
            } else {
                *greater_or_equal = orig;
                split(
                    (**greater_or_equal).left,
                    val,
                    lower,
                    &mut (**greater_or_equal).left,
                );
            }
        }
    }
}

fn split5(
    orig: NodePtr,
    val: i32,
    lower: &mut NodePtr,
    equal: &mut NodePtr,
    greater: &mut NodePtr,
) {
    let mut equal_or_greater = null_mut();
    split(orig, val, lower, &mut equal_or_greater);
    split(equal_or_greater, val + 1, equal, greater);
}

pub struct Tree {
    root: NodePtr,
}

impl Drop for Tree {
    fn drop(&mut self) {
        if !self.root.is_null() {
            drop(unsafe { Box::from_raw(self.root) });
        }
    }
}

impl crate::TreeTrait for Tree {
    fn new() -> Self {
        Self { root: null_mut() }
    }

    fn has_value(&mut self, x: i32) -> bool {
        let mut lower = null_mut();
        let mut equal = null_mut();
        let mut greater = null_mut();
        split5(self.root, x, &mut lower, &mut equal, &mut greater);
        let res = !equal.is_null();
        merge3(lower, equal, greater, &mut self.root);
        res
    }

    fn insert(&mut self, x: i32) {
        let mut lower = null_mut();
        let mut equal = null_mut();
        let mut greater = null_mut();
        split5(self.root, x, &mut lower, &mut equal, &mut greater);
        if equal.is_null() {
            equal = Box::into_raw(Box::new(Node::new(x)));
        }

        merge3(lower, equal, greater, &mut self.root);
    }

    fn erase(&mut self, x: i32) {
        let mut lower = null_mut();
        let mut equal = null_mut();
        let mut greater = null_mut();
        split5(self.root, x, &mut lower, &mut equal, &mut greater);
        merge(lower, greater, &mut self.root);
        if !equal.is_null() {
            drop(unsafe { Box::from_raw(equal) });
        }
    }
}
