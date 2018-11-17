# Modula-3

Author: John Perry (john.perry@usm.edu)

## Versions

There are three implementations of the code here.
  * The standard version (in the `src` directory) is a naive implementation.
    It uses Modula-3's garbage collection facilities.
  * The first tuned version (in the `src_unsafe` directory) uses untraced references.
    As such, it has to `DISPOSE()` of them itself, and this makes the thing unsafe.
  * The second tuned version (in the `src_pooled` directory) uses a generic memory pool.
    This requires the construction of an intermediate generic interface and module,
    which is a little cumbersome, but that's what seemingly pointless `NodeMemoryPool` files are about.
    Instead of relying on Modula-3's `NEW()` and `DISPOSE()` commands,
    the implementation instead invokes the pool's `Create()` and `Dispose()` commands.

## Compile

To compile with the [Critical Mass Modula-3 compiler](https://github.com/modula3/cm3/releases),
first change to the version you wish to compile.
Once you're in that directory, type

```
cm3 -O3
```

## Execute

Typically the compiler (I used Critical Mass from Github)
will place the executable in a folder named `AMD64_DARWIN`.
For the naive `src` implementation, that will appear in the parent directory.
For the other two implementations, that will appear in the same directory.
The generated executables' names are `Main` (naive), `Untraced`, and `Pooled`. 