TARGETS = naive

ALL_BINARIES = $(TARGETS:%=main-%)

.PHONY: all
all: $(ALL_BINARIES)

main-naive: src/Main.hs
	stack build
	mv .stack-work/install/*/*/*/bin/unscientific ./main-naive

RUN_ALL_BINARIES = $(TARGETS:%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main-%
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
