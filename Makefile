COLOR_GREEN := \033[1;32m
COLOR_WHITE := \033[1;37m
COLOR_NONE := \033[0m

LANGS = \
	ada \
	c\# \
	c++ \
	clojure \
	crystal \
	d \
	fsharp \
	go \
	haskell \
	java \
	javascript \
	kotlin \
	lua \
	nim \
	ocaml \
	pascal \
	php \
	python \
	ruby \
	rust \
	swift \
	#\
	modula2 \
	modula3 \
	oberon07 \

.PHONY: compile run $(LANGS)
compile: $(LANGS)

$(LANGS):
	$(MAKE) --directory ./$@

# This Makefile magic is nicely described here:
# http://stackoverflow.com/a/12110773/1178806
#
RUNS = $(addprefix run-,$(LANGS))
.PHONY: run $(RUNS)
run: $(RUNS)

$(RUNS): run-%: %
	@echo
	@echo -e "$(COLOR_GREEN)Running an implementation in $(COLOR_WHITE)$*$(COLOR_NONE)"
	@echo "===================================="
	sh -ec 'cd "./$*" && RUN_CMDS=$$($(MAKE) --silent --dry-run run) && \
		OLD_IFS="$$IFS" && IFS="'$$'\n''" && for run_cmd in $$RUN_CMDS; do \
			echo -e "Executing $(COLOR_WHITE)$$run_cmd$(COLOR_NONE) 20 times:" && \
			IFS="$$OLD_IFS" && for _ in `seq 20`; do ../cgmemtime -t $$run_cmd 2>&1 | cut -d ";" -f4,5,6 | tr ";" "\t" ; done \
		done'
