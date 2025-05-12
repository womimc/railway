FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y wget qemu-system-x86 qemu-utils genisoimage -y
RUN wget -O ubuntu24.img https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img
RUN printf "#cloud-config\nusers:\n  - default\n  - name: ubuntu\n    sudo: ALL=(ALL) NOPASSWD:ALL\n    groups: users, admin\n    shell: /bin/bash\n    plain_text_passwd: 'ubuntu'\n    lock_passwd: false\nchpasswd:\n  expire: false\nssh_pwauth: true\n" > user-data.yaml
RUN genisoimage -output user-data.iso -volid cidata -joliet -rock user-data.yaml
EXPOSE 3000 22
CMD qemu-system-x86_64 -m 2048 -smp 2 -drive file=ubuntu24.img,format=qcow2 -drive file=user-data.iso,format=raw -net nic -net user -nographic
