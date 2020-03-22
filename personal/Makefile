SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

NAME := rogryza
VERSION := 0.0.1
REL := 1

OUT := out
JN := jsonnet --jpath .
FD := find . -path ./$(OUT) -prune -o -print -type f -name

MAIN := $(NAME).jsonnet
SRC := $(MAIN) $(shell $(FD) '*.jsonnet' -print) $(shell $(FD) '*.libsonnet' -print)
TARBALL := $(OUT)/$(NAME)-$(VERSION)-$(REL)-x86_64.pkg.tar.xz

.PHONY: clean install

default: $(OUT)/PKGBUILD
all: $(TARBALL)

install: $(TARBALL)
	(cd $(OUT) && makepkg -i)

$(TARBALL):  $(OUT)/.SRCINFO
	(cd $(OUT) && makepkg -csf)

$(OUT)/.SRCINFO: $(OUT)/PKGBUILD
	(cd $(OUT) && makepkg --printsrcinfo > .SRCINFO)

$(OUT)/PKGBUILD: $(SRC) 
	mkdir -p $(OUT)
	$(JN) --string "$(MAIN)" --multi $(OUT)
	(cd $(OUT) && updpkgsums)

clean:
	rm -rf $(OUT)
