all: print-info setup

print-info:
	@ echo "[git]"

setup: set-symlinks

set-symlinks:
	@ ln -v -i -s $(CURDIR)/gitconfig $(HOME)/.gitconfig
	@ ln -v -i -s $(CURDIR)/gitconfig-local $(HOME)/.gitconfig-local
	@ ln -v -i -s $(CURDIR)/gitignore-global $(HOME)/.gitignore-global
	@ ln -v -i -s $(CURDIR)/gitmessage $(HOME)/.gitmessage
	@ ln -v -i -s $(CURDIR)/gitattributes $(HOME)/.gitattributes
