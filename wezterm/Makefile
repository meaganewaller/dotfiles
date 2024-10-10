CONFIG_DIR = $(HOME)/.config/wezterm

all: print-info setup

print-info:
	@ echo "[wezterm]"

setup: set-symlinks

set-symlinks:
	@ mkdir -p $(CONFIG_DIR)
	
	@ ln -s $(CURDIR)/*.lua       $(CONFIG_DIR)/
	@ ln -s $(CURDIR)/backgrounds $(CONFIG_DIR)/
	@ ln -s $(CURDIR)/domains     $(CONFIG_DIR)/
	@ ln -s $(CURDIR)/events      $(CONFIG_DIR)/
	@ ln -s $(CURDIR)/utils       $(CONFIG_DIR)/
