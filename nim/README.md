# Nim

Author: Vlad Frolov (@frol)

## Compile

```
nim compile -d:release --passC:-flto --out:main-nim main.nim
strip -s main-nim
```

For maximum performance ([memory is the trade-off](https://github.com/frol/completely-unscientific-benchmarks/pull/1)):

```
nim compile -d:release --passC:-flto --gc:markAndSweep --out:main-nim main.nim
strip -s main-nim
```

## Execute

```
./main-nim
```
