
# Generate a configuration file for PXE boot

CONFIG+="LABEL linux"
CONFIG+="LINUX $(IMAGE)"
CONFIG+="FDT $(DTB)"
CONFIG+="APPEND console=$(CONSOLE)"

$(D)/pxelinux.cfg/default:
	mkdir -p $(@D)
	printf '%s\n' $(CONFIG) > $@
