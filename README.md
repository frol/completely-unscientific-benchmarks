# Completely Unscientific Benchmarks

> [There are three kinds of lies: lies, damned lies, and statistics.](https://en.wikipedia.org/wiki/Lies,_damned_lies,_and_statistics)

For this benchmark we implemented [Treap](https://en.wikipedia.org/wiki/Treap)
in a few classic (C++, Java, Python) and hyped (JavaScript, Kotlin, Swift, Rust)
programming languages and tested their performance on Linux, Mac OS, and
Windows (all of them running on different hardware, so the results should not
be compared between platforms).

This turned out to be a good benchmark of memory-intensive operations, which
should have been pushed memory management implementations to their edge.

First, we tried to play by the rules of the garbage-collected languages, thus
there are "ref-counted" versions of implementations for C++ and Rust, but then
we still wanted to compare the results with idiomatic (a.k.a. common practices)
implementations for C++ ("raw-pointers") and Rust ("idiomatic").

I must say that all the implementations except for C++ were implemented by
mostly adapting the syntax from the very first implementation of the algorithm
in Kotlin. Even Rust, which is considered to have the steepest learning curve
among the tested languages, didn't require any "black magic" (the solution does
not require either unsafe code or lifetime annotations). C++ was implemented
separately, so it has a few shortcuts, and thus it might be not a completely
fair comparison (I will try to implement "fair" C++ solution and also
"C++"-like Rust solution to see if the performance can be on par).

## Measurements

To measure time we used `time` util on Mac OS and Windows (msys2 environment),
and [`cgmemtime`](https://github.com/gsauthof/cgmemtime) on Linux.

Memory measurement was only available on Linux with `cgmemtime` util, which
leverages CGroup capabilities to capture the high-water RSS+CACHE memory usage,
and given the limitations of cgroup subsystem (it counts caches and loaded
shared objects unless they are already cached or loaded by other processes),
we take the lowest memory footprint among all the executions.

## Results

Originally, this benchmark had a goal to implement the same "natural" and
"naive" API in all the languages with exception to C++, which would represent
a "bare metal" performance. Over time, we received optimized solutions in other
languages, but it doesn't seem fair to put them on the same scoreboard. Thus,
even though, all the solutions implement the same algorithm, they were created
with performance in mind and received quite an intensive profiling and tunning,
and that is why they will be presented in a separate scoreboard.

All tables are sorted in an alphabetical order.

### "Naive" Implementations Scoreboard

#### Linux (Arch Linux, x64, Intel Core i7-4710HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Memory, MB | Binary Size, MB                 | Compiler Version                  |
| --------------------------------  | ------------------ | ------------- | ---------- | ------------------------------- | --------------------------------- |
| *Best tunned solution*            | 0.178              | x1            | 0.38       |                                 |                                   |
| **C++ `shared_ptr` ("ref-counted")** | **0.38**        | x2.1          | **0.5**    | 0.015 + libstdc++               | Clang 6.0.0 / GCC 8.1.0           |
| C#                                | 0.70\*             | x3.9          | 11         | N/A                             | .NET Core 2.0                     |
| **Go**                            | **0.38**           | x2.1          | 5.8        | 1.2 (static)                    | Go 1.10.2                         |
| Haskell                           | 0.87               | x4.9          | 3.4        | 3.8                             | GHC 8.2.2                         |
| JavaScript                        | 1.12               | x6.3          | 52         | N/A                             | Node.js 10.1.0                    |
| Java (no-limit / `-Xm*50M`)       | 0.50 / 0.50        | x2.8          | 142 / 29   | N/A                             | OpenJDK 1.8.0                     |
| Kotlin/JVM (no-limit / `-Xm*50M`) | 0.53 / 0.51        | x2.9          | 144 / 30   | N/A                             | Kotlinc 1.2.40 + OpenJDK 1.8.0    |
| Kotlin/Native                     | 5.88               | x33           | 1.2        | 0.239                           | Kotlinc-native 0.7                |
| Nim                               | 1.00               | x5.6          | **0.5**    | 0.051                           | Nim 0.18 / GCC 8.1.0              |
| OCaml                             | 0.69               | x3.9          | 3.8        | N/A                             | OCaml 4.06                        |
| PHP                               | 4.44               | x24.9         | 5.8        | N/A                             | PHP 7.2.5                         |
| Python (CPython)                  | 12.25              | x68.8         | 5          | N/A                             | CPython 3.6                       |
| Python (PyPy)                     | 3.20               | x18           | 48.5       | N/A                             | PyPy 6.0.0                        |
| **Rust "idiomatic"**              | **0.37**           | x2.1          | **0.5**    | 0.427                           | Rustc 1.26                        |
| **Rust "ref-counted"**            | **0.37**           | x2.1          | **0.5**    | 0.431                           | Rustc 1.26                        |
| Swift                             | 1.66               | x9.3          | 2.5        | 0.016 + Swift shared libraries  | Swift 4.1                         |

(*) C# has a noticable VM start time (~0.4 seconds), but we still measure real
execution time of the whole program.

#### Mac OS (Mac OS 10.13, Intel Core i7-4770HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ | ------------- | -------------------------------- | --------------------------------------------- |
| *Best tunned solution*            | 0.25               | x1            |                                  |                                               |
| C++ `shared_ptr` ("ref-counted")  | 0.72               | x2.9          | 0.019 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| C#                                | 0.79\*             | x3.2          | 0.006 + .Net                     | .NET Core 2.1.200                             |
| **Go**                            | **0.39**           | x1.6          | 2.1 (static)                     | Go 1.10.2                                     |
| Haskell                           | 1.15               | x4.6          | 1.3                              | GHC 8.2.2                                     |
| JavaScript                        | 1.47               | x5.9          | N/A                              | Node.js 6.11.1                                |
| Java (no-limit / `-Xm*50M`)       | 0.69 / 0.59        | x2.8 / x2.4   | N/A                              | Oracle JDK 1.8.0                              |
| Kotlin/JVM (no-limit / `-Xm*50M`) | 0.69 / 0.62        | x2.8 / x2.5   | N/A                              | Kotlinc 1.2.41 + Oracle JDK 1.8.0             |
| Kotlin/Native                     | 8.2                | x32.8         | 0.543                            | Kotlinc-native 0.6.2                          |
| Nim                               | 1.0                | x4            | 0.293                            | Nim 0.18                                      |
| Python (CPython)                  | 15.9               | x63.6         | N/A                              | CPython 2.7.10                                |
| Python (PyPy)                     | 3.7                | x14.8         | N/A                              | PyPy 6.0.0                                    |
| **Rust "idiomatic"**              | **0.41**           | x1.6          | 0.415                            | Rustc 1.26.0                                  |
| **Rust "ref-counted"**            | **0.4**            | x1.6          | 0.415                            | Rustc 1.26.0                                  |
| Swift                             | 1.72               | x6.9          | 0.019 + Swift shared libraries   | Apple Swift version 4.1                       |


#### Windows (Windows 10, x64, Intel Core i7-6700HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ | ------------- | -------------------------------- | --------------------------------------------- |
| *Best tunned solution*            | 0.28               | x1            |                                  |                                               |
| C++ `shared_ptr` (msvc 2017)      | 0.92               | x3.3          | 0.021 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ `shared_ptr` (clang)          | 0.84               | x3            | 0.258 + libstdc++                | Clang 6.0.0                                   |
| C++ `shared_ptr` (mingw)          | 0.65               | x2.3          | 0.031 + libstdc++                | GCC 6.3.0                                     |
| C#                                | 0.56\*             | x2            | 0.006 + .Net                     | Visual Studio 2017 (Visual C# Compiler 2.7.0) |
| Go "pointers"                     | 0.43               | x1.5          | 2.0 (static)                     | Go 1.10.2                                     |
| Haskell                           | 1.2                | x4.3          | 4.1                              | GHC 8.2.2                                     |
| JavaScript                        | 1.25               | x4.2          | N/A                              | Node.js 8.11.1                                |
| Java (no-limit / `-Xm*50M`)       | 0.8 / 0.75         | x2.7 / x2.5   | N/A                              | Oracle JDK 10.0.1                             |
| Kotlin/JVM (no-limit / `-Xm*50M`) | 0.8 / 0.8          | x2.7 / x2.7   | N/A                              | Kotlinc 1.2.41 + Oracle JDK 10.0.1            |
| Kotlin/Native                     | 7.8                | x26           | 0.46                             | Kotlinc-native 0.7                            |
| Nim                               | 1.1                | x3.9          | 0.134                            | Nim 0.18                                      |
| Python (CPython)                  | 15.4               | x51.3         | N/A                              | CPython 2.7.13                                |
| Python (PyPy)                     | 3.4                | x11.3         | N/A                              | PyPy 6.0.0                                    |
| **Rust "idiomatic"**              | **0.42**           | x1.5          | 0.16                             | Rustc 1.26.0                                  |
| Rust "ref-counted"                | 0.46               | x1.6          | 0.16                             | Rustc 1.26.0                                  |
| Swift (Swift for Windows)         | 2.1                | x7.5          | 0.019 + Swift shared libraries   | Swift 4.0.3 (Swift for Windows 1.9.1)         |

### Tunned Implementations Scoreboard

#### Linux (Arch Linux, x64, Intel Core i7-4710HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Memory, MB | Binary Size, MB                 | Compiler Version                  |
| --------------------------------- | ------------------ | ------------- | ---------- | ------------------------------- | -------------------------------   |
| Ada                               | 0.241              | x1.35         | 0.38       | 0.278                           | GCC Ada 8.1.0                     |
| C++ "raw pointers" (clang / gcc)  | 0.212              | x1.19         | 0.38       | 0.011 + libstdc++               | Clang 6.0.0 / GCC 8.1.0           |
| C++ "raw pointers" (static)       | 0.208              | x1.16         | **0.25**   | 1.7 (static)                    | Clang 6.0.0 / GCC 8.1.0           |
| C++ `unique_ptr` (clang / gcc)    | 0.258              | x1.45         | 0.38       | 0.011 + libstdc++               | Clang 6.0.0 / GCC 8.1.0           |
| D                                 | 0.242              | x1.36         | 1.6        | 0.019 + D runtime               | LDC 1.9.0                         |
| D "no D runtime"                  | 0.193              | x1.08         | 0.38       | 0.011                           | LDC 1.9.0                         |
| D "no D runtime" `-static`        | 0.193              | x1.08         | **0.25**   | 0.643 (static)                  | LDC 1.9.0                         |
| Go "with-sync-pool"               | 0.368              | x2.1          | 1.0        | 1.2 (static)                    | Go 1.10.2                         |
| Haskell `+RTS -H128m`             | 0.835              | x4.7          | 134        | 3.8                             | GHC 8.2.2                         |
| Nim `--gc:markAndSweep`           | 0.655              | x3.7          | 5          | 0.055                           | Nim 0.18 / GCC 8.1.0              |
| Nim "fast"                        | 0.359              | x2            | 0.5        | 0.047                           | Nim 0.18 / GCC 8.1.0              |
| Nim "fast" `--gc:markAndSweep`    | 0.186              | x1.04         | 5.1        | 0.043                           | Nim 0.18 / GCC 8.1.0              |
| Nim "manual memory management"    | 0.179              | x1            | 0.38       | 0.039                           | Nim 0.18 / GCC 8.1.0              |
| **Nim "manual" (static)**         | **0.178**          | **x1**        | 0.38       | 0.8 (static)                    | Nim 0.18 / GCC 8.1.0              |
| Object Pascal "raw pointers"      | 0.369              | x2.1          | 0.38       | **0.028 (static)**              | FPC 3.0.4                         |
| Object Pascal "no-heap-cheating"  | 0.327              | x1.8          | 8          | 0.027 (static)                  | FPC 3.0.4                         |
| Rust "unsafe pointers"            | 0.217              | x1.22         | 0.5        | 0.427                           | Rustc 1.26.0                      |
| Rust "safe mem::forget"           | 0.239              | x1.34         | 0.5        | 0.427                           | Rustc 1.26.0                      |


#### Mac OS (Mac OS 10.13, Intel Core i7-4770HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ | ------------- | -------------------------------- | --------------------------------------------- |
| **C++ "raw pointers" (clang)**    | **0.25**           | x1            | 0.009 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| C++ `unique_ptr` (clang)          | 0.3                | x1.2          | 0.009 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| D                                 | 0.26               | x1.04         | 0.019 + D runtime                | LDC 1.9.0                                     |
| Nim `--gc:markAndSweep`           | 0.7                | x2.8          | 0.293                            | Nim 0.18                                      |
| Object Pascal                     | 0.36               | x1.4          | 0.272                            | FPC 3.0.4                                     |


#### Windows (Windows 10, x64, Intel Core i7-6700HQ CPU)

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ | ------------- | -------------------------------- | --------------------------------------------- |
| C++ "raw pointers" (msvc 2017)    | 0.29               | x1.04         | 0.015 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ `unique_ptr` (msvc 2017)      | 0.4                | x1.4          | 0.015 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ "raw pointers" (clang)        | 0.29               | x1.04         | 0.254 + libstdc++                | Clang 6.0.0                                   |
| C++ `unique_ptr` (clang)          | 0.36               | x1.3          | 0.254 + libstdc++                | Clang 6.0.0                                   |
| **C++ "raw pointers" (mingw)**    | **0.28**           | x1            | 0.039 + libstdc++                | GCC 6.3.0                                     |
| C++ `unique_ptr` (mingw)          | 0.34               | x1.2          | 0.039 + libstdc++                | GCC 6.3.0                                     |
| D                                 | 0.31               | x1.1          | 0.681 + D runtime                | LDC 1.9.0                                     |
| Nim `--gc:markAndSweep`           | 0.83               | x3            | 0.143                            | Nim 0.18                                      |
| Object Pascal                     | 0.44               | x1.6          | 0.045                            | FPC 3.0.4                                     |


## Observations

C++ "ref-counted" (`shared ptr`) has significant performance hit on non-Linux
platforms.

JVM speeds up if you limit its memory.

JVM uses some tricks (JIT) which helps it to cut down some reference counting
overheads and it manages to go faster than C++ and Rust "ref-counted"
solutions.

Kotlin Native is still much slower than the Kotlin running in JVM.

Kotlin JS produces JS code which is ~25% slower than the manual Kotlin to JS
translation.

With CPython vs PyPy you trade speed for memory.


## License

Completely Unscientific Benchmarks project is licensed under either of

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
   http://www.apache.org/licenses/LICENSE-2.0)
 * MIT license ([LICENSE-MIT](LICENSE-MIT) or
   http://opensource.org/licenses/MIT)

at your option.
