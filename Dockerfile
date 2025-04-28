FROM archlinux:base

ENV PATH="${PATH}:/root/.local/bin"

RUN \
  pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
    fd \
    gcc \
    fzf \
    git \
    make \
    curl \
    wget \
    bash \
    gzip \
    unzip \
    neovim \
    ripgrep \
    lazygit \
    python-pip \
    pkg-config \
    base-devel \
    go \
    npm \
    ruby \
    yarn \
    cargo \
    python3 \
    zsh \
    ttyd \
    openssh && \
  pacman -Scc --noconfirm && \
  wget -q -O /usr/sbin/ttyd.nerd https://github.com/Lanjelin/nerd-ttyd/releases/download/1.7.7/ttyd.x86_64 && \
  chmod +x /usr/sbin/ttyd.nerd && \
  mkdir -p /edit

RUN ssh-keygen -A
RUN mkdir -p /var/run/sshd

COPY entrypoint.sh .

VOLUME /root
WORKDIR /root

EXPOSE 7681 22
CMD ["/bin/bash", "/entrypoint.sh"]
