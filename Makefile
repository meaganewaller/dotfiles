SUB_DIRS = $(shell ls -d */)

all: print-info make-all

print-info:
	@ echo "This makefile runs all sub directories makefiles."

make-all:
	@ for each in $(SUB_DIRS); do \
		echo ""; \
		make -C $$each --quiet; \
	done
