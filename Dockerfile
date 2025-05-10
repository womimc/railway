FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    shellinabox \
    sudo \
    net-tools \
    curl \
    && apt-get clean
EXPOSE 8080
CMD ["shellinaboxd", "--no-beep", "--disable-ssl", "--localhost-only", "--port=8080"]
