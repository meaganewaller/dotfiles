SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

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

RED     := \033[0;31m
GREEN   := \033[0;32m
YELLOW  := \033[1;33m
BLUE    := \033[0;36m
MAGENTA := \033[0;35m
CYAN    := \033[0;36m
WHITE   := \033[0;37m
END     := \033[0m
INFO := $(BLUE)
WARN := $(YELLOW)
ERROR := $(RED)

MACOS := $(shell uname -s | grep Darwin 2> /dev/null)

log = @echo "$(INFO)$(1)$(END)"
err = @&2 echo "$(ERROR)$(1)$(END)"
done = $(call log,"Done!")
run = @$(1) || (n=$$?; >&2 echo "$(ERROR)Failed!$(END)"; exit $$n)

### ZDOTDIR

define ZDOTDIR
export ZDOTDIR="$$HOME/.config/zsh"
endef

export ZDOTDIR
~/.zshenv:
ifneq ($(ZDOTDIR), "$$HOME/.config/zsh")
	$(call err,"ZDOTDIR misconfigured!")
	$(call log,"Configuring ZDOTDIR...")
	$(call run,echo "$$ZDOTDIR" | tee -a $@ > /dev/null)
	$(call run,echo 'source $$ZDOTDIR/.zshenv' | tee -a $@ > /dev/null)
	$(call done)
endif

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
	@chmod +x $(CUR_DIR)/bin/*
	@sudo ln -sf $(CUR_DIR)/bin/* /usr/local/bin/

.PHONY: symlinks
symlinks:
	$(shell meta/symlinks)

.PHONY: os
os:
	@$(call section,"Setting up for your operating system")
	@read -p "Choose an option (work/private): " OPTION; \
	DEVICE=$$OPTION; \
	export DEVICE;
	if [ "$(OS)" = "macos" ]; then \
		@$(call section,"$(OS) detected"); \
		$(call subsection,"run defaults.sh - defaults-chome.sh - dock.sh"); \
		sudo -v; \
		while true; do sudo -n true; sleep 60; kill -0 $$ || exit; done 2>/dev/null & \
		bash -c "source $(CUR_DIR)/os/macos/defaults.sh"; \
		$(call result,"set up macos defaults!"); \
		bash -c "source $(CUR_DIR)/os/macos/defaults-chrome.sh"; \
		$(call result,"set up macos chrome defaulst!"); \
		bash -c "source $(CUR_DIR)/os/macos/dock.sh"; \
		$(call result,"set up macos dock defaulst!"); \
		# $(MAKE) install_brew; \
		# $(MAKE) install_brew_taps; \
		# $(MAKE) install_brew_packages; \
		# $(MAKE) install_brew_cask_packages; \
		# $(MAKE) brew_clean_up; \
		$(call subsection,"Sourcing duti-file"); \
		bash -c "source $(CUR_DIR)/os/macos/duti.sh"; \
		elif [ "$(OS)" = "linux" ]; then \
		$(call section,"$(OS) detected"); \
	fi
	@if [ -z "`${SHELL} -c 'echo ${ZSH_VERSION}'`" ]; then \
		sudo sh -c "echo $(which zsh) >> /etc/shells" \
		chsh -s "$(which zsh)"; \
	fi


.PHONY: mise
mise:
	brew install mise

install_brew:
	@$(call subsection,"Installing homebrew")
	@if ! command -v brew >/dev/null 2>&1; then \
		printf "\n\n${RED}~> Homebrew is not installed. Installing now${NC}\n\n"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		printf "\n\n${GREEN}~> Homebrew installation completed successfully."; \
	else  \
		printf "\n\n${BLUE}~> Homebrew is already installed. Skipping installation${NC}\n\n"; \
	fi
	@$(call subsection,"Updating homebrew directory permissions.")
	sudo chown -R $(shell whoami) $(shell brew --prefix)
	@$(call result,"Homebrew permissions updated")

install_brew_packages:
	@$(call subsection,"Installing homebrew packages")
	@if [ -f $(BREW_PACKAGES_FILE) ]; then \
		while read -r package; do \
			if ! brew leaves | grep -q "^$$package$$"; then \
				echo "Installing $$package..."; \
				brew install $$package; \
			else \
				echo "$$package is already installed. Skipping..."; \
			fi; \
		done < $(BREW_PACKAGES_FILE); \
	else \
		echo "Tap file $(BREW_PACKAGES_FILE) not found."; \
		exit 1; \
	fi

install_brew_cask_packages:
	@$(call subsection,"Installing homebrew cask packages")
	@if  [ -f $(BREW_CASK_PACKAGES_FILE) ]; then \
		while read -r cask_package; do \
			if ! brew list --cask | grep -q "^$$cask_package$$"; then \
				echo "Installing cask: $$cask_package..."; \
				brew install --force --appdir="/Applications" --fontdir="/Library/Fonts" $$cask_package; \
			else \
				echo "$$cask_package is already installed. Skipping..."; \
			fi; \
		done < $(BREW_CASK_PACKAGES_FILE); \
	else \
		echo "Tap file $(BREW_CASK_PACKAGES_FILE) not found."; \
		exit 1; \
	fi


install_brew_taps:
	@$(call subsection,"Installing homebrew taps")
	@if  [ -f $(BREW_TAPS_FILE) ]; then \
		while read -r tap; do \
			if ! brew tap | grep -q "^$$tap$$"; then \
				echo "Tapping $$tap..."; \
				brew tap $$tap; \
			else \
				echo "$$tap is already tapped. Skipping..."; \
			fi; \
		done < $(BREW_TAPS_FILE); \
	else \
		echo "Tap file $(BREW_TAPS_FILE) not found."; \
		exit 1; \
	fi

brew_clean_up:
	@$(call subsection,"Cleaning up homebrew")
	$(shell brew cleanup)

