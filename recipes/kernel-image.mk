
# Determine the filename of the kernel binary based on the architecture

ifeq (x86_64,$(ARCH))
IMAGE=bzImage
else ifeq (arm,$(ARCH))
IMAGE=zImage
else
$(error "Unsupported architecture $(ARCH)")
endif
