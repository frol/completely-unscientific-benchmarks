SRC_FILES = $(wildcard *.cpp)
TARGETS = $(SRC_FILES:main-%.cpp=%)

ALL_BINARIES = $(TARGETS:%=main-%-clang) $(TARGETS:%=main-%-clang-static) $(TARGETS:%=main-%-gcc) $(TARGETS:%=main-%-gcc-static)

.PHONY: all
all: $(ALL_BINARIES)

%-clang: %.cpp
	clang++ -O3 --std=c++17 -flto -s -o $@ $<

%-clang-static : %.cpp
	/usr/bin/clang++ -O3 --std=c++17 -flto -s -static -o $@ $<

%-gcc : %.cpp
	g++ -O3 --std=c++17 -flto -s -o $@ $<

%-gcc-static : %.cpp
	g++ -O3 --std=c++17 -flto -s -static -o $@ $<

.PHONY: clean
clean:
	rm $(ALL_BINARIES)

RUN_ALL_BINARIES = $(ALL_BINARIES:%=run-%)
$(RUN_ALL_BINARIES): run-% : %
	./$<

.PHONY: run
run: $(RUN_ALL_BINARIES)
