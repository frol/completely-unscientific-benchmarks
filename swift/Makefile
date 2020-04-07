SRC_FILES = $(wildcard Sources/*)
TARGETS = $(SRC_FILES:Sources/%=%)

ALL_BINARIES = $(TARGETS:%=main-%)

.PHONY: all
all: $(ALL_BINARIES)

main-%: Sources/%
	swift build -c release -Xswiftc -O -Xcc -flto -Xswiftc -whole-module-optimization
	mv ./.build/*/release/$@ $@
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
