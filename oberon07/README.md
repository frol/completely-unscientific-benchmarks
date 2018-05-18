# Oberon-07

Author: John Perry

This code works with two different compilers for the Oberon-07 language.
I originally wrote it for the [oberonc](https://github.com/lboasso/oberonc)
compiler for the Java Virtual Machine.

A second version works on the [obnc](http://miasap.se/obnc/) compiler,
which translates Oberon-07 to C, then compiles the C code to native code.

See the links for details on obtaining, installing, and using those compilers.
`obnc` will require installaiton of the [Boehm garbage collector](http://www.hboehm.info/gc/),
whereas `oberonc` relies simply on Java.

Both versions compiled and ran successfully on a MacBook Pro running Java 1.8.

## Compile with oberonc

```
mkdir build
javac -d build RandomInt.java
java -cp $OBERON_BIN oberonc build RandomInt.mod CompleteUnscientificBenchmark.mod
```

The `$OBERON_BIN` variable should be defined according to the compiler's
directions and your particular installation.

## Execute oberonc

```
java -cp $OBERON_BIN:build CompleteUnscientificBenchmark
```

## Compile with obnc

For best performance, set `CFLAGS` appropriately for the C compiler to optimize.
On a Unix-based system, for instance:

```
export CFLAGS=-Ofast
```

Then compile:

```
obnc CompleteUnscientificBenchmark.obn
```

**Do not** delete `Time.c`. This is necessary to interface to the C
standard library to obtain the time, which we use to see the
random number generator.

## Execute obnc

```
./CompleteUnscientificBenchmark
```

# Acknowledgments

Special thanks to Luca Boasso, author of the oberonc compiler,
for figuring out why my initial implementation was so much
slower on the Java Virtual Machine.
