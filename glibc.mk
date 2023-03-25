
VERSION=2.37
ARCHIVE="glibc-$(VERSION).tar.xz"
URL="http://ftp.gnu.org/gnu/glibc/$(ARCHIVE)"
S:=$(ROOT)/glibc-$(VERSION)
B:=$(ROOT)/build

all: glibc.$(VERSION).install.lock

glibc.$(VERSION).install.lock: glibc.$(VERSION).build.lock
	cd $(B) && make install DESTDIR=$(D)
	touch $@

glibc.$(VERSION).build.lock: glibc.$(VERSION).configure.lock
	cd $(B) && make -j16
	touch $@

glibc.$(VERSION).configure.lock: glibc.$(VERSION).fetch.lock
	mkdir -p $(B)
	cd $(B) \
		&& printf '%s\n' "rtlddir=/lib64" > configparms \
		&& $(S)/configure --prefix=
	touch $@

glibc.$(VERSION).fetch.lock:
	curl -LO $(URL)
	tar xvf $(ARCHIVE)
	touch $@
