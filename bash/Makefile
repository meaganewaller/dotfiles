all: print-info setup

print-info:
	@ echo "[Bash]"

setup: set-symlinks

set-symlinks:
	@ ln -v -i -s $(CURDIR)/bashrc $(HOME)/.bashrc
	@ ln -v -i -s $(CURDIR)/bash_profile $(HOME)/.bash_profile
	@ ln -v -i -s $(CURDIR)/inputrc $(HOME)/.inputrc


