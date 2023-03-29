#!/bin/sh
DEPLOY=build/qemu/deploy
CONSOLE_SOCK=${XDG_RUNTIME_DIR}/qemu-console.sock

qemu-system-x86_64 \
    -cpu qemu64-v1 \
    -m 1024 \
    -kernel ${DEPLOY}/bzImage \
    -initrd ${DEPLOY}/minimal-initramfs.cpio.gz \
    -monitor stdio \
    -chardev socket,id=serial0,path=${CONSOLE_SOCK},server=on \
    -serial chardev:serial0 \
    -nographic \
    -vga none \
    -append 'console=ttyS0,115200n8'
