# Rust

Author: Vlad Frolov (@frol)

## Compile

NOTE: The idiomatic, refcount, and unsafe versions of this benchmark are locked behind feature gates.

```
cargo build --release --features refcount
strip -s target/release/rust
```

```
cargo build --release --features refcount
strip -s target/release/rust
```

```
cargo build --release --features unsafe
strip -s target/release/rust
```

## Execute

```
./target/release/rust
```
