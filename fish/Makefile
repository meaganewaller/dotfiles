CONFIG_DIR = $(HOME)/.config/fish

all: print-info setup

print-info:
	@ echo "[fish]"

setup: set-symlinks

set-symlinks:
	@ mkdir -p $(CONFIG_DIR)
	@ mkdir -p $(CONFIG_DIR)/functions
	@ mkdir -p $(CONFIG_DIR)/themes
	@ mkdir -p $(CONFIG_DIR)/completions
	@ mkdir -p $(CONFIG_DIR)/conf.d


	@ ln -v -i -s $(CURDIR)/config.fish  $(CONFIG_DIR)/config.fish
	@ ln -v -i -s $(CURDIR)/private.fish $(CONFIG_DIR)/private.fish
	@ ln -v -i -s $(CURDIR)/fish_plugins $(CONFIG_DIR)/fish_plugins

	@ ln -s $(CURDIR)/functions/*   $(CONFIG_DIR)/functions/
	@ ln -s $(CURDIR)/conf.d/*      $(CONFIG_DIR)/conf.d/
	@ ln -s $(CURDIR)/completions/* $(CONFIG_DIR)/completions/
	@ ln -s $(CURDIR)/themes/*      $(CONFIG_DIR)/themes/

set-fish-shell:
	@ echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
	@ echo chsh -s /opt/homebrew/bin/fish
