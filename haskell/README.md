# Haskell

Author: Franklin Chen (@FranklinChen)

## Compile

```
stack build
```

## Execute

The path to the compiled binary depends on your OS and compiler version, e.g.

Linux:

```
.stack-work/install/x86_64-linux-nopie/lts-11.9/8.2.2/bin/unscientific
```

macOS:

```
.stack-work/install/x86_64-osx/lts-11.9/8.2.2/bin/unscientific
```

## Notes

The implementation here is purely functional and returns new trees
rather than mutating trees in place.
