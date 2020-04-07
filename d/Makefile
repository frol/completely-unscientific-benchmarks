SRC_FILES = $(wildcard *.d)
TARGETS = $(SRC_FILES:main_%.d=%)

ALL_BINARIES = $(TARGETS:%=main_%-ldc) $(TARGETS:%=main_%-gdc) $(TARGETS:%=main_%-dmd) main_tuned_no_rt-static-ldc

.PHONY: all
all: $(ALL_BINARIES)

%_no_rt-static-ldc: %_no_rt.d
	ldc2 -betterC $< -O3 -release -flto=full -L=-s -defaultlib= -static -of=$@

%_no_rt-ldc: %_no_rt.d
	ldc2 -betterC $< -O3 -release -flto=full -L=-s -defaultlib= -of=$@

%-ldc: %.d
	ldc2 $< -O3 -release -flto=full -L=-s -of=$@

%-gdc: %.d
	gdc $< -O3 -frelease -flto -Xlinker -s -o $@

%-dmd: %.d
	dmd $< -O -release -L=-s -of=$@

RUN_ALL_BINARIES = $(ALL_BINARIES:main_%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main_%
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
