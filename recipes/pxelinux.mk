
# Generate a configuration file for PXE boot

# PXE Linux configuration
CONFIG+="LABEL linux"
CONFIG+="LINUX $(IMAGE)"
ifneq (,$(DTB))
CONFIG+="FDT $(DTB)"
endif
ifneq (,$(INITRD))
CONFIG+="INITRD $(INITRD)"
endif
ifneq (,$(BOOTARGS))
CONFIG+="APPEND $(BOOTARGS)"
endif

$(D)/pxelinux.cfg/default:
	mkdir -p $(@D)
	printf '%s\n' $(CONFIG) > $@
