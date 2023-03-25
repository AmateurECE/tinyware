
# Makefile for the minimal distribution

B:=$(shell realpath build)
S:=$(PWD)
D:=$(shell realpath build/deploy)

PACKAGES=busybox glibc init
PACKAGES_BUILT=$(addprefix $(B)/,$(addsuffix .lock,$(PACKAGES)))

INITRAMFS=$(B)/minimal-initramfs.cpio.gz

all: $(INITRAMFS)

$(INITRAMFS): $(PACKAGES_BUILT)
	cd $(D) && find . -print0 \
		| cpio --null --create --verbose --format=newc \
		| gzip --best > $@

$(B)/busybox.lock: $(B) $(D)
	mkdir -p $(B)/busybox
	$(MAKE) -C $(B)/busybox -f $(S)/busybox.mk ROOT=$(B)/busybox D=$(D)
	touch $@

$(B)/glibc.lock: $(B) $(D)
	mkdir -p $(B)/glibc
	$(MAKE) -C $(B)/glibc -f $(S)/glibc.mk ROOT=$(B)/glibc D=$(D)
	touch $@

$(B)/init.lock: init.sh $(D)
	install -D $< $(D)/init
	chmod +x $(D)/init
	touch $@

$(D): ; mkdir -p $@
$(B): ; mkdir -p $@
