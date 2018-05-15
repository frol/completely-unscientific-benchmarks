# Nim

Author: Vlad Frolov (@frol)

## Compile

```
nim compile -d:release --passC:-flto --passL:-s --out:main-nim main.nim
```

For maximum performance ([memory is the trade-off](https://github.com/frol/completely-unscientific-benchmarks/pull/1), currently a bug in Nim 0.18.0, fixed in devel):

```
nim compile -d:release --passC:-flto --passL:-s --gc:markAndSweep --out:main-nim main.nim
```

For a faster version that still uses the GC, but breaks the pattern of returning a compound type (like the C++ raw-pointer version):

```
nim compile -d:release --passC:-flto --passL:-s --gc:markAndSweep --out:main-nim main_fast.nim
```

For a version using manual memory allocation (so much less memory used):

```
nim compile -d:release --passC:-flto --passL:-s --gc:none --out:main-nim main_manual.nim
```

## Execute

```
./main-nim
```
