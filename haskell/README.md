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

Note that you can tweak some GHC runtime parameters at the command line, e.g.
to print out memory usage:

```
unscientific +RTS -sstderr
```

results in

```
   3,539,216,096 bytes allocated in the heap
     390,042,872 bytes copied during GC
         222,560 bytes maximum residency (130 sample(s))
          33,304 bytes maximum slop
               3 MB total memory in use (0 MB lost due to fragmentation)

                                     Tot time (elapsed)  Avg pause  Max pause
  Gen  0      3264 colls,     0 par    0.272s   0.276s     0.0001s    0.0003s
  Gen  1       130 colls,     0 par    0.010s   0.011s     0.0001s    0.0001s

  INIT    time    0.000s  (  0.002s elapsed)
  MUT     time    0.712s  (  0.720s elapsed)
  GC      time    0.282s  (  0.287s elapsed)
  EXIT    time    0.000s  (  0.012s elapsed)
  Total   time    0.994s  (  1.020s elapsed)

  %GC     time      28.4%  (28.1% elapsed)

  Alloc rate    4,969,224,834 bytes per MUT second

  Productivity  71.6% of total user, 71.7% of total elapsed
```

This shows that 28% of the time in this program is spent in the garbage collector.
This can be reduced significantly by changing a GC parameter, e.g:

```
unscientific +RTS -H128m -sstderr
```

gives

```
   3,532,382,648 bytes allocated in the heap
       4,871,376 bytes copied during GC
         222,096 bytes maximum residency (2 sample(s))
          33,304 bytes maximum slop
             131 MB total memory in use (0 MB lost due to fragmentation)

                                     Tot time (elapsed)  Avg pause  Max pause
  Gen  0        26 colls,     0 par    0.006s   0.007s     0.0003s    0.0016s
  Gen  1         2 colls,     0 par    0.000s   0.001s     0.0003s    0.0003s

  INIT    time    0.000s  (  0.002s elapsed)
  MUT     time    0.897s  (  0.937s elapsed)
  GC      time    0.006s  (  0.007s elapsed)
  EXIT    time   -0.000s  (  0.010s elapsed)
  Total   time    0.903s  (  0.956s elapsed)

  %GC     time       0.7%  (0.8% elapsed)

  Alloc rate    3,940,056,337 bytes per MUT second

  Productivity  99.3% of total user, 99.0% of total elapsed
```
## Notes

The implementation here is purely functional and returns new trees
rather than mutating trees in place.
