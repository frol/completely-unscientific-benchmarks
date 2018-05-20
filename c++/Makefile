TARGETS = \
		main-naive-java-like \
		main-naive-raw \
		main-naive-shared_ptr \
		main-tuned-raw \
		main-tuned-raw-with-pool \
		main-tuned-unique_ptr

.PHONY: all
all: $(TARGETS:%=%-clang) $(TARGETS:%=%-clang-static) $(TARGETS:%=%-gcc) $(TARGETS:%=%-gcc-static)

$(TARGETS:%=%-clang): %-clang : %.cpp
	clang++ -O3 --std=c++17 -flto -s -o $@ $<

$(TARGETS:%=%-clang-static): %-clang-static : %.cpp
	/usr/bin/clang++ -O3 --std=c++17 -flto -s -static -o $@ $<

$(TARGETS:%=%-gcc): %-gcc : %.cpp
	g++ -O3 --std=c++17 -flto -s -o $@ $<

$(TARGETS:%=%-gcc-static): %-gcc-static : %.cpp
	g++ -O3 --std=c++17 -flto -s -static -o $@ $<

.PHONY: clean
clean:
	rm $(TARGETS:%=%-clang) $(TARGETS:%=%-clang-static) $(TARGETS:%=%-gcc) $(TARGETS:%=%-gcc-static)
