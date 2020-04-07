.PHONY: all
all: main-jvm.jar main-native.kexe

%.jar: %.kt
	kotlinc -include-runtime -d $@ $<

%.kexe: %.kt
	kotlinc-native -opt -linker-options -s -output $@ $<

.PHONY: run-jvm-naive run-jvm-tuned run-native
run-jvm-naive: main-jvm.jar
	java -jar main-jvm.jar

run-jvm-tuned: main-jvm.jar
	java -jar -Xms50M -Xmx50M main-jvm.jar

run-native: main-native.kexe
	./main-native.kexe

.PHONY: run
run: run-jvm-naive run-jvm-tuned run-native

.PHONY: clean
clean:
	rm main-jvm.jar main-native.kexe
