
# Root build directory
B:=$(shell realpath -m build/$(MACHINE))
# Root source directory
S:=$(PWD)
# Deploy directory, where final build artifacts reside
D:=$(shell realpath -m build/$(MACHINE)/deploy)
# Package directory, where packages are installed to be staged for rootfs
# creation
P:=$(shell realpath -m build/$(MACHINE)/root)
# Fetch directory, where sources are cloned to
F:=$(shell realpath -m build/sources)
# Sysroot, a location to install dependencies for cross compilation
SYSROOT:=$(shell realpath -m build/$(MACHINE)/sysroot)

include config.mk
include recipes/kernel-image.mk

PACKAGES+=busybox glibc init linux
PACKAGES_BUILT=$(addprefix $(B)/,$(addsuffix .lock,$(PACKAGES)))

INITRAMFS=$(D)/minimal-initramfs.cpio.gz

all: $(INITRAMFS)

$(INITRAMFS): $(PACKAGES_BUILT)
	cd $(P) && find . -print0 \
		| cpio --null --create --verbose --format=newc \
		| gzip --best > $@

$(B)/linux.lock: $(B) $(D) $(F) $(SYSROOT)
	mkdir -p $(B)/linux
	$(MAKE) -C $(B)/linux -f $(S)/recipes/linux.mk \
		ROOT=$(B)/linux D=$(D) F=$(F) DTB=$(DTB) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) IMAGE=$(IMAGE) \
		CONFIG=$(KERNEL_CONFIG) DEST_SYSROOT=$(SYSROOT)
	touch $@

$(B)/u-boot.lock: $(B) $(D) $(F)
	mkdir -p $(B)/u-boot
	$(MAKE) -C $(B)/u-boot -f $(S)/recipes/u-boot.mk \
		ROOT=$(B)/u-boot D=$(D) F=$(F) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		DEFCONFIG=$(UBOOT_CONFIG) \
		CUSTOM_CONFIG=$(UBOOT_CUSTOM_CONFIG) \
		IMAGE_BUILD=$(S)/target/$(MACHINE)/image.mk \

$(B)/busybox.lock: $(B) $(P) $(F)
	mkdir -p $(B)/busybox
	$(MAKE) -C $(B)/busybox -f $(S)/recipes/busybox.mk \
		ROOT=$(B)/busybox P=$(P) F=$(F) \
		CROSS_COMPILE=$(CROSS_COMPILE)
	touch $@

$(B)/glibc.lock: $(B) $(P) $(F) $(SYSROOT) $(B)/linux.lock
	mkdir -p $(B)/glibc
	$(MAKE) -C $(B)/glibc -f $(S)/recipes/glibc.mk \
		ROOT=$(B)/glibc P=$(P) F=$(F) SYSROOT=$(SYSROOT) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
	touch $@

$(B)/pxelinux.lock: $(D)
	$(MAKE) -f $(S)/recipes/pxelinux.mk D=$(D) IMAGE=$(IMAGE) DTB=$(DTB) \
		CONSOLE=$(CONSOLE)
	touch $@

$(B)/init.lock: $(S)/init.sh $(P)
	install -D $< $(P)/init
	: # Pre-populate mountpoints for special filesystems
	mkdir -p $(P)/sys
	mkdir -p $(P)/proc
	mkdir -p $(P)/dev
	chmod +x $(P)/init
	touch $@

$(D): ; mkdir -p $@
$(B): ; mkdir -p $@
$(P): ; mkdir -p $@
$(F): ; mkdir -p $@
$(SYSROOT): ; mkdir -p $@
