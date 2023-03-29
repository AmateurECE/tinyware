
# This value is provided by CONFIG_SYS_MMCSD_RAW_MODE_U_BOOT_SECTOR=0x300 in
# the defconfig
SECTOR_OFFSET=768
# The size of a "disk sector"
BS=512

$(D)/tinyware.img:
	dd if=/dev/zero bs=$(BS) count=$(SECTOR_OFFSET) of=$@
	dd if=$(B)/MLO conv=notrunc of=$@
	dd if=$(B)/u-boot.img conv=notrunc bs=$(BS) seek=$(SECTOR_OFFSET) of=$@
