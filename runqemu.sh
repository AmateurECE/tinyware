#!/bin/sh
RUNTIME_DIR=/run

DEPLOY=build/qemu/deploy
ROOTFS=$PWD/build/qemu/root/lib/modules
CONSOLE_SOCK=${RUNTIME_DIR}/qemu-console.sock
NUNCHUK_SOCK=${XDG_RUNTIME_DIR}/nunchuk.sock0
VIRTIOFSD_SOCK=${RUNTIME_DIR}/virtiofsd.sock
MEM_FILE=${RUNTIME_DIR}/qemu-mem

# VHOST_USER_NUNCHUK=../vhost-user-nunchuk/vhost-user-nunchuk/target/debug/vhost-user-nunchuk
# $VHOST_USER_NUNCHUK --socket-path ${XDG_RUNTIME_DIR}/nunchuk.sock \
    #     --device-list i2c-0:52 &

sudo /usr/lib/qemu/virtiofsd \
     --socket-path=${VIRTIOFSD_SOCK} \
     -o source=$ROOTFS \
     -o cache=none &

sudo qemu-system-x86_64 \
     -cpu qemu64-v1 \
     -m 2048M \
     -kernel ${DEPLOY}/bzImage \
     -initrd ${DEPLOY}/minimal-initramfs.cpio.gz \
     -monitor stdio \
     -chardev socket,id=serial0,path=${CONSOLE_SOCK},server=on \
     -serial chardev:serial0 \
     -nographic \
     -vga none \
     -append 'console=ttyS0,115200n8' \
     -chardev socket,path=${NUNCHUK_SOCK},id=nunchuk \
     -device vhost-user-i2c-pci,chardev=nunchuk,id=i2c \
     -chardev socket,path=${VIRTIOFSD_SOCK},id=vfsd \
     -device vhost-user-fs-pci,queue-size=1024,chardev=vfsd,tag=host0 \
     -object memory-backend-file,id=mem0,mem-path=${MEM_FILE},size=2048M,share=on \
     -numa node,memdev=mem0
