
VERSION=1.36.0
ARCHIVE="busybox-$(VERSION).tar.bz2"
URL="https://busybox.net/downloads/$(ARCHIVE)"
S:=$(F)/busybox-$(VERSION)
B:=$(ROOT)/build

all: busybox.$(VERSION).install.lock

busybox.$(VERSION).install.lock: busybox.$(VERSION).build.lock
	cd $(B) && make CONFIG_PREFIX=$(P) install
	touch $@

busybox.$(VERSION).build.lock: busybox.$(VERSION).configure.lock
	cd $(B) && make -j16 CROSS_COMPILE=$(CROSS_COMPILE)
	touch $@

busybox.$(VERSION).configure.lock: $(F)/busybox.$(VERSION).fetch.lock
	mkdir -p $(B)
	cd $(B) && make KBUILD_SRC=$(S) -f $(S)/Makefile defconfig
	touch $@

$(F)/busybox.$(VERSION).fetch.lock:
	cd $(F) && curl -LO $(URL)
	cd $(F) && tar xvf $(ARCHIVE)
	touch $@
