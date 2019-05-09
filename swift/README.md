# Swift

Author: Vlad Frolov (@frol)

## Compile


```
swift build -c release -Xswiftc -O -Xcc -flto -Xswiftc -whole-module-optimization
```

## Execute

```
./.build/x86_64-apple-macosx/release/unmanaged
./.build/x86_64-apple-macosx/release/naive
```
