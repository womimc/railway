FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y shellinabox openssh-server sudo curl wget git nodejs neofetch npm python3 python3-pip unzip zip tar tmux tmate nano && \
    mkdir /var/run/sshd
RUN useradd -m user && echo "user:1234" | chpasswd && usermod -aG sudo user && chsh -s /bin/bash user
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN mkdir -p /etc/shellinabox && \
    echo "--no-beep --disable-ssl --service=/:LOGIN" > /etc/default/shellinabox
RUN echo "tmate -S /tmp/tmate.sock new-session -d && \\" > /home/user/tmate.sh && echo "tmate -S /tmp/tmate.sock wait tmate-ready && \\" >> /home/user/tmate.sh && echo "echo \"SSH session:     \$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')\" && \\" >> /home/user/tmate.sh && echo "echo \"Read-only SSH:   \$(tmate -S /tmp/tmate.sock display -p '\#{tmate_ssh_ro}')\" && \\" >> /home/user/tmate.sh && echo "echo \"Web session:     \$(tmate -S /tmp/tmate.sock display -p '\#{tmate_web}')\" && \\" >> /home/user/tmate.sh && echo "echo \"Web read-only:   \$(tmate -S /tmp/tmate.sock display -p '\#{tmate_web_ro}')\"" >> /home/user/tmate.sh
EXPOSE 3000
CMD service ssh start && shellinaboxd --port=3000 --disable-ssl --no-beep --service=/:LOGIN
