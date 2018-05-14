# Completely Unscientific Benchmarks

For this benchmark we implemented [Treap](https://en.wikipedia.org/wiki/Treap)
in a few classic (C++, Java, Python) and hyped (JavaScript, Kotlin, Swift, Rust)
programming languages and tested their performance on Linux, Mac OS, and
Windows (all of them running on different hardware, so the results should not
be compared between platforms).

First, we tried to play by the rules of the garbage-collected languages, thus
there are "ref-counted" versions of implementations for C++ and Rust, but then
we still wanted to compare the results with idiomatic (a.k.a. common practices)
implementations for C++ ("raw-pointers") and Rust ("idiomatic").

I must say that all the implementations except for C++ were implemented by
mostly adapting the syntax from the very first implementation of the algorithm
in Kotlin. Even Rust, which is considered to have the steepest learning curve
among the tested languages, didn't require any "black magic" (the solution does
not require either unsafe code or lifetime annotations). C++ was implemented
separately, so it has a few shortcuts, so it might be not completely fair to
compare other implementations to it (I will try to implement "fair" C++
solution and also "C++"-like Rust solution to see if the performance can be on
par).

## Results

### Linux (Arch Linux, x64, Intel Core i7-4710HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Memory, MB | Normalized Memory | Binary Size, MB                   | Compiler Version                 |
| --------------------------------  | ------------------ | ------------- | ---------- | ----------------- | --------------------------------- | -------------------------------- |
| C++ "ref-counted" (clang / gcc)   | 0.55               | x2.5          | 0.5        | x1.3              | 0.023 + libstdc++                 | Clang 6.0.0 / GCC 8.1.0          |
| C++ "raw-pointers" (clang / gcc)  | 0.22               | x1            | 0.38       | x1                | 0.011 + libstdc++                 | Clang 6.0.0 / GCC 8.1.0          |
| Rust "ref-counted"                | 0.66               | x3            | 0.5        | x1.3              | 0.479                             | Rustc 1.27 (nightly)             |
| Rust "idiomatic"                  | 0.37               | x1.7          | 0.5        | x1.3              | 0.475                             | Rustc 1.27 (nightly)             |
| JavaScript                        | 1.12               | x5            | 52         | x137              | N/A                               | Node.js 10.1.0                   |
| Java (no-limit / -Xm*50M)         | 0.50 / 0.50        | x2.3          | 142 / 29   | x374 / x76        | N/A                               | OpenJDK 1.8.0                    |
| Kotlin JVM (no-limit / -Xm*50M)   | 0.53 / 0.51        | x2.4          | 144 / 30   | x379 / x79        | N/A                               | Kotlinc 1.2.40 + OpenJDK 1.8.0   |
| Kotlin Native                     | 5.88               | x26.7         | 1.2        | x3.2              | 0.239                             | Kotlinc-native 0.7               |
| Swift                             | 2.04               | x9.3          | 2.5        | x6.6              | 0.020 + Swift shared libraries    | Swift 4.1                        |
| Nim                               | 3.94               | x17.9         | 0.5        | x1.3              | 0.283                             | Nim 0.18                         |
| Python (CPython)                  | 12.25              | x55.7         | 5          | x13               | N/A                               | CPython 3.6                      |
| Python (PyPy)                     | 3.20               | x14.5         | 48.5       | x128              | N/A                               | PyPy 6.0.0                       |

### Mac OS (Mac OS 10.13, Intel Core i7-4770HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ | ------------- | -------------------------------- | --------------------------------------------- |
| C++ "ref-counted" (clang)         | 1.35               | x5.4          | 0.019 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| C++ "raw-pointers" (clang)        | 0.25               | x1            | 0.009 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| Rust "ref-counted"                | 0.7                | x2.8          | 0.415                            | Rustc 1.26.0                                  |
| Rust "idiomatic"                  | 0.4                | x1.6          | 0.415                            | Rustc 1.26.0                                  |
| JavaScript                        | 1.47               | x5.9          | N/A                              | Node.js 6.11.1                                |
| Java (no-limit / -Xm*50M)         | 0.69 / 0.59        | x2.8 / x2.4   | N/A                              | Oracle JDK 1.8.0_131                          |
| Kotlin JVM (no-limit / -Xm*50M)   | 0.69 / 0.62        | x2.8 / x2.5   | N/A                              | Kotlinc 1.2.41 + Oracle JDK 1.8.0_131         |
| Kotlin Native                     | 8.2                | x32.8         | 0.543                            | Kotlinc-native 0.6.2                          |
| Swift                             | 2.2                | x8.8          | 0.019 + Swift shared libraries   | Apple Swift version 4.1                       |
| Nim                               | 4.5                | x18           | 0.293                            | Nim 0.18                                      |
| Python (CPython)                  | 15.9               | x63.6         | N/A                              | CPython 2.7.10                                |
| Python (PyPy)                     | 3.7                | x14.8         | N/A                              | PyPy 6.0.0                                    |
            
            
### Windows (Windows 10, x64, Intel Core i7-6700HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ | ------------- | -------------------------------- | --------------------------------------------- |
| C++ "ref-counted" (msvc 2017)     | 1.7                | x5.7          | 0.021 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ "raw-pointers" (msvc 2017)    | 0.3                | x1            | 0.015 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ "ref-counted" (clang)         | 1.6                | x5.3          | 0.258 + libstdc++                | Clang 6.0.0                                   |
| C++ "raw-pointers" (clang)        | 0.3                | x1            | 0.254 + libstdc++                | Clang 6.0.0                                   |
| C++ "ref-counted" (mingw)         | 5                  | x16.7         | 0.031 + libstdc++                | GCC 6.3.0                                     |
| C++ "raw-pointers" (mingw)        | 1                  | x3.3          | 0.039 + libstdc++                | GCC 6.3.0                                     |
| Rust "ref-counted"                | 0.8                | x2.7          | 0.163                            | Rustc 1.26.0                                  |
| Rust "idiomatic"                  | 0.5                | x1.7          | 0.16                             | Rustc 1.26.0                                  |
| JavaScript                        | 1.25               | x4.2          | N/A                              | Node.js 8.11.1                                |
| Java (no-limit / -Xm*50M)         | 0.8 / 0.75         | x2.7 / x2.5   | N/A                              | Oracle JDK 10.0.1                             |
| Kotlin JVM (no-limit / -Xm*50M)   | 0.8 / 0.8          | x2.7 / x2.7   | N/A                              | Kotlinc 1.2.41 + Oracle JDK 10.0.1            |
| Kotlin Native                     | 7.8                | x26           | 0.46                             | Kotlinc-native 0.7                            |
| Swift (Swift for Windows)         | 2.5                | x8.3          | 0.019 + Swift shared libraries   | Swift 4.0.3 (Swift for Windows 1.9.1)         |
| Nim                               | 4.2                | x14           | 0.413                            | Nim 0.18                                      |
| Python (CPython)                  | 15.4               | x51.3         | N/A                              | CPython 2.7.13                                |
| Python (PyPy)                     | 3.4                | x11.3         | N/A                              | PyPy 6.0.0                                    |
