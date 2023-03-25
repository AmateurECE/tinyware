
# Makefile for the minimal distribution

ARCH=arm
DTB=am335x-boneblack.dtb
CONFIG=omap2plus_defconfig
CROSS_COMPILE=arm-linux-gnueabi-

B:=$(shell realpath -m build/$(ARCH))
S:=$(PWD)
D:=$(shell realpath -m build/$(ARCH)/deploy)

PACKAGES=busybox glibc init linux
PACKAGES_BUILT=$(addprefix $(B)/,$(addsuffix .lock,$(PACKAGES)))

INITRAMFS=$(B)/minimal-initramfs.cpio.gz

all: $(INITRAMFS)

$(INITRAMFS): $(PACKAGES_BUILT)
	cd $(D) && find . -print0 \
		| cpio --null --create --verbose --format=newc \
		| gzip --best > $@

$(B)/linux.lock: $(B)
	mkdir -p $(B)/linux
	$(MAKE) -C $(B)/linux -f $(S)/linux.mk \
		ROOT=$(B)/linux D=$(B) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) \
		CONFIG=$(CONFIG)
	touch $@

$(B)/busybox.lock: $(B) $(D)
	mkdir -p $(B)/busybox
	$(MAKE) -C $(B)/busybox -f $(S)/busybox.mk \
		ROOT=$(B)/busybox D=$(D) \
		CROSS_COMPILE=$(CROSS_COMPILE)
	touch $@

$(B)/glibc.lock: $(B) $(D)
	mkdir -p $(B)/glibc
	$(MAKE) -C $(B)/glibc -f $(S)/glibc.mk \
		ROOT=$(B)/glibc D=$(D) \
		CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH)
	touch $@

$(B)/init.lock: init.sh $(D)
	install -D $< $(D)/init
	chmod +x $(D)/init
	touch $@

$(D): ; mkdir -p $@
$(B): ; mkdir -p $@
