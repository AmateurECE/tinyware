
ifeq (arm,$(ARCH))
# For compiling on arm, we have to explicitly tell gcc/g++ we're compiling for
# a big-endian, 32-bit machine.
CONFIG+=CC="$(CROSS_COMPILE)gcc -mbe32"
CONFIG+=CXX="$(CROSS_COMPILE)g++ -mbe32"

EXTRA_CONF=libc_cv_gnu_retain=no
HOST=arm-linux-gnueabihf
else
HOST=$(ARCH)-linux-gnu
endif

VERSION=2.37
ARCHIVE="glibc-$(VERSION).tar.xz"
URL="http://ftp.gnu.org/gnu/glibc/$(ARCHIVE)"
S:=$(F)/glibc-$(VERSION)
B:=$(ROOT)/build

CONFIG+=rtlddir=/lib64 BUILD_CC=gcc

all: glibc.$(VERSION).install.lock

glibc.$(VERSION).install.lock: glibc.$(VERSION).build.lock
	cd $(B) && make install ARCH=$(ARCH) DESTDIR=$(P)
	touch $@

glibc.$(VERSION).build.lock: glibc.$(VERSION).configure.lock
	cd $(B) && make -j16
	touch $@

glibc.$(VERSION).configure.lock: $(F)/glibc.$(VERSION).fetch.lock
	mkdir -p $(B)
	cd $(B) && printf '%s\n' $(CONFIG) > configparms
	cd $(B) && $(S)/configure \
		--prefix= \
		--host=$(HOST) \
		--build=$$(uname -m)-linux-gnu \
		--with-headers=$(SYSROOT)/include \
		--without-selinux $(EXTRA_CONF)
	touch $@

$(F)/glibc.$(VERSION).fetch.lock:
	cd $(F) && curl -LO $(URL)
	cd $(F) && tar xvf $(ARCHIVE)
	touch $@
