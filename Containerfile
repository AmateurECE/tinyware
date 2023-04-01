FROM ubuntu:latest

ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y \
        autoconf \
        bc \
        bison \
        build-essential \
        coccinelle \
        cpio \
        curl \
        device-tree-compiler \
        dfu-util \
        efitools \
        flex \
        g++-arm-linux-gnueabihf \
        g++-x86-64-linux-gnu \
        gawk \
        gdisk \
        git \
        graphviz \
        imagemagick \
        libelf-dev \
        libgnutls28-dev \
        libguestfs-tools \
        liblz4-tool \
        libncurses-dev \
        libpython3-dev \
        libsdl2-dev \
        libssl-dev \
        lz4 \
        lzma \
        lzma-alone \
        openssl \
        pkg-config \
        python3 \
        python3-asteval \
        python3-coverage \
        python3-filelock \
        python3-pkg-resources \
        python3-pycryptodome \
        python3-pyelftools \
        python3-pytest \
        python3-pytest-xdist \
        python3-sphinxcontrib.apidoc \
        python3-sphinx-rtd-theme \
        python3-subunit \
        python3-testtools \
        python3-virtualenv \
        rsync \
        swig \
        uuid-dev
WORKDIR /root
