
# Build script for the kernel

ifeq (x86_64,$(ARCH))
IMAGE=bzImage
else ifeq (arm,$(ARCH))
IMAGE=zImage
else
$(error "Unsupported architecture $(ARCH)")
endif

VERSION=6.3-rc3
ARCHIVE=linux-$(VERSION).tar.gz
URL="https://git.kernel.org/torvalds/t/$(ARCHIVE)"

B:=$(ROOT)/build
S:=$(F)/linux-$(VERSION)

all: $(D)/$(IMAGE) kernel.$(VERSION).headers.lock

$(D)/$(IMAGE): kernel.$(VERSION).build.lock
	cp $(B)/arch/$(ARCH)/boot/$(IMAGE) $@

kernel.$(VERSION).headers.lock: kernel.$(VERSION).build.lock
	cd $(S) && make ARCH=$(ARCH) O=$(B) INSTALL_HDR_PATH=$(DEST_SYSROOT) \
		headers_install
	touch $@

kernel.$(VERSION).build.lock: kernel.$(VERSION).configure.lock
	cd $(S) && make CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) O=$(B) -j16
	touch $@

kernel.$(VERSION).configure.lock: $(F)/kernel.$(VERSION).fetch.lock
	cd $(S) && make ARCH=$(ARCH) O=$(B) $(CONFIG)
	touch $@

$(F)/kernel.$(VERSION).fetch.lock:
	cd $(F) && curl -LO $(URL)
	cd $(F) && tar xvf $(ARCHIVE)
	touch $@
