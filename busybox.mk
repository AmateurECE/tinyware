
VERSION=1.36.0
ARCHIVE="busybox-$(VERSION).tar.bz2"
URL="https://busybox.net/downloads/$(ARCHIVE)"
S:=$(ROOT)/busybox-$(VERSION)

all: busybox.$(VERSION).install.lock

busybox.$(VERSION).install.lock: busybox.$(VERSION).build.lock
	cd $(S) && make install DESTDIR=$(D)
	touch $@

busybox.$(VERSION).build.lock: busybox.$(VERSION).configure.lock
	cd $(S) && make -j16 CROSS_COMPILE=$(CROSS_COMPILE)
	touch $@

busybox.$(VERSION).configure.lock: busybox.$(VERSION).unpack.lock
	cd $(S) && make defconfig
	touch $@

# As far as I can tell, busybox does not support out-of-tree builds, so we
# must have a separate "unpack" step
busybox.$(VERSION).unpack.lock: $(F)/busybox.$(VERSION).fetch.lock
	tar xvf $(F)/$(ARCHIVE)
	touch $@

$(F)/busybox.$(VERSION).fetch.lock:
	cd $(F) && curl -LO $(URL)
	touch $@
