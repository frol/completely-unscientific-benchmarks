# Nim

Author: Vlad Frolov (@frol)

## Compile

```
nim compile -d:release --passC:-flto --passL:-s --out:main-nim main.nim
```

For a faster version without runtime safety checks that still uses the GC and returns a compound type:

```
nim compile -d:danger --passC:-flto --passL:-s --gc:arc --out:main-nim main.nim
```

For an even faster version without runtime safety checks that still uses the GC, but breaks the pattern of returning a compound type (like the C++ raw-pointer version):

```
nim compile -d:danger --passC:-flto --passL:-s --gc:arc --out:main-nim main_fast.nim
```

For a version without runtime safety checks and using manual memory allocation (so much less memory used):

```
nim compile -d:danger --passC:-flto --passL:-s --gc:none --out:main-nim main_manual.nim
```

NOTE: To compile statically, add `--passL:-static` flag.

## Execute

```
./main-nim
```
