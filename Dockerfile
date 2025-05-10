FROM --platform=linux/amd64 node:18-slim
RUN apt-get update && apt-get install -y \
    openssh-client \
    openssh-server \
    && mkdir /run/sshd
RUN npm install -g wetty
RUN useradd -ms /bin/bash user && echo "user:user" | chpasswd
EXPOSE 3000
CMD service ssh start && wetty --ssh-host=localhost --ssh-user=user --port=3000
