SRC_FILES = $(wildcard *.ml)
TARGETS = $(SRC_FILES:main_%.ml=%)

ALL_BINARIES = $(TARGETS:%=main_%)

.PHONY: all
all: $(ALL_BINARIES)

%: %.ml
	ocamlopt -o $@ $<

RUN_ALL_BINARIES = $(TARGETS:%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main_%
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
