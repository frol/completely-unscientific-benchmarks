# Swift

Author: Vlad Frolov (@frol)

## Compile

```
swiftc -O -Xcc -flto -whole-module-optimization -o main-swift main.swift
strip -s main-swift
```

## Execute

```
./main-swift
```
