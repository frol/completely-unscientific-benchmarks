SRC_FILES = $(wildcard *.fsx)
TARGETS = $(SRC_FILES:main-%.fsx=%)

ALL_BINARIES = $(TARGETS:%=main-%)

.PHONY: all
all: $(ALL_BINARIES)

%: %.fsx
	fsharpc --out:$@ --optimize+ --target:exe $<

RUN_ALL_BINARIES = $(TARGETS:%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main-%
	mono ./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
