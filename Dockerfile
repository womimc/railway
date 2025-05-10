FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y tzdata
ENV TZ=UTC

RUN apt-get update && apt-get install -y \
    curl \
    git \
    openssh-server \
    sudo \
    vim \
    wget \
    ca-certificates \
    gnupg \
    && apt-get clean

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs && apt-get clean

RUN node -v && npm -v

RUN mkdir -p /var/run/sshd
RUN echo 'root:2ws3ed' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN npm install -g wetty

RUN useradd -m -s /bin/bash -G sudo user
RUN echo 'user:2ws3ed' | chpasswd

EXPOSE 3000

RUN echo '#!/bin/bash\n\
service ssh start\n\
wetty --port 3000 --host 0.0.0.0\n\
' > /start.sh && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
