.PHONY: all
all: Main.class;

%.class: %.scala
	scalac -g:none $<

.PHONY: run-naive
run-naive:
	scala -classpath . Main

run-tuned:
	scala -J-Xms50M -J-Xmx50M -classpath . Main

.PHONY: run
run: run-naive run-tuned

.PHONY: clean
clean:
	rm *.class
