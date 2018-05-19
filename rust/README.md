# Rust

Author: Vlad Frolov (@frol)

## Compile

NOTE: The idiomatic, swap_forget, refcount, and unsafe versions of this
benchmark are locked behind feature gates.

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
```

```
cargo build --release --features swap_forget
strip -s target/release/rust
```

## Execute

```
./target/release/rust
```
