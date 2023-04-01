
# BeagleBone Black
ifeq (boneblack,$(MACHINE))
ARCH:=arm
DTB:=am335x-boneblack.dtb
KERNEL_CONFIG:=omap2plus_defconfig
KERNEL_CUSTOM_CONFIG:=$(S)/target/boneblack/linux.cfg
UBOOT_CONFIG:=am335x_evm_defconfig
UBOOT_CUSTOM_CONFIG:=$(S)/target/boneblack/u-boot.cfg
CROSS_COMPILE:=arm-linux-gnueabihf-

# Console
BOOTARGS+=console=ttyO0,115200n8

# Mount root over NFS
BOOTARGS+=root=/dev/nfs
BOOTARGS+=nfsroot=10.0.0.1:/srv/root
BOOTARGS+=ip=dhcp
BOOTARGS+=g_ether.host_addr=de:ad:be:ef:00:00
BOOTARGS+=g_ether.dev_addr=de:ad:be:ef:00:01
BOOTARGS+=rootwait
BOOTARGS+=rw
BOOTARGS+=nfsrootdebug

PACKAGES:=u-boot pxelinux

# QEMU
else ifeq (qemu,$(MACHINE))
ARCH:=x86_64
KERNEL_CONFIG:=defconfig
CROSS_COMPILE=x86_64-linux-gnu-
else
$(error "Set the variable MACHINE to be one of {qemu,boneblack}")
endif
