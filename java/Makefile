.PHONY: alll
all: Main.class

%.class: %.java
	javac -g:none $<

.PHONY: run-naive
run-naive: Main.class
	java Main

run-tuned: Main.class
	java -Xms50M -Xmx50M Main

.PHONY: run
run: run-naive run-tuned

.PHONY: clean
clean:
	rm Main.class
