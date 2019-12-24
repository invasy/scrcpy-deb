SHELL := /bin/bash

REPO_URI := https://github.com/Genymobile/scrcpy

changelog    != head --lines=1 debian/changelog
pkg_name     := $(word 1,$(changelog))
pkg_version  := $(subst -, ,$(patsubst (%),%,$(word 2,$(changelog))))
pkg_revision := $(lastword $(pkg_version))
pkg_version  := $(firstword $(pkg_version))
pkg_arch     != dpkg-architecture\
 | grep --perl-regexp --only-matching '(?<=^DEB_BUILD_ARCH=).*$$'
pkg_src_dir  := $(pkg_name)-$(pkg_version)
pkg_file     := $(pkg_name)_$(pkg_version)-$(pkg_revision)_$(pkg_arch).deb

git_clone = git clone --quiet -c advice.detachedHead=false\
 $(if $3, --branch 'v$3') --depth 1 '$1' '$2'
debian_rules = $(if $2,if [[ -d '$(pkg_src_dir)' ]]; then)\
 $(MAKE) --quiet --directory='$(pkg_src_dir)'\
 --makefile=debian/rules --jobs=$$(nproc) $1$(if $2,; fi)

fg_green   != tput setaf 2
fg_brown   != tput setaf 3
fg_magenta != tput setaf 5
fg_default != tput sgr0

.PHONY: all scrcpy deb install clean distclean

all: scrcpy
scrcpy deb: $(pkg_file)

$(pkg_src_dir):
	@$(call git_clone,$(REPO_URI),$@,$(pkg_version)) && \
	ln -s ../debian "$@/" && \
	cp scrcpy.service "$@/"

$(pkg_file): $(pkg_src_dir)
	@$(call debian_rules,clean,may_fail) && \
	$(call debian_rules,build) && \
	$(call debian_rules,binary)

install: $(pkg_file)
	@apt install '$(abspath $<)'

clean:
	@-$(call debian_rules,clean,may_fail)
	@-rm -rf *.deb *.ddeb

distclean: clean
	@-rm -rf $(pkg_src_dir)
