# Building the BeagleBone Image

First, build the development OCI. This image contains the cross compilation
tools necessary to build the kernel and supporting packages for the BeagleBone
platform.

```bash-session
$ buildah bud -t kernel-factory:latest Containerfile
```

Start a container using our new image and run the Makefile with the
`beaglebone` target to build the beaglebone image.

```bash-session
host$ mkdir build && chown 66535 build
host$ podman run -it -v /home/edtwardy/Git/sesg-drivers:/home/kernel kernel-factory:latest
container$ make MACHINE=beaglebone
```
