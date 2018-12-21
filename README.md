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


## Metrics

We define the "naive" implementations as those which a developer with enough
experience in a given language would implement as a baseline "good enough"
solution where correctness is more important than performance.

However, experienced developers in system programming languages (e.g. C, C++, D)
tend to work comfortably with raw pointers, and that makes the comparison of the
solutions only by speed and memory consumption unfair. High-level abstractions
tend to introduce some performance hit in exchange for safety and
expressiveness. Thus, we added other metrics: "Expressiveness" (1 - pure magic,
10 - easy to get started and express your intent) and "Maintenance Complexity"
(1 - easy to maintain, 5 - ugly yet safe, 6-10 - hard to keep it right, i.e.
risky). The ease of maintenance is estimated for a big project using the given
language and the given approach.

Thus, here are the metrics:

* *Expressiveness (**e12s**)*, scores from 1 to 10 - higher value is better
  (keep in mind that this is a subjective metric based on the author's
  experience!)
* *Maintenance Complexity (**M.C.**)*, scores from 1 to 10 - smaller value is
  better (keep in mind that this is a subjective metric based on the author's
  experience!)
* *Real Time*, seconds - smaller value is better
* *Slowdown Time* (relative speed compared to the best tuned solution) - smaller
  value is better
* *Memory*, megabytes - smaller value is better
* *Binary Size*, megabytes - smaller value is better


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

