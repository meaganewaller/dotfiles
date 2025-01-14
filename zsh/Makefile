all: print-info setup

print-info:
	@ echo "[zsh]"

setup: set-symlinks

set-symlinks:
	@ mkdir -p $(HOME)/.config/zsh
	@ ln -v -i -s $(CURDIR)/zshrc $(HOME)/.zshrc
