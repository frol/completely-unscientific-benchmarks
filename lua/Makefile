.PHONY: all
all:

.PHONY: run-naive
run-naive: ./main.lua
	lua ./main.lua

.PHONY: run-luajit
run-luajit: ./main.lua
	luajit ./main.lua

.PHONY: run
run: run-naive run-luajit
