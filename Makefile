DOTFILES_SOURCES := $(shell find home -type f)
DOTFILES_TARGETS := $(patsubst home/%, $(HOME)/%, $(DOTFILES_SOURCES))
DOTFILES_DIR     := $(shell pwd)

.PHONY: all
all: install

.PHONY: install
install: configs

.PHONY: update
update: git_update configs

configs: $(DOTFILES_TARGETS)

.PHONY: $(DOTFILES_SOURCES)
$(HOME)/%: home/%
	@mkdir -p "$(@D)"
	@test -e "$@" || ln -s "$(DOTFILES_DIR)/$^" "$@"

.PHONY: git_update
git_update:
	@git pull --rebase
# LINK                    := ln -sfn
# CLONE                   := git clone
# FONT_PATH               := $(DOTS_FOLDER)/fonts
# BREW_TAPS_FILE          := $(DOTS_FOLDER)/os/macos/Brewfile.taps
# BREW_PACKAGES_FILE      := $(DOTS_FOLDER)/os/macos/Brewfile
# BREW_CASK_PACKAGES_FILE := $(DOTS_FOLDER)/os/macos/Brewfile.cask
# PIP_FILE                := $(DOTS_FOLDER)/config/mise/default-python-packages
# NPM_FILE                := $(DOTS_FOLDER)/config/mise/default-npm-packages
# GEMS_FILE               := $(DOTS_FOLDER)/config/mise/default-ruby-gems
#
# RED    := \033[0;31m
# NC     := \033[0m # No Color
# GREEN  := \033[0;32m
# YELLOW := \033[1;33m
# BLUE   := \033[0;36m
#
# # Helper functions for pretty printing
# define divider
# 	@printf "${YELLOW}✦•〰〰〰〰〰〰•★•〰〰〰〰〰〰•✦${NC}"
# endef
#
# define section
# 	@echo
# 	@$(call divider)
# 	@printf "\n\n%1s${GREEN}✧˖° "$(1)" °˖✧${NC}\n"
# endef
#
# define subsection
# 	@printf "\n\n ${YELLOW}₊⊹⁀➴ "$(1)"${NC}\n\n"
# endef
#
# define result
# 	@printf "\n\n${BLUE}₍ᐢ.  ̫.ᐢ₎${GREEN} "$(1)"${NC}\n\n"
# endef
#
# define endsection
# 	@echo
# 	@$(call divider)
# 	@echo
# endef
#
# define log_error
# 	@printf \n[${RED}]: "$(1)"${NC}\n\n"
# endef
#
# .DEFAULT_GOAL := help
#
# # Defining Main Tasks
# .PHONY: help
# help:
# 	@$(call section,"Get help")
# 	@echo
# 	@printf "USAGE: ${GREEN}make [TASK]${NC}"
# 	@echo
# 	@echo
# 	@printf "DESCRIPTION: This Makefile provides tasks for ${GREEN}automating the installation and configuration of dotfiles for MacOS systems.${NC}\n"
# 	@printf "             It ${GREEN}backs up${NC}existing configs, ${GREEN}updates${NC}the system, ${GREEN}installs${NC}essential packages, and ${GREEN}configures${NC}my most used applications.\n\n"
# 	@printf "${BLUE}%s${NC}\n" "Available Targets:"
# 	@echo
# 	@printf "  ${GREEN}help${NC}        - Display this help message.\n"
# 	@printf "  ${GREEN}test${NC}        - Display detected OS, current directory, and username.\n"
# 	@printf "  ${GREEN}setup${NC}       - Run the setup process which includes test, scripts, symlinks, and os.\n"
# 	@printf "  ${GREEN}os${NC}          - Perform OS-specific setup tasks (macOS, Linux, or WSL).\n"
# 	@printf "  ${GREEN}scripts${NC}     - Make all scripts in the 'scripts' directory executable and symlink them to '/usr/local/bin/'.\n"
# 	@printf "  ${GREEN}symlinks${NC}    - Create necessary symlinks by running the 'src/symlinks' script.\n"
# 	@printf "  ${GREEN}mise${NC}        - Clone the mise version manager repository.\n"
# 	@$(call endsection)
#
# # Detect the operating system
# ifeq ($(OS),Windows_NT)
#     OS := windows
# else
#     OS := $(shell meta/detect_os)
# endif
#
# CUR_DIR := $(shell pwd)
# USERNAME := $(shell whoami)
#
# .PHONY: test
# test:
# 	@$(call section,"System Information:")
# 	@echo
# 	@echo 'OS = $(OS)'
# 	@echo 'CUR_DIR = $(CUR_DIR)'
# 	@echo 'USERNAME = $(USERNAME)'
# 	@$(endsection)
#
# .PHONY: setup
# setup: test scripts symlinks os
# 	@$(call endsection)
#
# .PHONY: scripts
# scripts:
# 	chmod +x $(CUR_DIR)/local/bin/*; \
# 	sudo ln -sf $(CUR_DIR)/local/bin/* /usr/local/bin/;
#
# .PHONY: symlinks
# symlinks:
# 	$(shell meta/symlinks)
#
# .PHONY: os
# os:
# 	@read -p "Choose an option (work/private): " OPTION; \
# 	DEVICE=$$OPTION; \
# 	export DEVICE; \
# 	if [ "$(OS)" = "macos" ]; then \
# 		echo "$(OS) detected"; \
# 		echo "set up macos defaults..."; \
# 		sudo -v; \
# 		while true; do sudo -n true; sleep 60; kill -0 $$ || exit; done 2>/dev/null & \
# 		bash -c "source $(DOTS_FOLDER)/os/macos/defaults.sh"; \
# 		bash -c "source $(DOTS_FOLDER)/os/macos/chrome-defaults.sh"; \
# 		bash -c "source $(DOTS_FOLDER)/os/macos/dock.sh"; \
# 		$(MAKE) _install_brew; \
# 		$(MAKE) _install_brew_taps; \
# 		$(MAKE) _install_brew_packages; \
# 		$(MAKE) _install_brew_cask_packages; \
# 		$(MAKE) _brew_clean_up; \
# 		echo "source duti-file"; \
# 		bash -c "source $(DOTS_FOLDER)/os/macos/duti.sh"; \
# 	elif [ "$(OS)" = "linux" ]; then \
# 		echo "$(OS) detected"; \
# 	fi
# 	@if [ -z "`${SHELL} -c 'echo ${ZSH_VERSION}'`" ]; then \
# 	  sudo sh -c "echo $(which zsh) >> /etc/shells" \
# 	  chsh -s "$(which zsh)"; \
# 	fi
#
# .PHONY: mise
# mise:
# 	@$(call section,"Setting up mise")
# 	@if [ "$(OS)" = "macos" ]; then \
# 		brew install mise; \
# 		echo 'eval "$(mise activate zsh)"' >> ~/.zshrc; \
# 		$(LINK) $(DOTS_FOLDER)/config/mise $(HOME)/.config; \
# 		mise install; \
# 	fi
# 	@$(call endsection)
#
# # subtasks
# _install_brew:
# 	@$(call subsection,"Installing homebrew")
# 	@if ! command -v brew >/dev/null 2>&1; then \
# 		printf "\n\n${RED}~> Homebrew is not installed. Installing now${NC}\n\n"; \
# 		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
# 		printf "\n\n${GREEN}~> Homebrew installation completed successfully."; \
# 	else  \
# 		printf "\n\n${BLUE}~> Homebrew is already installed. Skipping installation${NC}\n\n"; \
# 	fi
# 	@$(call subsection,"Updating homebrew directory permissions.")
# 	sudo chown -R $(shell whoami) $(shell brew --prefix)
# 	@$(call result,"Homebrew permissions updated")
#
# _install_brew_packages:
# 	@$(call subsection,"Installing homebrew packages")
# 	@if [ -f $(BREW_PACKAGES_FILE) ]; then \
# 		while read -r package; do \
# 			if ! brew leaves | grep -q "^$$package$$"; then \
# 				echo "Installing $$package..."; \
# 				brew install $$package; \
# 			else \
# 				echo "$$package is already installed. Skipping..."; \
# 			fi; \
# 		done < $(BREW_PACKAGES_FILE); \
# 	else \
# 		echo "Tap file $(BREW_PACKAGES_FILE) not found."; \
# 		exit 1; \
# 	fi
#
# _install_brew_cask_packages:
# 	@$(call subsection,"Installing homebrew cask packages")
# 	@if  [ -f $(BREW_CASK_PACKAGES_FILE) ]; then \
# 		while read -r cask_package; do \
# 			if ! brew list --cask | grep -q "^$$cask_package$$"; then \
# 				echo "Installing cask: $$cask_package..."; \
# 				brew install --force --appdir="/Applications" --fontdir="/Library/Fonts" $$cask_package; \
# 			else \
# 				echo "$$cask_package is already installed. Skipping..."; \
# 			fi; \
# 		done < $(BREW_CASK_PACKAGES_FILE); \
# 	else \
# 		echo "Tap file $(BREW_CASK_PACKAGES_FILE) not found."; \
# 		exit 1; \
# 	fi
#
#
# _install_brew_taps:
# 	@$(call subsection,"Installing homebrew taps")
# 	@if  [ -f $(BREW_TAPS_FILE) ]; then \
# 		while read -r tap; do \
# 			if ! brew tap | grep -q "^$$tap$$"; then \
# 				echo "Tapping $$tap..."; \
# 				brew tap $$tap; \
# 			else \
# 				echo "$$tap is already tapped. Skipping..."; \
# 			fi; \
# 		done < $(BREW_TAPS_FILE); \
# 	else \
# 		echo "Tap file $(BREW_TAPS_FILE) not found."; \
# 		exit 1; \
# 	fi
#
# _brew_clean_up:
# 	@$(call subsection,"Cleaning up homebrew")
# 	$(shell brew cleanup)

