SRC_FILES = $(wildcard *.pas)
TARGETS = $(SRC_FILES:main_%.pas=%)

ALL_BINARIES = $(TARGETS:%=main_%)

.PHONY: all
all: $(ALL_BINARIES)

%: %.pas
	fpc -O3 -o$@ $<
	strip -s $@

RUN_ALL_BINARIES = $(TARGETS:%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main_%
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
