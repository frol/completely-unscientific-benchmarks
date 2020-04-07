main-naive: Benchmark.csproj Program.cs
	dotnet build -c Release -o ./main-naive
	touch main-naive

.PHONY: run-naive
run-naive: main-naive
	./main-naive/Benchmark

.PHONY: run
run: run-naive
