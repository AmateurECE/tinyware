# TinyWare

TinyWare is a minimalistic Linux "distribution" mostly used for testing
kernels. It runs entirely out of initramfs and boots to the BusyBox shell
without a login prompt. It has no networking or display capability. Currently,
the only supported platforms are the BeagleBone Black and QEMU x86_64 virtual
machines.

The BeagleBone image exposes a USB Mass Storage endpoint for sharing files
between a development machine and the target, and the QEMU build accomplishes
the same using `virtfs`.

# Building an Image

Building is supported on both x86_64 and aarch64 hosts.

First, build the development OCI. This image contains the cross compilation
tools necessary to build the kernel and supporting packages for the BeagleBone
platform.

```bash-session
$ buildah bud -t kernel-factory:latest Containerfile
```

Start a container using our new image and invoke the Makefile with the target
platform.

```bash-session
host$ podman run -it --rm -v $PWD:/root kernel-factory:latest
container$ make MACHINE=<machine>
```

`<machine>` must be one of the supported platforms: `{boneblack,qemu}`

# Running Under QEMU

The `runqemu.sh` script is provided for convenience. This script forwards the
console on the target to the serial port `/dev/ttyS0`, which is backed by a
UNIX socket on the host. To connect to this serial port on the host, configure
`minicom(1)` or your serial terminal of choice to use the UNIX socket at
`${XDG_RUNTIME_DIR}/qemu-console.sock`.
