# Python

Author: Vlad Frolov (@frol)

## CPython

```
python main.py
```

## PyPy

```
pypy main.py
```

## Cython

Compile:

```
cython --embed main.py
gcc -O3 -o main main.c $(pkg-config --cflags --libs python3)
```

Execute:

```
./main
```
