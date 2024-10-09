CONFIG_DIR = $(HOME)/.config/fish

all: print-info setup

print-info:
	@ echo "[fish]"

setup: set-symlinks

set-symlinks:
	@ mkdir -p $(CONFIG_DIR)

	@ ln -v -i -s $(CURDIR)/config.fish  $(CONFIG_DIR)/config.fish
	@ ln -v -i -s $(CURDIR)/private.fish $(CONFIG_DIR)/private.fish
	@ ln -v -i -s $(CURDIR)/fish_plugins $(CONFIG_DIR)/fish_plugins

	@ ln -v -i -s -f -n $(CURDIR)/functions   $(CONFIG_DIR)
	@ ln -v -i -s -f -n $(CURDIR)/conf.d      $(CONFIG_DIR)
	@ ln -v -i -s -f -n $(CURDIR)/completions $(CONFIG_DIR)
	@ ln -v -i -s -f -n $(CURDIR)/themes      $(CONFIG_DIR)

set-fish-shell:
	@ echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
	@ echo chsh -s /opt/homebrew/bin/fish
