# D

Author: Edmund Smith

Translated from C++ version by: Stas Minakov (@supermina999)

## Compile

```
ldc2 main_naive_pointers.d -O3 -release -Xcc -flto -of=main_naive_pointers-ldc
ldc2 -betterC main_tuned_no_rt.d -O3 -release -Xcc -flto -of=main_tuned_no_rt-ldc -defaultlib= 
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
