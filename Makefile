
SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: all build check test clean ci

all: check test

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt | $(OUT_DIR)
	tr '[:lower:]' '[:upper:]' < $< > $@

$(OUT_DIR):
	mkdir -p $@
count: build ## report how many words were built
	@wc -w $(OUTPUTS) | tail -1

check:
	@test -d "$(SRC_DIR)" || { echo "Error: source directory missing"; exit 1; }
	@test -n "$(SOURCES)" || { echo "Error: no .txt files found"; exit 1; }
	@echo "Check passed: $(words $(SOURCES)) source file(s)"

build: $(OUTPUTS)

test: build
	@! grep -Il '^[[:lower:]]' $(OUTPUTS) >/dev/null 2>&1 || { echo "Test failed: lowercase text remains"; exit 1; }
	@echo "Test passed: all outputs are uppercase"

clean:
	rm -rf $(OUT_DIR)

ci: clean check test
count: build ## count the source files
	@ls -1 $(SRC_DIR)/*.txt | wc -l



count: build ## report source files and built words
	@ls -1 $(SRC_DIR)/*.txt | wc -l
	@wc -w $(OUTPUTS) | tail -1
