SDK = ${PLAYDATE_SDK_PATH}
ifeq ($(SDK),)
$(error SDK not found, set PLAYDATE_SDK_PATH environment variable)
endif

ifeq ($(shell which pdc),)
$(error pdc binary not found, add $${PLAYDATE_SDK_PATH}/bin to PATH environment variable)
endif

ARTIFACT = run_duck.pdx

default: run

build: $(wildcard source/*)
	mkdir -p build/files
	cp -r source/* build/files
	pdc -s -v -k build/files build/$(ARTIFACT)
	rm -r build/files

run: build
	cd build && PlaydateSimulator $(ARTIFACT)

clean:
	rm -r build

.PHONY: default run clean
