#!/bin/busybox sh
mount -t sysfs none /sys
mount -t proc none /proc
mount -t devtmpfs none /dev

# Start a shell
setsid cttyhack sh
