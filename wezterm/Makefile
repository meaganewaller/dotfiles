CONFIG_DIR = $(HOME)/.config/wezterm

all: print-info setup

print-info:
	@ echo "[wezterm]"

setup: set-symlinks

set-symlinks:
	@ mkdir -p $(CONFIG_DIR)
	
	@ ln -v -i -s $(CURDIR)/wezterm.lua $(CONFIG_DIR)/wezterm.lua