| Language                                      | e12s            | M.C.           | Real Time, seconds | Slowdown Time | Memory, MB | Binary Size, MB                 | Compiler Version                  |
| --------------------------------------------- |:---------------:|:--------------:| ------------------ |:-------------:| ---------- | ------------------------------- | --------------------------------- |
| *Best tuned solution*                         |                 |                | **0.165**          | x1            | **0.25**   |                                 |                                   |
| Ada "naive unsafe raw pointers"               | 💛<br/>(6)      | 💔<br/>(8)     | 0.24               | x1.45         | **0.4**    | 0.278                           | GCC Ada 8.1.0                     |
| C++ "java-like" (clang)                       | 💙<br/>(7)      | 💙<br/>(5)     | 0.33               | x2            | **0.5**    | 0.015 + libstdc++               | Clang 6.0.0                       |
| C++ "java-like" (gcc)                         | 💙<br/>(7)      | 💙<br/>(5)     | 0.37               | x2.2          | **0.5**    | 0.043 + libstdc++               | GCC 8.1.0                         |
| C++ "naive unsafe raw pointers" (clang)       | 💛<br/>(6)      | 💔<br/>(8)     | 0.20               | x1.21         | **0.4**    | 0.011 + libstdc++               | Clang 6.0.0                       |
| **C++ "naive unsafe raw pointers" (gcc)**     | 💛<br/>(6)      | 💔<br/>(8)     | **0.19**           | x1.15         | **0.4**    | 0.023 + libstdc++               | GCC 8.1.0                         |
| C++ "naive `shared_ptr`" (clang)              | 💛<br/>(6)      | 💛<br/>(6)     | 0.36               | x2.2          | **0.5**    | 0.015 + libstdc++               | Clang 6.0.0                       |
| C++ "naive `shared_ptr`" (gcc)                | 💛<br/>(6)      | 💛<br/>(6)     | 0.35               | x2.1          | **0.5**    | 0.047 + libstdc++               | GCC 8.1.0                         |
| C#                                            | 💚<br/>(9)      | 💚<br/>(1)     | 0.70\*             | x4.2          | 11         | N/A                             | .NET Core 2.0                     |
| Crystal                                       | 💚<br/>(10)     | 💚<br/>(1)     | 0.30               | x1.8          | 1.6        | 0.135                           | Crystal 0.25.1                    |
| D "garbage collected"                         | 💚<br/>(9)      | 💚<br/>(1)     | 0.27               | x1.6          | 1.6        | 0.019 + D runtime               | LDC 1.9.0                         |
| D "naive unsafe raw pointers"                 | 💙<br/>(8)      | 💛<br/>(6)     | 0.24               | x1.45         | 1.6        | 0.019 + D runtime               | LDC 1.9.0                         |
| Go "naive unsafe raw pointers"                | 💚<br/>(9)      | 💛<br/>(6)     | 0.38               | x2.3          | 5.8        | 1.2 (static)                    | Go 1.10.2                         |
| Haskell                                       | ?               | ?              | 0.87               | x5.3          | 3.4        | 3.8                             | GHC 8.2.2                         |
| JavaScript                                    | 💚<br/>(10)\*\* | 💙<br/>(3)\*\* | 1.12               | x6.8          | 52         | N/A                             | Node.js 10.1.0                    |
| Java (no-limit / `-Xm*50M`)                   | 💚<br/>(9)      | 💚<br/>(1)     | 0.50 / 0.50        | x3            | 142 / 29   | N/A                             | OpenJDK 1.8.0                     |
| Kotlin/JVM (no-limit / `-Xm*50M`)             | 💚<br/>(9)      | 💚<br/>(1)     | 0.53 / 0.51        | x3.2          | 144 / 30   | N/A                             | Kotlinc 1.2.40 + OpenJDK 1.8.0    |
| Kotlin/Native                                 | 💚<br/>(9)      | 💚<br/>(1)     | 5.88               | x36           | 1.2        | 0.239                           | Kotlinc-native 0.7                |
| Lua                                           | 💚<br/>(10)\*\* | 💙<br/>(3)\*\* | 3.82               | x23           | 2.8        | N/A                             | Lua 5.3.4                         |
| LuaJIT                                        | 💚<br/>(10)\*\* | 💙<br/>(3)\*\* | 0.96               | x5.9          | 2.0        | N/A                             | LuaJIT 2.0.5                      |
| Modula-2                                      | ?               | ?              | 0.20               | x1.21         | **0.5**    | 0.1 + libstdc++                 | gm2 GCC 8.2.0                     |
| Modula-3                                      | ?               | ?              | 0.47               | x2.8          | 1.8        | 1.0                             | Critical Mass Modula-3 d5.10.0    |
| Nim                                           | 💚<br/>(9)      | 💚<br/>(1)     | 1.00               | x6            | **0.5**    | 0.051                           | Nim 0.18 / GCC 8.1.0              |
| Oberon-07                                     | ?               | ?              | 0.24               | x1.45         | 1.3        | 0.031                           | OBNC 0.14.0                       |
| Object Pascal "naive unsafe raw pointers"     | 💛<br/>(6)      | 💔<br/>(8)     | 0.37               | x2.2          | 0.38       | **0.028 (static)**              | FPC 3.0.4                         |
| OCaml                                         | ?               | ?              | 0.69               | x4.2          | 3.8        | N/A                             | OCaml 4.06                        |
| PHP                                           | 💚<br/>(9)      | 💙<br/>(3)\*\* | 4.44               | x27           | 5.8        | N/A                             | PHP 7.2.5                         |
| Python (CPython)                              | 💚<br/>(10)\*\* | 💙<br/>(3)\*\* | 12.25              | x74           | 5          | N/A                             | CPython 3.6                       |
| Python (PyPy)                                 | 💚<br/>(10)\*\* | 💙<br/>(3)\*\* | 3.20               | x19           | 48.5       | N/A                             | PyPy 6.0.0                        |
| Ruby                                          | 💚<br/>(10)\*\* | 💙<br/>(3)\*\* | 6.65               | x40           | 5          | N/A                             | Ruby 2.5.3                        |
| Rust "idiomatic"                              | 💙<br/>(8)      | 💚<br/>(2)     | 0.37\*\*\*         | x2.2          | **0.5**    | 0.427                           | Rustc 1.26                        |
| Rust "ref-counted"                            | 💛<br/>(6)      | 💙<br/>(5)     | 0.37               | x2.2          | **0.5**    | 0.431                           | Rustc 1.26                        |
| Swift                                         | 💚<br/>(9)      | 💚<br/>(1)     | 1.66               | x10           | 2.5        | 0.016 + Swift shared libraries  | Swift 4.1                         |

(\*) C# has a noticeable VM start time (~0.4 seconds), but we still measure real
execution time of the whole program.

