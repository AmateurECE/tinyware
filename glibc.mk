
VERSION=2.37
ARCHIVE="glibc-$(VERSION).tar.xz"
URL="http://ftp.gnu.org/gnu/glibc/$(ARCHIVE)"
S:=$(ROOT)/glibc-$(VERSION)
B:=$(ROOT)/build

CONFIG=rtlddir=/lib64 CC="$(CROSS_COMPILE)gcc -mbe32" BUILD_CC=gcc \
	CXX="$(CROSS_COMPILE)g++ -mbe32"

all: glibc.$(VERSION).install.lock

glibc.$(VERSION).install.lock: glibc.$(VERSION).build.lock
	cd $(B) && make install ARCH=$(ARCH) DESTDIR=$(D)
	touch $@

glibc.$(VERSION).build.lock: glibc.$(VERSION).configure.lock
	cd $(B) && make -j16
	touch $@

glibc.$(VERSION).configure.lock: glibc.$(VERSION).fetch.lock
	mkdir -p $(B)
	cd $(B) \
		&& printf '%s\n' $(CONFIG) > configparms \
		&& $(S)/configure --prefix= --host=$(ARCH)-linux-gnu \
			--build=$$(uname -m)-linux-gnu libc_cv_gnu_retain=no
	touch $@

glibc.$(VERSION).fetch.lock:
	curl -LO $(URL)
	tar xvf $(ARCHIVE)
	touch $@
