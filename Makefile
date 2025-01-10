.PHONY: help
help:
	@echo "Available targets:"
	@echo "  help         - Display this help message."
	@echo "  test         - Display detected OS, current directory, and username."
	@echo "  setup        - Run the setup process which includes test, scripts, symlinks, and os."
	@echo "  os           - Perform OS-specific setup tasks (macOS, Linux, or WSL)."
	@echo "  scripts      - Make all scripts in the 'scripts' directory executable and symlink them to '/usr/local/bin/'."
	@echo "  symlinks     - Create necessary symlinks by running the 'src/symlinks' script."
	@echo "  rust         - Install Rust using rustup."
	@echo "  mise         - Clone the mise version manager repository."
	@echo "  repos        - Clone various Git repositories for data science, cheatsheets, templates, and Pandoc filters."
	@echo "  passwords    - Retrieve and set up credentials using pass."

# Detect the operating system
ifeq ($(OS),Windows_NT)
    OS := windows
else
    OS := $(shell meta/detect_os)
endif

BREW_TAPS_FILE     := os/macos/Brewfile.taps
BREW_PACKAGES_FILE := os/macos/Brewfile
BREW_CASK_PACKAGES_FILE := os/macos/Brewfile.cask

CUR_DIR  := $(shell pwd)
USERNAME := $(shell whoami)

.PHONY: test
test:
	@echo 'OS       = $(OS)'
	@echo 'CUR_DIR  = $(CUR_DIR)'
	@echo 'USERNAME = $(USERNAME)'

.PHONY: setup
setup: test scripts symlinks os
	@echo "finished"

.PHONY: scripts
scripts:
	chmod +x $(CUR_DIR)/bin/*; \
	sudo ln -sf $(CUR_DIR)/bin/* /usr/local/bin/;

.PHONY: symlinks
symlinks:
	$(shell meta/symlinks)

.PHONY: os
os:
	@read -p "Choose an option (work/private): " OPTION; \
	DEVICE=$$OPTION; \
	export DEVICE; \
	if [ "$(OS)" = "macos" ]; then \
		echo "$(OS) detected"; \
		echo "run defaults.sh"; \
		sudo -v; \
		while true; do sudo -n true; sleep 60; kill -0 $$ || exit; done 2>/dev/null & \
		bash -c "source $(CUR_DIR)/os/macos/defaults.sh"; \
		bash -c "source $(CUR_DIR)/os/macos/defaults-chrome.sh"; \
		bash -c "source $(CUR_DIR)/os/macos/dock.sh" ; \
		echo "install Brewfile"; \
	fi
	@if [ -z "`${SHELL} -c 'echo ${ZSH_VERSION}'`" ]; then \
		sudo sh -c "echo $(which zsh) >> /etc/shells" \
		chsh -s "$(which zsh)"; \
	fi


.PHONY: mise
mise:
	brew install mise
