SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

NAME := $(shell printf "$$(cat pkg/PKGBUILD)"'\necho $$pkgname\n' | bash)
VERSION := $(shell printf "$$(cat pkg/PKGBUILD)"'\necho $$pkgver-$$pkgrel\n' | bash)

TARBALL := pkg/$(NAME)-$(VERSION)-x86_64.pkg.tar.zst
DB := pkg/rogryza.db.tar.gz

.PHONY: clean install

default: tarball
all: $(TARBALL) $(DB)
tarball: $(TARBALL)
db: $(DB)

install: $(TARBALL)
	(cd pkg && makepkg -i)

$(DB): $(TARBALL)
	repo-add $(DB) $(TARBALL)

$(TARBALL): pkg/.SRCINFO
	(cd pkg && makepkg -csf)

pkg/.SRCINFO: pkg/PKGBUILD
	(cd pkg && makepkg --printsrcinfo > .SRCINFO)

clean:
	rm -rf $(OUT)
