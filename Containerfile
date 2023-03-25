FROM ubuntu:latest

RUN apt update && apt install -y \
        gcc-arm-linux-gnueabi \
        g++-arm-linux-gnueabi \
        build-essential \
        curl \
        gawk \
        bison \
        flex \
        bc \
        libssl-dev \
        cpio \
        python3
WORKDIR /root
