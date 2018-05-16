# D

Author: Edmund Smith

Translated from C++ version by: Stas Minakov (@supermina999)

## Compile

```
ldc2 main.d -O3 -release -Xcc -flto -of=main-ldc
ldc2 main_nort.d -O3 -release -Xcc -flto -of=main-nort-ldc -defaultlib= 
```

```
gdc main.d -O3 -frelease -flto -o main-gdc
gdc main_nort.d -O3 -frelease -flto -o main-nort-gdc
```

NOTE: To compile statically, add `-static` flag.

## Execute

```
./main-ldc
./main-gdc
./main-nort-ldc
./main-nort-gdc
```
