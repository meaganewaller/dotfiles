CONFIG_DIR = $(HOME)/.config/starship

all: print-info setup

print-info:
	@ echo "[starship]"

setup: set-symlinks

set-symlinks:
	@ mkdir -p $(CONFIG_DIR)
	
	@ ln -v -i -s $(CURDIR)/starship.toml $(CONFIG_DIR)/starship.toml

