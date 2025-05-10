FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    sudo \
    net-tools \
    bash \
    && wget -O /usr/local/bin/gotty https://github.com/yudai/gotty/releases/download/v0.1.4/gotty_linux_amd64 \
    && chmod +x /usr/local/bin/gotty
EXPOSE 8080
CMD ["gotty", "--port", "8080", "--permit-write", "/bin/bash"]
