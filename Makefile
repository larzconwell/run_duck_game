SDK = ${PLAYDATE_SDK_PATH}
ifeq ($(SDK),)
$(error SDK not found, set PLAYDATE_SDK_PATH environment variable)
endif

ARTIFACT = run_duck.pdx

default: run

build: $(wildcard source/*)
	mkdir -p build/files
	cp -r source/* build/files
	$(SDK)/bin/pdc -s -v -k build/files build/$(ARTIFACT)
	rm -r build/files

run: build
	cd build && $(SDK)/bin/PlaydateSimulator $(ARTIFACT)

clean:
	rm -r build

.PHONY: default run clean
