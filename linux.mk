
# Build script for the kernel

ifeq (x86,$(ARCH))
IMAGE=bzImage
else
IMAGE=zImage
endif

VERSION=6.3-rc3
ARCHIVE=linux-$(VERSION).tar.gz
URL="https://git.kernel.org/torvalds/t/$(ARCHIVE)"

B:=$(ROOT)/build
S:=$(ROOT)/linux-$(VERSION)

all: $(D)/$(IMAGE)

$(D)/$(IMAGE): kernel.$(VERSION).build.lock
	cp $(B)/arch/$(ARCH)/boot/$(IMAGE) $@

kernel.$(VERSION).build.lock: kernel.$(VERSION).configure.lock
	cd $(S) && make CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) O=$(B) -j16
	touch $@

kernel.$(VERSION).configure.lock: kernel.$(VERSION).fetch.lock
	cd $(S) && make ARCH=$(ARCH) O=$(B) $(CONFIG)
	touch $@

kernel.$(VERSION).fetch.lock:
	curl -LO $(URL)
	tar xvf $(ARCHIVE)
	touch $@
