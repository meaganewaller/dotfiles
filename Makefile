.PHONY: all backup install_macos install update sync install_brew_taps install_brew_packages install_brew_cask_packages backup_pip backup_node backup_gems install_fonts install_mise install_servers install_neovim install_vim install_pip install_servers install_macos_config

default: backup

DOTS_FOLDER    := $(shell grep dots_folder meta/config.yml | sed 's/.*: \"\(.*\)\"/\1/')
DIRECTORY_NAME := $(shell grep directory_name meta/config.yml | sed 's/.*: \"\(.*\)\"/\1/')
BACKUP_DIRS    := $(shell grep backup_dirs meta/config.yml | sed 's/.*: \(.*\)/\1/' | tr ',' '\n')
BACKUP_BREW_TAPS_FILE := package-managers/homebrew/taps.bak
BACKUP_BREW_PACKAGES_FILE := package-managers/homebrew/packages.bak
BACKUP_BREW_CASK_PACKAGES_FILE := package-managers/homebrew/casks.bak
BREW_TAPS_FILE := package-managers/homebrew/Brewfile.taps
BREW_PACKAGES_FILE := package-managers/homebrew/Brewfile
BREW_CASK_PACKAGES_FILE := package-managers/homebrew/Brewfile.cask
PIP_FILE := .config/mise/default-python-packages
NPM_FILE := .config/mise/default-npm-packages
GEMS_FILE := .config/mise/default-gems
PIP_BACKUP_FILE := .config/mise/default-python-packages.bak
NPM_BACKUP_FILE := .config/mise/default-npm-packages.bak
GEMS_BACKUP_FILE := .config/mise/default-gems.bak
FONT_PATH := fonts

