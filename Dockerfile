FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y shellinabox openssh-server sudo && \
    mkdir /var/run/sshd

RUN useradd -m user && echo "user:2ws3ed" | chpasswd && usermod -aG sudo user

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN mkdir -p /etc/shellinabox && \
    echo "--no-beep --disable-ssl --service=/:LOGIN" > /etc/default/shellinabox
EXPOSE 3000
CMD service ssh start && \
    shellinaboxd --port=3000 --disable-ssl --no-beep --service=/:LOGIN
