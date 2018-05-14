# Rust

## Compile

NOTE: This compilation requires Nightly version of Rust to make it possible to
compile a single `.rs` file instead of Cargo project. You can easily avoid
Nightly if you create a cargo project (`cargo new --bin`) and put the source
code to `src/main.rs`.

```
rustc +nightly -O -o main-rs main.rs
strip -s main-rs
```

## Execute

```
./main-rs
```
