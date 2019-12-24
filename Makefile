SHELL := /bin/bash

changelog != head --lines=1 debian/changelog
pkg_name := $(word 1,$(changelog))
pkg_version := $(subst -, ,$(patsubst (%),%,$(word 2,$(changelog))))
pkg_revision := $(lastword $(pkg_version))
pkg_version := $(firstword $(pkg_version))
pkg_arch := amd64
pkg_src_dir := $(pkg_name)-$(pkg_version)
pkg_file := $(pkg_name)_$(pkg_version)-$(pkg_revision)_$(pkg_arch).deb

debian_rules = $(MAKE) --quiet --directory="$(pkg_src_dir)" --makefile=debian/rules --jobs=$$(nproc) $1

REPO_URI := https://github.com/Genymobile/scrcpy

fg_green != tput setaf 2
fg_brown != tput setaf 3
fg_magenta != tput setaf 5
fg_default != tput sgr0

all: scrcpy
scrcpy deb: $(pkg_file)

$(pkg_src_dir):
	@echo -e "  $(fg_green)CLONE$(fg_default)\t$@" && \
	git clone --quiet --branch 'v$(pkg_version)' --depth 1 '$(REPO_URI)' '$@' && \
	ln -s ../debian "$@/" && \
	cp scrcpy.service "$@/"

$(pkg_file): $(pkg_src_dir)
	@echo -e "  $(fg_magenta)BUILD$(fg_default)\t$@" && \
	{ $(call debian_rules,clean) || :; } && \
	$(call debian_rules,build) && \
	$(call debian_rules,binary)

clean:
	@-$(call debian_rules,clean); \
	rm -rf *.deb *.ddeb

distclean: clean
	@-rm -rf $(pkg_src_dir)

.PHONY: all scrcpy deb clean distclean

