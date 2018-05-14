# Rust

Author: Vlad Frolov (@frol)

## Compile
NOTE: The idiomatic and refcount versions of this benchmark are locked behind feature gates.

```
cargo build --release --features refcount OR cargo build --release --features idiomatic
strip -s target/release/rust
```

## Execute

```
./target/release/rust
```
