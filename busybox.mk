
VERSION=1.36.0
ARCHIVE="busybox-$(VERSION).tar.bz2"
URL="https://busybox.net/downloads/$(ARCHIVE)"
S:=$(ROOT)/busybox-$(VERSION)

all: busybox.$(VERSION).install.lock

busybox.$(VERSION).install.lock: busybox.$(VERSION).build.lock
	cd $(S) && make install DESTDIR=$(D)
	touch $@

busybox.$(VERSION).build.lock: busybox.$(VERSION).configure.lock
	cd $(S) && make -j16
	touch $@

busybox.$(VERSION).configure.lock: busybox.$(VERSION).fetch.lock
	cd $(S) && make defconfig
	touch $@

busybox.$(VERSION).fetch.lock:
	curl -LO $(URL)
	tar xvf $(ARCHIVE)
	touch $@
