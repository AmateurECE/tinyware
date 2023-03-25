FROM fedora:latest

RUN dnf install -y gcc-arm-linux-gnu
RUN useradd -m kernel

USER kernel
WORKDIR /home/kernel
