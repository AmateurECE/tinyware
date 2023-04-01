
ifeq (arm,$(ARCH))
HOST=arm-linux-gnueabihf
else ifeq (x86_64,$(ARCH))
HOST=$(ARCH)-linux-gnu
else
$(error "Unsupported architecture $(ARCH)")
endif

VERSION=1.35
URL="https://gitlab.freedesktop.org/libevdev/evtest.git"
S:=$(ROOT)/evtest

all: evtest.$(VERSION).deploy.lock

evtest.$(VERSION).deploy.lock: evtest.$(VERSION).build.lock
	cd $(S) && make install DESTDIR=$(P)
	touch $@

evtest.$(VERSION).build.lock: evtest.$(VERSION).configure.lock
	cd $(S) && make
	touch $@

evtest.$(VERSION).configure.lock: evtest.$(VERSION).fetch.lock
	cd $(S) && autoreconf -iv
	cd $(S) && ./configure --prefix=/usr \
		--host=$(HOST) \
		--build=$$(uname -m)-linux-gnu
	touch $@

evtest.$(VERSION).fetch.lock:
	git clone $(URL) $(S)
	cd $(S) && git checkout evtest-$(VERSION)
	touch $@
