FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl gnupg2 ca-certificates
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs openssh-server sudo && \
    mkdir /run/sshd
RUN useradd -m webuser && \
    echo 'webuser:webpass' | chpasswd && \
    echo 'webuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN npm install -g wetty
EXPOSE 3000
CMD service ssh start && wetty --ssh-host=localhost --ssh-user=webuser --port=3000
