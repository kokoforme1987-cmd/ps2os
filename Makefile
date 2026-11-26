# ps2os host-side entry points. The ISO is built inside Docker (see docker/).
# Needs GNU make and Docker. On Windows run it from Git Bash or WSL with Docker Desktop.

IMAGE      ?= ps2os-builder
ISO        ?= out/ps2os.iso
VM_NAME    ?= ps2os
VM_MEM     ?= 2048
VBOXMANAGE ?= VBoxManage
QEMU       ?= qemu-system-x86_64
QEMU_ACCEL ?= tcg

# Git Bash rewrites /c/... style paths in arguments; docker needs them untouched.
export MSYS_NO_PATHCONV := 1

.PHONY: help setup iso vm qemu clean

help:
	@echo "make setup   build the builder image ($(IMAGE))"
	@echo "make iso     build $(ISO) inside the container (privileged)"
	@echo "make vm      create/refresh a VirtualBox VM '$(VM_NAME)' and boot the ISO"
	@echo "make qemu    boot the ISO in QEMU (QEMU_ACCEL=whpx on Windows, kvm on Linux)"
	@echo "make clean   remove out/ and build/"

setup:
	docker build -t $(IMAGE) docker

# This recipe has no pipe on purpose. A `| grep -q` or `| head` under pipefail exits 141
# (SIGPIPE) when the reader quits early; that hit CI once, in docker/build-iso.sh (D-010
# in docs/DECISIONS.md). If a pipeline is ever needed here, add
# SHELL := /bin/bash and .SHELLFLAGS := -o pipefail -c at the top and test it with `make iso`.
iso: setup
	docker run --rm --privileged \
	  -v "$(CURDIR)":/work \
	  -e HOST_UID=$$(id -u) -e HOST_GID=$$(id -g) \
	  $(IMAGE) bash /work/docker/build-iso.sh

# vm and qemu build the ISO first if it is missing.
$(ISO):
	$(MAKE) iso

vm: $(ISO)
	-$(VBOXMANAGE) createvm --name $(VM_NAME) --ostype Debian_64 --register
	$(VBOXMANAGE) modifyvm $(VM_NAME) --memory $(VM_MEM) --vram 128 --cpus 2 --graphicscontroller vmsvga --boot1 dvd --boot2 none --boot3 none --boot4 none
	-$(VBOXMANAGE) storagectl $(VM_NAME) --name IDE --add ide
	$(VBOXMANAGE) storageattach $(VM_NAME) --storagectl IDE --port 0 --device 0 --type dvddrive --medium $(ISO)
	$(VBOXMANAGE) startvm $(VM_NAME)

qemu: $(ISO)
	$(QEMU) -m $(VM_MEM) -smp 2 -accel $(QEMU_ACCEL) -cdrom $(ISO) -boot d -vga std

clean:
	rm -rf out build
