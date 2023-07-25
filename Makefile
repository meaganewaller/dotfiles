MAKEFLAGS += --no-print-directory
CONFIGS := $(shell ls meta/configs | sed 's/.yaml//')
PROFILES := $(shell ls meta/profiles)

all:
ifeq ($(shell uname), Darwin)
	@make macos
else
	@make linux
endif

mac: macos

submodule:
	@echo "Updating submodules"
	@git submodule update --init --remote

$(CONFIGS): submodule
	@meta/install-config $@

$(PROFILES): submodule
	@meta/install-profile $@
