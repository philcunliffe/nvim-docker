FROM alpine:latest

ENV PATH="${PATH}:/root/.local/bin"

# install all tooling in one go, no cache
RUN apk add --no-cache \
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
    py3-pip \
    pkgconfig \
    build-base \
    go \
    nodejs \
    npm \
    ruby \
    yarn \
    cargo \
    python3 \
    zsh \
    ttyd \
    openssh

# download custom ttyd binary, set perms, create /edit
RUN wget -q -O /usr/sbin/ttyd.nerd \
      https://github.com/Lanjelin/nerd-ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x /usr/sbin/ttyd.nerd \
    && mkdir -p /edit

# generate SSH host keys and ensure sshd runtime dir exists
RUN ssh-keygen -A \
    && mkdir -p /var/run/sshd

RUN if [ ! -d "/root/.config/nvim" ]; then \
    echo "Cloning nvim-notes repository..." && \
    git clone --depth 1 "https://github.com/philcunliffe/nvim-notes.git" /root/.config/nvim; \
  else \
    echo "/root/.config/nvim already exists, skipping clone."; \
  fi

COPY entrypoint.sh .

VOLUME /root /notes
WORKDIR /notes

EXPOSE 7681 22

CMD ["/usr/sbin/sshd", "-D", "-e"]

