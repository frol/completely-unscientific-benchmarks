extern crate rand;

#[cfg(feature = "idiomatic")]
mod idiomatic;

#[cfg(feature = "idiomatic")]
use idiomatic::Tree;

#[cfg(feature = "refcount")]
mod refcount;

#[cfg(feature = "refcount")]
use refcount::Tree;

fn main() {
    let mut rng = rand::weak_rng();
    let mut tree = Tree::new();
    let mut cur = 5;
    let mut res = 0;
    for i in 1..1000000 {
        let a = i % 3;
        cur = (cur * 57 + 43) % 10007;
        match a {
            0 => tree.insert(&mut rng, cur),
            1 => tree.erase(cur),
            2 => res += if tree.has_value(cur) { 1 } else { 0 },
            _ => {}
        }
    }
    println!("{}", res);
}
