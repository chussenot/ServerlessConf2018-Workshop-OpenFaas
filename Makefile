platform := $(shell uname)
deps := ansible

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install: install-tools ## The install rule sets up the development environment on the machine it's ran on.

ifeq (${platform},Darwin)
install-tools:
	@brew install ${deps}
else
install-tools:
	@echo "${platform} is a platform we have no presets for, you'll have to install the third party dependencies manually"
endif

list-disks: ## List all disks
	@diskutil list

flash: ## Flash your micro-sd cards
	./flash

configure: ## Configure a raspi on the network
	./configure

.PHONY: help install list-disks flash configure
