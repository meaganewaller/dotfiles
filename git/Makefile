all: print-info setup

print-info:
	@ echo "[git]"

setup: set-symlinks

set-symlinks:
	@ ln -v -i -s $(CURDIR)/gitconfig $(HOME)/.gitconfig
	@ ln -v -i -s $(CURDIR)/gitignore-global $(HOME)/.gitignore-global
