SRC_FILES = $(wildcard src/bin/*.rs)
TARGETS = $(SRC_FILES:src/bin/main-%.rs=%)

ALL_BINARIES = $(TARGETS:%=main-%)

.PHONY: all
all: $(ALL_BINARIES)

%: src/bin/%.rs src/*.rs Cargo.toml Cargo.lock
	cargo build --release --bin $@
	mv ./target/release/$@ $@
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
