#!/bin/bash

/usr/sbin/sshd

# Installing ohmyzsh
if ! [ -f "/root/.zshrc" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# Installing Distro if set.
if [ -n "$NVIM_DISTRO" ]; then
  # Convert NVIM_DISTRO to lowercase for case-insensitive comparison for predefined names
  distro_lower="${NVIM_DISTRO,,}"

  # Check if Neovim config already exists
  if [ ! -d "/root/.config/nvim" ] && [ ! -d "/root/.config/lvim" ]; then
    if [ "$distro_lower" == "lazyvim" ]; then
      echo "Cloning LazyVim starter..."
      git clone https://github.com/LazyVim/starter /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$distro_lower" == "astronvim" ]; then
      echo "Cloning AstroNvim template..."
      git clone --depth 1 https://github.com/AstroNvim/template /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$distro_lower" == "nvchad" ]; then
      echo "Cloning NvChad starter..."
      git clone https://github.com/NvChad/starter /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$distro_lower" == "lunarvim" ]; then
      # LunarVim uses its own installer and directory structure (/root/.config/lvim)
      echo "Running LunarVim installer..."
      # Ensure curl is installed before running this
      bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies
      # Note: LunarVim might install to /root/.config/lvim, adjust checks if needed
    elif [ "$distro_lower" == "spacevim" ]; then
      echo "Running SpaceVim installer..."
      # Ensure curl is installed before running this
      curl -sLf https://spacevim.org/install.sh | bash
    elif [ "$distro_lower" == "kickstart" ]; then
      echo "Cloning kickstart.nvim..."
      git clone https://github.com/nvim-lua/kickstart.nvim.git /root/.config/nvim
      rm -rf /root/.config/nvim/.git
    elif [ "$distro_lower" == "normalnvim" ]; then
      echo "Cloning NormalNvim..."
      git clone https://github.com/NormalNvim/NormalNvim.git /root/.config/nvim
      # Decide if you want to keep .git for NormalNvim or remove it
      # rm -rf /root/.config/nvim/.git
    # **Check if NVIM_DISTRO looks like a git repository URL or path**
    elif [[ "$NVIM_DISTRO" == *"://"* || "$NVIM_DISTRO" == *".git"* || "$NVIM_DISTRO" == *"/"* ]]; then
      echo "Cloning custom repository: $NVIM_DISTRO..."
      # **Clone the repository specified in NVIM_DISTRO**
      git clone "$NVIM_DISTRO" /root/.config/nvim
      # Optionally remove the .git directory for custom repos too
      rm -rf /root/.config/nvim/.git
    else
      echo "Unknown NVIM_DISTRO specified: $NVIM_DISTRO"
    fi
  else
    echo "Neovim configuration directory already exists. Skipping clone."
  fi
fi

if [ "$NVIM_DISTRO" == "lunarvim" ]; then
  lvim
else
  nvim
fi
