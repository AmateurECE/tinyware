
# Build script for the kernel

VERSION=6.3-rc3
ARCHIVE=linux-$(VERSION).tar.gz
URL="https://git.kernel.org/torvalds/t/$(ARCHIVE)"

B:=$(ROOT)/build
S:=$(F)/linux-$(VERSION)

ARTIFACTS+=$(D)/$(IMAGE)
ifneq (,$(DTB))
ARTIFACTS+=$(D)/$(DTB)
endif

all: $(ARTIFACTS) kernel.$(VERSION).headers.lock

$(D)/$(IMAGE): kernel.$(VERSION).build.lock
	cp $(B)/arch/$(ARCH)/boot/$(IMAGE) $@
	cd $(S) && make ARCH=$(ARCH) O=$(B) INSTALL_MOD_PATH=$(P) \
		modules_install

$(D)/$(DTB): kernel.$(VERSION).build.lock
	cp $(B)/arch/$(ARCH)/boot/dts/$(DTB) $@

kernel.$(VERSION).headers.lock: kernel.$(VERSION).build.lock
	cd $(S) && make ARCH=$(ARCH) O=$(B) INSTALL_HDR_PATH=$(DEST_SYSROOT) \
		headers_install
	touch $@

kernel.$(VERSION).build.lock: kernel.$(VERSION).configure.lock
	cd $(S) && make CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) O=$(B) -j16
	cd $(S) && make CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) O=$(B) \
		-j16 modules
	touch $@

kernel.$(VERSION).configure.lock: $(F)/kernel.$(VERSION).fetch.lock
	cd $(S) && make ARCH=$(ARCH) O=$(B) $(CONFIG)
	if test -n $(CUSTOM_CONFIG); then \
		cd $(B) && $(S)/scripts/kconfig/merge_config.sh \
			$(B)/.config \
			$(CUSTOM_CONFIG); \
	fi
	touch $@

$(F)/kernel.$(VERSION).fetch.lock:
	cd $(F) && curl -LO $(URL)
	cd $(F) && tar xvf $(ARCHIVE)
	touch $@
