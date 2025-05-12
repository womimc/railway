FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y qemu-system-x86 qemu-utils genisoimage wget curl openssh-client

RUN wget -O ubuntu24.img https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img

RUN printf "#cloud-config\n\
users:\n\
  - name: user\n\
    sudo: ALL=(ALL) NOPASSWD:ALL\n\
    groups: users, admin\n\
    shell: /bin/bash\n\
    plain_text_passwd: '1234'\n\
    lock_passwd: false\n\
chpasswd:\n\
  expire: false\n\
ssh_pwauth: true\n\
runcmd:\n\
  - apt update\n\
  - apt install -y tmate curl\n\
  - tmate -S /tmp/tmate.sock new-session -d\n\
  - tmate -S /tmp/tmate.sock wait tmate-ready\n\
  - tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' > /dev/console\n\
  - tmate -S /tmp/tmate.sock display -p '#{tmate_web}' > /dev/console\n" > user-data.yaml

RUN echo "instance-id: iid-local01\nlocal-hostname: ubuntu-vm" > meta-data

RUN genisoimage -output user-data.iso -volid cidata -joliet -rock user-data.yaml meta-data

EXPOSE 22 3000

CMD qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -drive file=ubuntu24.img,format=qcow2 \
    -drive file=user-data.iso,format=raw \
    -net nic -net user \
    -nographic
