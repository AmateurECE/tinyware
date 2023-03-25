
# Makefile for the minimal distribution

ARCH=arm
DTB=am335x-boneblack.dtb
KERNEL_CONFIG=omap2plus_defconfig
UBOOT_CONFIG=am335x_evm_defconfig
CROSS_COMPILE=arm-linux-gnueabihf-

# Root build directory
B:=$(shell realpath -m build/$(ARCH))
# Root source directory
S:=$(PWD)
# Deploy directory, where final build artifacts reside
D:=$(shell realpath -m build/$(ARCH)/deploy)
# Package directory, where packages are installed to be staged for rootfs
# creation
P:=$(shell realpath -m build/$(ARCH)/package)

PACKAGES=busybox glibc init linux u-boot
PACKAGES_BUILT=$(addprefix $(B)/,$(addsuffix .lock,$(PACKAGES)))

INITRAMFS=$(D)/minimal-initramfs.cpio.gz

all: $(INITRAMFS)

$(INITRAMFS): $(PACKAGES_BUILT)
	cd $(P) && find . -print0 \
		| cpio --null --create --verbose --format=newc \
		| gzip --best > $@

$(B)/linux.lock: $(B)
	mkdir -p $(B)/linux
	$(MAKE) -C $(B)/linux -f $(S)/linux.mk \
		ROOT=$(B)/linux D=$(D) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		CONFIG=$(KERNEL_CONFIG)
	touch $@

$(B)/u-boot.lock: $(B) $(D)
	mkdir -p $(B)/u-boot
	$(MAKE) -C $(B)/u-boot -f $(S)/u-boot.mk \
		ROOT=$(B)/u-boot D=$(D) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		CONFIG=$(UBOOT_CONFIG)

$(B)/busybox.lock: $(B) $(D)
	mkdir -p $(B)/busybox
	$(MAKE) -C $(B)/busybox -f $(S)/busybox.mk \
		ROOT=$(B)/busybox D=$(P) \
		CROSS_COMPILE=$(CROSS_COMPILE)
	touch $@

$(B)/glibc.lock: $(B) $(D)
	mkdir -p $(B)/glibc
	$(MAKE) -C $(B)/glibc -f $(S)/glibc.mk \
		ROOT=$(B)/glibc D=$(P) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
	touch $@

$(B)/init.lock: init.sh $(P)
	install -D $< $(P)/init
	chmod +x $(P)/init
	touch $@

$(D): ; mkdir -p $@
$(B): ; mkdir -p $@
