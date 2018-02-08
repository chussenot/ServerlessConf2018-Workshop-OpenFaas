ANSIBLE_NOCOWS=1
ANSIBLE_HOST_KEY_CHECKING=0
SD_CARD_BOOT_PARTITION:=/dev/mmcblk0p1
SD_CARD_ROOT_PARTITION:=/dev/mmcblk0p2
NODE:=slave
NUM:=001
HOSTNAME:=$(NODE)-$(NUM)
CLUSTER_NAME:=cluster_001

platform := $(shell uname)
deps := ansible

export SD_CARD_ROOT_PARTITION \
			 SD_CARD_BOOT_PARTITION \
			 HOSTNAME \
			 ANSIBLE_NOCOWS \
			 ANSIBLE_HOST_KEY_CHECKING \
			 CLUSTER_NAME

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

init: ## Bootstrap your ssh, wifi, etc.
	./init

generate_token: ## Generate a token for the K8s master of your cluster
	./generate_token

create: ## Create a cluster on the network
	./create

umount: ## Umount
	@mkdir -p build/mnt
	sudo umount build/mnt | /bin/true

mount-root: umount ## Mount the root partition
	sudo mount $(SD_CARD_ROOT_PARTITION) build/mnt

mount-boot: umount ## Mount the boot partition
	sudo mount $(SD_CARD_BOOT_PARTITION) build/mnt

.DEFAULT_GOAL: help
.PHONY: help install list-disks flash init create \
				umount mount-root mount-boot generate_token
