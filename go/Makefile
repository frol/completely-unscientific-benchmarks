SRC_FILES = $(wildcard *.go)
TARGETS = $(SRC_FILES:main-%.go=%)

ALL_BINARIES = $(TARGETS:%=main-%)

.PHONY: all
all: $(ALL_BINARIES)

%: %.go
	go build -o $@ $<
	strip -s $@

RUN_ALL_BINARIES = $(TARGETS:%=run-%)

.PHONY: $(RUN_ALL_BINARIES)
$(RUN_ALL_BINARIES): run-%: main-%
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)

.PHONY: clean
clean:
	rm $(ALL_BINARIES)
