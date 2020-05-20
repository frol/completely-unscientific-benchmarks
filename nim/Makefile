SRC_FILES = $(wildcard *.nim)
TARGETS = $(SRC_FILES:main_%.nim=%)

ALL_BINARIES = $(TARGETS:%=main_%) main_fast-mark_and_sweep main_manual-no_gc

.PHONY: all
all: $(ALL_BINARIES)

# NOTE: To compile statically, add `--passL:-static` flag.

%: %.nim
	nim compile -d:release --passC:-flto --passL:-s --out:$@ $<

%-mark_and_sweep: %.nim
	nim compile -d:danger --passC:-flto --passL:-s --gc:markAndSweep --out:$@ $<

%-no_gc: %.nim
	nim compile -d:danger --passC:-flto --passL:-s --gc:none --out:$@ $<

RUN_ALL_BINARIES = $(ALL_BINARIES:main_%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main_%
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
