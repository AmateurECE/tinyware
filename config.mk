
ifeq (boneblack,$(MACHINE))
ARCH:=arm
DTB:=am335x-boneblack.dtb
KERNEL_CONFIG:=omap2plus_defconfig
UBOOT_CONFIG:=am335x_evm_defconfig
UBOOT_CUSTOM_CONFIG:=$(S)/target/boneblack/u-boot.cfg
CROSS_COMPILE:=arm-linux-gnueabihf-

CONSOLE=ttyO0,115200n8

# boneblack config also depends on u-boot
PACKAGES:=u-boot pxelinux

else ifeq (qemu,$(MACHINE))
ARCH:=x86_64
KERNEL_CONFIG:=defconfig
CROSS_COMPILE=x86_64-linux-gnu-
else
$(error "Set the variable MACHINE to be one of {qemu,boneblack}")
endif
