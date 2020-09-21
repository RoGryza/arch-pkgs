SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

OUT := out
JN := jsonnet --jpath .
FD := find . -path ./$(OUT) -prune -o -print -type f -name

NAME := rogryza
MAIN := $(NAME).jsonnet

VERSION := $(shell $(JN) --string --exec '(import "$(MAIN)").pkgver')
REL := $(shell $(JN) --exec '(import "$(MAIN)").pkgrel')

SRC := $(MAIN) $(shell $(FD) '*.jsonnet' -print) $(shell $(FD) '*.libsonnet' -print)
TARBALL := $(OUT)/$(NAME)-$(VERSION)-$(REL)-x86_64.pkg.tar.zst
DB := $(OUT)/rogryza.db.tar.gz

.PHONY: clean install

default: $(OUT)/PKGBUILD
all: $(TARBALL) $(DB)
tarball: $(TARBALL)
db: $(DB)

install: $(TARBALL)
	(cd $(OUT) && makepkg -i)

$(DB): $(TARBALL)
	repo-add $(DB) $(TARBALL)

$(TARBALL):  $(OUT)/.SRCINFO
	(cd $(OUT) && makepkg -csf)

$(OUT)/.SRCINFO: $(OUT)/PKGBUILD
	(cd $(OUT) && makepkg --printsrcinfo > .SRCINFO)

$(OUT)/PKGBUILD: $(SRC)
	mkdir -p $(OUT)
	$(JN) --string --exec '(import "$(MAIN)")._output' --multi $(OUT)
	(cd $(OUT) && updpkgsums)

clean:
	rm -rf $(OUT)
