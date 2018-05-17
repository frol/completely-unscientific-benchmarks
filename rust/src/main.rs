extern crate rand;

#[cfg(feature = "idiomatic")]
mod idiomatic_impl;

#[cfg(feature = "idiomatic")]
use idiomatic_impl::Tree;

#[cfg(feature = "refcount")]
mod refcount_impl;

#[cfg(feature = "refcount")]
use refcount_impl::Tree;

#[cfg(feature = "unsafe")]
mod unsafe_impl;

#[cfg(feature = "unsafe")]
use unsafe_impl::Tree;

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
