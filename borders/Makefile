all: print-info setup

print-info:
	@echo "[borders]"

setup: set-symlinks

set-symlinks:
	@ chmod +x $(CURDIR)/bordersrc
	@ ln -v -i -s $(CURDIR)/bordersrc $(HOME)/.config/borders/bordersrc
