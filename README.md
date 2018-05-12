| Language                         | Real Time, seconds | Slowdown Time | Memory, MB | Normalized Memory | Binary Size, MB                   |
| -------------------------------- | ------------------ | ------------- | ---------- | ----------------- | --------------------------------- |
| C++ "ref-counted" (clang / gcc)  | 0.55               | x2.5          | 0.5        | x1.3              | 0.023 + libstdc++                 |
| C++ "raw-pointers" (clang / gcc) | 0.22               | x1            | 0.38       | x1                | 0.011 + libstdc++                 |
| Rust "ref-counted"               | 0.66               | x3            | 0.5        | x1.3              | 0.479                             |
| Rust "idiomatic"                 | 0.37               | x1.7          | 0.5        | x1.3              | 0.475                             |
| JavaScript                       | 1.12               | x5            | 52         | x137              | N/A                               |
| Java (no-limit / -Xm*50M)        | 0.50 / 0.50        | x2.3          | 142 / 29   | x374 / x76        | N/A                               |
| Kotlin JVM (no-limit / -Xm*50M)  | 0.53 / 0.51        | x2.4          | 144 / 30   | x379 / x79        | N/A                               |
| Kotlin Native                    | 5.88               | x26.7         | 1.2        | x3.2              | 0.239                             |
| Swift                            | 2.04               | x9.3          | 2.5        | x6.6              | 0.020 + Swift shared libraries    |
| Nim                              | 3.94               | x17.9         | 0.5        | x1.3              | 0.283                             |
| Python (CPython 3.6)             | 12.25              | x55.7         | 5          | x13               | N/A                               |
| Python (PyPy 6.0.0)              | 3.20               | x14.5         | 48.5       | x128              | N/A                               |

# Compilation and Run

## C++

```
clang++ -O3 -s -o main-clang main.cpp
```

```
g++ -O3 -s -o main-gcc main.cpp
```

```
./main-clang
```

## Rust

```
rustc +nightly -O -o main-rs main.rs
strip -s main-rs
```

```
./main-rs
```

## JavaScript

```
node main.js
```

## Java

```
javac -g:none Main.java
```

```
java Main
```

```
java -Xms50M -Xmx50M Main
```

## Kotlin JVM

```
kotlinc -include-runtime -d main-kt.jar ./main-jvm.kt
```

```
java -jar main-kt.jar
```

```
java -jar -Xms50M -Xmx50M main-kt.jar
```

## Kotlin Native

```
kotlinc-native -opt -o main-kt main.kt
```

```
./main-kt.kexe
```

## Swift

```
swiftc -O -o main-swift main.swift
strip -s main-swift
```

```
./main-swift
```

## Nim

```
nim compile --opt:speed --out:main-nim main.nim
strip -s main-nim
```

```
./main-nim
```

## Python (CPython)

```
python main.py
```

## Python (PyPy)

```
pypy main.py
```
