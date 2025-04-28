#!/bin/bash

/usr/sbin/sshd

# Installing ohmyzsh
if ! [ -f "/root/.zshrc" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# Installing Distro if set.
if [ -n "$NVIM_DISTRO" ]; then
  NVIM_DISTRO="${NVIM_DISTRO,,}"
  if [ ! -d "/root/.config/nvim" ] && [ ! -d "/root/.config/lvim" ]; then
    if [ "$NVIM_DISTRO" == "lazyvim" ]; then
      git clone https://github.com/LazyVim/starter /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$NVIM_DISTRO" == "astronvim" ]; then
      git clone --depth 1 https://github.com/AstroNvim/template /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$NVIM_DISTRO" == "nvchad" ]; then
      git clone https://github.com/NvChad/starter /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$NVIM_DISTRO" == "lunarvim" ]; then
      bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    elif [ "$NVIM_DISTRO" == "spacevim" ]; then
      # Throws font errors, do we really need?
      curl -sLf https://spacevim.org/install.sh | bash
    elif [ "$NVIM_DISTRO" == "kickstart" ]; then
      git clone https://github.com/nvim-lua/kickstart.nvim.git /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$NVIM_DISTRO" == "normalnvim" ]; then
      git clone https://github.com/NormalNvim/NormalNvim.git /root/.config/nvim
    fi
  fi
fi
if [ "$NVIM_DISTRO" == "lunarvim" ]; then
  lvim
else
  nvim
fi
