FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    qemu-system-x86 \
    wget \
    curl \
    openssh-client \
    shellinabox \
    xz-utils \
    sudo \
    net-tools

WORKDIR /vm

ADD rootfs.qcow2 ./disk.qcow2

COPY start-vm.sh .
RUN chmod +x start-vm.sh

EXPOSE 3000 22

CMD ["bash", "start-vm.sh"]
