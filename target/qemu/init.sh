#!/bin/sh
# Have to mount this here
mount -t virtiofs host0 /lib/modules
mount -t devtmpfs none /dev
mount -t sysfs none /sys
mount -t proc none /proc

# Start a shell
setsid cttyhack sh
