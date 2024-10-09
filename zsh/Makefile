all: print-info setup

print-info:
	@ echo "[zsh]"

setup: set-symlinks

set-symlinks:
	@ ln -v -i -s $(CURDIR)/zshrc $(HOME)/.zshrc
