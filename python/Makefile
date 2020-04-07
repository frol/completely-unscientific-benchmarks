.PHONY: all
all: main-cython

main-cython: main.py
	cython -3 --embed ./main.py
	gcc -O3 -o ./main-cython ./main.c $(shell python3-config --cflags --libs --embed)
	strip -s ./main-cython

.PHONY: run-naive
run-naive: main.py
	python3 ./main.py

.PHONY: run-pypy
run-pypy: main.py
	pypy3 ./main.py

.PHONY: run-cython
run-cython: main-cython
	./main-cython

.PHONY: run
run: run-naive run-pypy run-cython

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