(\*\*) Having no static types leaves the code clean, but makes it less reliable
from the maintenance perspective.

(\*\*\*) With [a minor
update](https://barrielle.cedeela.fr/research_page/dropping-drops.html)
([PR #52](https://github.com/frol/completely-unscientific-benchmarks/pull/52)),
Rust solution gets a significant speedup while still keeping its safety
guarantees (see the result in the "Tuned Implementations Scoreboard" below).

#### Mac OS (Mac OS 10.13, Intel Core i7-4770HQ CPU) (outdated)

<details>
  <summary>The Scoreboard</summary>
  <p>

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ |:-------------:| -------------------------------- | --------------------------------------------- |
| *Best tuned solution*             | **0.25**           | x1            |                                  |                                               |
| **C++ "naive unsafe raw pointers" (clang)** | **0.25** | x1            | 0.009 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| C++ "naive `shared_ptr`"          | 0.72               | x2.9          | 0.019 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| C#                                | 0.79\*             | x3.2          | 0.006 + .Net                     | .NET Core 2.1.200                             |
| D "naive unsafe raw pointers"     | 0.26               | x1.04         | 0.019 + D runtime                | LDC 1.9.0                                     |
| Go "naive unsafe raw pointers"    | 0.39               | x1.6          | 2.1 (static)                     | Go 1.10.2                                     |
| Haskell                           | 1.15               | x4.6          | 1.3                              | GHC 8.2.2                                     |
| JavaScript                        | 1.47               | x5.9          | N/A                              | Node.js 6.11.1                                |
| Java (no-limit / `-Xm*50M`)       | 0.69 / 0.59        | x2.8 / x2.4   | N/A                              | Oracle JDK 1.8.0                              |
| Kotlin/JVM (no-limit / `-Xm*50M`) | 0.69 / 0.62        | x2.8 / x2.5   | N/A                              | Kotlinc 1.2.41 + Oracle JDK 1.8.0             |
| Kotlin/Native                     | 8.2                | x32.8         | 0.543                            | Kotlinc-native 0.6.2                          |
| Nim                               | 1.0                | x4            | 0.293                            | Nim 0.18                                      |
| Object Pascal                     | 0.36               | x1.4          | 0.272                            | FPC 3.0.4                                     |
| Python (CPython)                  | 15.9               | x63.6         | N/A                              | CPython 2.7.10                                |
| Python (PyPy)                     | 3.7                | x14.8         | N/A                              | PyPy 6.0.0                                    |
| Rust "idiomatic"                  | 0.41               | x1.6          | 0.415                            | Rustc 1.26.0                                  |
| Rust "ref-counted"                | 0.40               | x1.6          | 0.415                            | Rustc 1.26.0                                  |
| Swift                             | 1.72               | x6.9          | 0.019 + Swift shared libraries   | Apple Swift version 4.1                       |
</p>
</details>
  
#### Windows (Windows 10, x64, Intel Core i7-6700HQ CPU) (outdated)

<details>
  <summary>The Scoreboard</summary>
  <p>

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ |:-------------:| -------------------------------- | --------------------------------------------- |
| *Best tuned solution*             | **0.28**           | x1            |                                  |                                               |
| C++ "naive unsafe raw pointers" (msvc 2017) | 0.29     | x1.04         | 0.015 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ "naive unsafe raw pointers" (clang)     | 0.29     | x1.04         | 0.254 + libstdc++                | Clang 6.0.0                                   |
| **C++ "naive unsafe raw pointers" (mingw)** | **0.28** | x1            | 0.039 + libstdc++                | GCC 6.3.0                                     |
| C++ "naive `shared_ptr`" (msvc 2017)        | 0.92     | x3.3          | 0.021 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ "naive `shared_ptr`" (clang)            | 0.84     | x3            | 0.258 + libstdc++                | Clang 6.0.0                                   |
| C++ "naive `shared_ptr`" (mingw)            | 0.65     | x2.3          | 0.031 + libstdc++                | GCC 6.3.0                                     |
| C#                                | 0.56\*             | x2            | 0.006 + .Net                     | Visual Studio 2017 (Visual C# Compiler 2.7.0) |
| D "naive unsafe raw pointers"     | 0.31               | x1.1          | 0.681 + D runtime                | LDC 1.9.0                                     |
| Go "naive unsafe raw pointers"    | 0.43               | x1.5          | 2.0 (static)                     | Go 1.10.2                                     |
| Haskell                           | 1.2                | x4.3          | 4.1                              | GHC 8.2.2                                     |
| JavaScript                        | 1.25               | x4.2          | N/A                              | Node.js 8.11.1                                |
| Java (no-limit / `-Xm*50M`)       | 0.8 / 0.75         | x2.7 / x2.5   | N/A                              | Oracle JDK 10.0.1                             |
| Kotlin/JVM (no-limit / `-Xm*50M`) | 0.8 / 0.8          | x2.7 / x2.7   | N/A                              | Kotlinc 1.2.41 + Oracle JDK 10.0.1            |
| Kotlin/Native                     | 7.8                | x26           | 0.46                             | Kotlinc-native 0.7                            |
| Nim                               | 1.1                | x3.9          | 0.134                            | Nim 0.18                                      |
| Object Pascal                     | 0.44               | x1.6          | 0.045                            | FPC 3.0.4                                     |
| Python (CPython)                  | 15.4               | x51.3         | N/A                              | CPython 2.7.13                                |
| Python (PyPy)                     | 3.4                | x11.3         | N/A                              | PyPy 6.0.0                                    |
| Rust "idiomatic"                  | 0.42               | x1.5          | 0.16                             | Rustc 1.26.0                                  |
| Rust "ref-counted"                | 0.46               | x1.6          | 0.16                             | Rustc 1.26.0                                  |
| Swift (Swift for Windows)         | 2.1                | x7.5          | 0.019 + Swift shared libraries   | Swift 4.0.3 (Swift for Windows 1.9.1)         |
</p>
</details>

### Tuned Implementations Scoreboard

#### Linux (Arch Linux, x64, Intel Core i7-4710HQ CPU)

| Language                                          | Real Time, seconds | Slowdown Time | Memory, MB | Binary Size, MB                 | Compiler Version                  |
| ------------------------------------------------- | ------------------ |:-------------:| ---------- | ------------------------------- | -------------------------------   |
| C++ "tuned raw pointers" (clang)                  | 0.182              | x1.10         | 0.5        | 0.011 + libstdc++               | Clang 6.0.0                       |
| C++ "tuned raw pointers" (gcc)                    | 0.175              | x1.06         | 0.38       | 0.019 + libstdc++               | GCC 8.1.0                         |
| C++ "tuned raw pointers" (gcc & static)           | 0.172              | x1.04         | **0.25**   | 1.7 (static)                    | GCC 8.1.0                         |
| C++ "raw pointers with pool" (clang)              | 0.174              | x1.05         | 0.38       | 0.011 + libstdc++               | Clang 6.0.0                       |
| **C++ "raw pointers with pool" (gcc)**            | **0.167**          | x1.01         | 0.38       | 0.015 + libstdc++               | GCC 8.1.0                         |
| **C++ "raw pointers with pool" (gcc & static)**   | **0.165**          | **x1**        | **0.25**   | 1.7 (static)                    | GCC 8.1.0                         |
| C++ `unique_ptr` (clang)                          | 0.248              | x1.5          | 0.38       | 0.011 + libstdc++               | Clang 6.0.0                       |
| C++ `unique_ptr` (gcc)                            | 0.248              | x1.5          | 0.38       | 0.043 + libstdc++               | GCC 8.1.0                         |
| D "no D runtime"                                  | 0.193              | x1.17         | 0.38       | 0.011                           | LDC 1.9.0                         |
| D "no D runtime" `-static`                        | 0.193              | x1.17         | **0.25**   | 0.643 (static)                  | LDC 1.9.0                         |
| Go "with-sync-pool"                               | 0.368              | x2.2          | 1.0        | 1.2 (static)                    | Go 1.10.2                         |
| Haskell `+RTS -H128m`                             | 0.835              | x5.1          | 134        | 3.8                             | GHC 8.2.2                         |
| Modula-3 "untraced references"                    | 0.244              | x1.5          | 0.8        | 1.0                             | Critical Mass Modula-3 d5.10.0    |
| Nim `--gc:markAndSweep`                           | 0.655              | x4            | 5          | 0.055                           | Nim 0.18 / GCC 8.1.0              |
| Nim "fast"                                        | 0.359              | x2.2          | 0.5        | 0.047                           | Nim 0.18 / GCC 8.1.0              |
| Nim "fast" `--gc:markAndSweep`                    | 0.186              | x1.13         | 5.1        | 0.043                           | Nim 0.18 / GCC 8.1.0              |
| Nim "manual memory management"                    | 0.179              | x1.08         | 0.38       | 0.039                           | Nim 0.18 / GCC 8.1.0              |
| Nim "manual" (static)                             | 0.178              | x1.08         | 0.38       | 0.8 (static)                    | Nim 0.18 / GCC 8.1.0              |
| Object Pascal "no-heap cheating"                  | 0.327              | x2            | 8          | 0.027 (static)                  | FPC 3.0.4                         |
| Rust "unsafe pointers"                            | 0.217              | x1.32         | 0.5        | 0.427                           | Rustc 1.26.0                      |
| Rust "safe mem::forget"                           | 0.239              | x1.45         | 0.5        | 0.427                           | Rustc 1.26.0                      |


#### Mac OS (Mac OS 10.13, Intel Core i7-4770HQ CPU) (outdated)

<details>
  <summary>The Scoreboard</summary>
  <p>

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ |:-------------:| -------------------------------- | --------------------------------------------- |
| **C++ "naive unsafe raw pointers" (clang)** | **0.25** | x1            | 0.009 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| C++ `unique_ptr` (clang)          | 0.3                | x1.2          | 0.009 + libstdc++                | Apple LLVM version 9.1.0 (clang-902.0.39.1)   |
| Nim `--gc:markAndSweep`           | 0.7                | x2.8          | 0.293                            | Nim 0.18                                      |
</p>
</details>

#### Windows (Windows 10, x64, Intel Core i7-6700HQ CPU) (outdated)

<details>
  <summary>The Scoreboard</summary>
  <p>

| Language                          | Real Time, seconds | Slowdown Time | Binary Size, MB                  | Compiler version                              |
| --------------------------------- | ------------------ |:-------------:| -------------------------------- | --------------------------------------------- |
| **C++ "naive unsafe raw pointers" (mingw)** | **0.28** | x1            | 0.039 + libstdc++                | GCC 6.3.0                                     |
| C++ `unique_ptr` (msvc 2017)      | 0.4                | x1.4          | 0.015 + libstdc++                | MSVC 2017 (19.13.26129)                       |
| C++ `unique_ptr` (clang)          | 0.36               | x1.3          | 0.254 + libstdc++                | Clang 6.0.0                                   |
| C++ `unique_ptr` (mingw)          | 0.34               | x1.2          | 0.039 + libstdc++                | GCC 6.3.0                                     |
| Nim `--gc:markAndSweep`           | 0.83               | x3            | 0.143                            | Nim 0.18                                      |
</p>
</details>

## Observations

D demonstrated the best performance among garbage-collected solutions. It even
managed to outperform Object Pascal solution which used raw pointers and manual
memory management, as well as naive C++ `shared_ptr`-based implementations and
naive "idiomatic" Rust implementation.

C++ "ref-counted" (`shared_ptr`) has significant performance hit on non-Linux
platforms.

C++ `unique_ptr` has some non-zero runtime overhead over raw pointers.

JVM speeds up if you limit its memory.

Kotlin Native is still much slower than the Kotlin running in JVM.

Kotlin JS produces JS code which is ~25% slower than the manual Kotlin to JS
translation.

Nim, D, and Rust can go as fast as C/C++ can when you switch to "unsafe" manual memory management.

With CPython vs PyPy you trade speed for memory.


## License

Completely Unscientific Benchmarks project is licensed under either of

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or
   http://www.apache.org/licenses/LICENSE-2.0)
 * MIT license ([LICENSE-MIT](LICENSE-MIT) or
   http://opensource.org/licenses/MIT)

at your option.
