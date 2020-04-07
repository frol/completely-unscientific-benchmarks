pub mod idiomatic_impl;
pub mod refcount_impl;
pub mod swap_forget_impl;
pub mod unsafe_impl;

pub trait TreeTrait {
    fn new() -> Self;
    fn has_value(&mut self, x: i32) -> bool;
    fn insert(&mut self, x: i32);
    fn erase(&mut self, x: i32);
}

pub fn main_impl(mut tree: impl TreeTrait) {
    let mut cur = 5;
    let mut res = 0;
    for i in 1..1_000_000 {
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
