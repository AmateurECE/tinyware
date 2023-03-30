
VERSION=v2021.01
S:=$(F)/u-boot
B:=$(ROOT)/build

all: u-boot.$(VERSION).deploy.lock

u-boot.$(VERSION).deploy.lock: u-boot.$(VERSION).build.lock
	: # Invoke the machine-dependent image build script
	$(MAKE) -f $(IMAGE_BUILD) B=$(B) D=$(D)
	touch $@

u-boot.$(VERSION).build.lock: u-boot.$(VERSION).configure.lock
	cd $(S) && make ARCH=$(ARCH) O=$(B) CROSS_COMPILE=$(CROSS_COMPILE) -j16
	touch $@

u-boot.$(VERSION).configure.lock: $(F)/u-boot.$(VERSION).fetch.lock
	mkdir -p $(B)
	cd $(S) && make ARCH=$(ARCH) O=$(B) $(CONFIG)
	touch $@

$(F)/u-boot.$(VERSION).fetch.lock:
	git clone "https://source.denx.de/u-boot/u-boot.git" $(S)
	cd $(S) && git checkout $(VERSION)
	touch $@
