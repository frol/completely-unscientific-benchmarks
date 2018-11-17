# D - Manual Memory Management

Author: Edmund Smith

Translated from C++ version by: Stas Minakov (@supermina999)

## Compile

```
ldc2 main_naive_pointers.d -O3 -release -flto=full -of=main_naive_pointers-ldc
ldc2 -betterC main_tuned_no_rt.d -O3 -release -flto=full -of=main_tuned_no_rt-ldc -defaultlib=
```

```
gdc main_naive_pointers.d -O3 -frelease -flto -o main_naive_pointers-gdc
gdc -betterC main_tuned_no_rt.d -O3 -frelease -flto -o main_tuned_no_rt-gdc
```

NOTE: To compile statically, add `-static` flag.

## Execute

```
./main_naive_pointers-ldc
./main_naive_pointers-gdc
./main_tuned_no_rt-ldc
./main_tuned_no_rt-gdc
```

# D - Full GC and Runtime

Translated from Java version by: Chris Collazo (@nervecenter)

## Compile

```
dmd main_full_gc.d -O -release -of=main_full_gc-dmd
ldc2 main_full_gc.d -O3 -release -flto=full -of=main_full_gc-ldc
```

NOTE: To compile statically in LDC, add `-static` flag. DMD statically links by default.

## Execute

```
./main_full_gc-dmd
./main_full_gc-ldc