RED = \033[0;31m
NC = \033[0m # No Color
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;36m

define divider
	@printf "${YELLOW}✦•〰〰〰〰〰〰•★•〰〰〰〰〰〰•✦${NC}"
endef

# Helper functions for logging
define section
	@echo
	@$(call divider)
	@printf "\n\n%5s${GREEN}✧˖° "$(1)" °˖✧${NC}\n"
endef

define subsection
	@printf "\n\n ${YELLOW}₊⊹⁀➴ "$(1)"${NC}\n\n"
endef

define result
	@printf "\n\n${BLUE}₍ᐢ.  ̫.ᐢ₎${GREEN} "$(1)"${NC}\n\n"
endef

define endsection
	@echo
	@$(call divider)
	@echo
endef

define log_error
	@printf \n[${RED}]: "$(1)"${NC}\n\n"
endef

# Defining tasks
backup:
	@$(call section,"Backing up")
	@if [ "$(shell uname)" = "Darwin" ]; then \
		$(MAKE) backup_brew; \
	fi
	$(MAKE) backup_pip
	$(MAKE) backup_node
	$(MAKE) backup_gems
	@$(call endsection)

install_macos:
	@$(call section,"Running macos tasks")
	$(MAKE) install_brew
	$(MAKE) install_brew_taps
	$(MAKE) install_brew_packages
	$(MAKE) install_brew_cask_packages
	$(MAKE) brew_clean_up
	$(MAKE) install_fonts
	$(MAKE) install_macos_config
	$(MAKE) install_launchagents
	$(MAKE) install_hammerspoon
	@$(call endsection)

install:
	@$(call section,"Installing")
	$(MAKE) install_dotbot
	$(MAKE) install_mise
	@if [ "$(shell uname)" = "Darwin" ]; then \
		$(MAKE) install_macos; \
	fi
	$(MAKE) install_servers
	$(MAKE) install_neovim
	$(MAKE) install_vim
	$(MAKE) install_pip
	$(MAKE) install_node
	$(MAKE) install_gems
	$(MAKE) install_chmod_dots
	$(MAKE) install_writing
	@$(call endsection)

update:
	@$(call section,"Updating")
	@if [ "$(shell uname)" = "Darwin" ]; then \
		$(MAKE) update_brew; \
	fi
	$(MAKE) update_dotbot
	$(MAKE) update_neovim
	$(MAKE) update_vim_plugins
	$(MAKE) update_pip
	$(MAKE) update_node
	$(MAKE) update_gems
	$(MAKE) update_servers
	$(MAKE) update_writing
	@$(call endsection)

sync:
	@$(call section,"!! SYNCING !!")
	$(MAKE) update
	$(MAKE) backup
	@if [ "$(shell uname)" = "Darwin" ]; then \
		$(MAKE) brew_clean_up; \
	fi
	@$(call endsection)

# sub-tasks
backup_brew:
	@$(call subsection,"Backing up homebrew")
	@brew update
	@brew upgrade
	$(MAKE) backup_brew_taps
	$(MAKE) backup_brew_packages
	$(MAKE) backup_brew_cask_packages

backup_brew_taps:
	@$(call subsection,"Backing up homebrew taps")
	@brew tap > "${BREW_TAPS_FILE}"
	@$(call result,"~> ${BREW_TAPS_FILE}")

backup_brew_packages:
	@$(call subsection,"Backing up homebrew packages")
	@brew leaves > "${BREW_PACKAGES_FILE}"
	@$(call result,"~> Homebrew packages saved to ${BREW_PACKAGES_FILE}")

backup_brew_cask_packages:
	@$(call subsection,"Backing up homebrew cask packages")
	@brew list --cask > "${BREW_CASK_PACKAGES_FILE}"
	@$(call result,"~> Homebrew cask packages saved to ${BREW_CASK_PACKAGES_FILE}")

backup_mas:
	@$(call subsection,"Backing up Mac App Store apps")

backup_pip:
	@$(call subsection,"Backing up pip packages")
	@$(shell pip3 freeze > "${PIP_BACKUP_FILE}")
	@$(call result,"pip packages backed up to ${PIP_BACKUP_FILE}")

backup_node:
	@$(call subsection,"Backing up node packages")
	@npm list --global --parseable --depth=0 | awk 'NR > 1 {gsub(/\/.*\//,""); print $1}' > $(NPM_BACKUP_FILE)
	@$(call result,"npm packages backed up to ${NPM_BACKUP_FILE}")

backup_gems:
	@$(call subsection,"Backing up Ruby gems")
	@gem list --no-versions | awk 'NR > 1 {gsub(/\/.*\//, ""); print $1}' > $(GEMS_BACKUP_FILE)
	@$(call result,"ruby gems backed up to ${GEMS_BACKUP_FILE}")

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

install_dotbot:
	@$(call subsection,"Placeholder: Installing dotbot")

install_fonts:
	@$(call subsection,"Installing fonts")
	@find $(FONT_PATH) -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} ~/Library/Fonts \;
	@$(call result,"Fonts installed.")

install_hammerspoon:
	@$(call subsection,"Placeholder: Installimg hammerspoon")

install_launchagents:
	@$(call subsection,"Placeholder: Installing launchagents")

install_macos_config:
	@$(call subsection,"Installing macos configuration")
	$(shell /bin/bash ./os/macos/macos_defaults.sh)

install_mise:
	@$(call subsection,"Installing mise")
	@if ! which mise >/dev/null 2>&1; then \
		curl -sL https://mise.jdx.dev/mise-latest-macos-arm64 > ~/.local/bin/mise; \
		chmod +x ~/.local/bin/mise; \
		echo 'eval "$$($(HOME)/.local/bin/mise activate zsh)"' >> ~/.zshrc; \
		mise use -g usage; \
		mkdir -p $(shell brew --prefix)/share/zsh/site-functions; \
		mise completion zsh > $(shell brew --prefix)/share/zsh/site-functions/_mise; \
		echo "Mise installed and configured."; \
	else \
		echo "Mise is already installed. Skipping installation."; \
	fi

install_servers:
	@$(call subsection,"Installing servers")
	mise use --global lua@latest
	mise install

install_neovim:
	@$(call subsection,"Installing neovim nightly")
	@mise plugin add neovim
	@mise install --force neovim@nightly

install_vim:
	@$(call subsection,"Installing vim")
	@mkdir -p ~/.vim/swp ~/.vim/undo
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@vim +PlugInstall +qall
	@$(call result,"Vim plugins installed")

install_pip:
	@$(call subsection,"Installing pip packages")
	pip3 install -r $(PIP_FILE)
	@$(call result,"Pip packages installed")

install_node:
	@$(call subsection,"Installing node packages")
	xargs npm install --global < $(NPM_FILE)
	@$(call result,"Node packages installed")

install_gems:
	@$(call subsection,"Installing ruby gems")
	xargs gem install < $(GEMS_FILE)
	@$(call result,"Ruby Gems installed.")

install_chmod_dots:
	@$(call subsection,"Placeholder: Changing permissions for dotfiles")

install_writing:
	@$(call subsection,"Placeholder: Installing writing tools")

update_brew:
	@$(call subsection,"Placeholder: Updating homebrew packages")

update_dotbot:
	@$(call subsection,"Placeholder: Updating dotbot")

update_neovim:
	@$(call subsection,"Placeholder: Updating neovim")

update_vim_plugins:
	@$(call subsection,"Placeholder: Updating vim plugins")

update_pip:
	@$(call subsection,"Placeholder: Updating pip packages")

update_node:
	@$(call subsection,"Placeholder: Updating node packages")

update_gems:
	@$(call subsection,"Placeholder: Updating ruby gems")

update_servers:
	@$(call subsection,"Placeholder: Updating servers")

update_writing:
	@$(call subsection,"Placeholder: Updating writing tools")




