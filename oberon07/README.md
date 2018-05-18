# Oberon-07

Author: John Perry

This has been written for the oberonc compiler for the Java Virtual Machine.
For details on using that compiler, see

    https://github.com/lboasso/oberonc

This has been tested to compile and run on a MacBook Pro running Java 1.8.

## Compile

```
mkdir build
javac -d build RandomInt.java
java -cp $OBERON_BIN oberonc build RandomInt.mod CompleteUnscientificBenchmark.mod
```

The $OBERON_BIN variable should be defined according to the compiler's directions.

## Execute

```
java -cp $OBERON_BIN:build CompleteUnscientificBenchmark
```
