FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y tzdata
ENV TZ=UTC

RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    openssh-server \
    sudo \
    vim \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN npm install wetty

RUN useradd -m -s /bin/bash -G sudo user
RUN echo 'user:1234' | chpasswd

EXPOSE 3000

RUN echo '#!/bin/bash\n\
service ssh start\n\
wetty --port 3000 --host 0.0.0.0\n\
' > /start.sh && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
