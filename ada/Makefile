main-naive: ./main_naive_pointers.adb
	gnatmake -O2 -gnatp ./main_naive_pointers.adb -o ./main-naive
	strip -s ./main-naive

.PHONY: run-naive
run-naive: main-naive
	./main-naive

.PHONY: run
run: run-naive
