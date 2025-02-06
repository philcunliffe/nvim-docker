<div align="center">
    <img src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-logo-300x87.png">
</div>

<h1 align="center">nvim-docker</h1>

Run [neovim](https://neovim.io/) using docker, directly in your terminal, or in your favourite browser using the included [ttyd](https://github.com/tsl0922/ttyd).  
Image built on [Arch Linux](https://hub.docker.com/_/archlinux), it includes zsh with [oh-my-zsh](https://ohmyz.sh/), and ttyd.  
It also includes a quick way to install one of the top nvim distros at first run.  

Built mainly with UnRaid in mind, works on other systems as well.  
It's an easy and efficient way of running neovim without having to install anything else but docker.  

The image is built to be compatible with (almost) all LSP, DAP, Linters and Formatters, and is therefore relatively large in size.  
A slimmer image tagged `ghcr.io/lanjelin/nvim-docker:slim` can be used for simpler setups.

## Installation

To persist configuration between runs, it's advised to bind the internal path `/root` to either a volume or folder on the host.

### Supported distros

The following distros can be installed at first run by setting the `NVIM_DISTRO` env variable.  
Others can be manually installed and adjusted, no changes will be done if the directory `.config/nvim` is found.  

 - [LazyVim ](https://www.lazyvim.org/)
 - [AstroNvim](https://astronvim.com/)
 - [NvChad](https://nvchad.com/)
 - [LunarVim](https://www.lunarvim.org/)
 - [Spacevim](https://spacevim.org/)
 - [kickstart](https://github.com/nvim-lua/kickstart.nvim)
 - [NormalNvim](https://normalnvim.github.io/)

Open a pull-request or issue if you want another distro added to the list.  

### First Run

The container will install oh-my-zsh on first run, along with specified distro.  
It should be run as following before attempting anything else, to ensure configurations are properly populated.

```bash
docker run -it --rm -v /mnt/user/appdata/nvim-docker:/root -e NVIM_DISTRO="lazyvim" ghcr.io/lanjelin/nvim-docker:latest
```

### CLI Usage

To run nvim-docker with the usual `nvim` command from the terminal, add the following to your `.bashrc` or `.zshrc`  
This will start the container, and mount file/directory under the path `/edit` inside the container.  
Remember to source the updated file after editing eg. `source ~/.zshrc`

```bash
nvim () {
  if [ ! $# -eq 0 ]; then
    [[ -d "$1" ]] || [[ -f "$1" ]] || touch "$1"
    [[ -f "$1" ]] && NWD="$(dirname $1)" || NWD="$(realpath $1)"
    docker run -it --rm --name nvim-docker \
    -w "/edit$NWD" \
    -v "$(realpath $1)":"/edit$(realpath $1)" \
    -v /mnt/user/appdata/nvim-docker:/root \
    ghcr.io/lanjelin/nvim-docker:latest \
    nvim "/edit$(realpath $1)"
  else
    docker run -it --rm --name nvim-docker \
    -w "/root" \
    -v /mnt/user/appdata/nvim-docker:/root \
    ghcr.io/lanjelin/nvim-docker:latest \
    nvim
  fi
}
```

### UnRaid Additional Steps

If you've followed my guide for [ZSH and oh-my-zsh with persistent history](https://github.com/Lanjelin/unraid/tree/main/zsh-omz-persistent#zsh-and-oh-my-zsh-with-persistent-history), and added the above to `.zshrc`, you should be fine at this point.  
If you're still using the default bash, a few more steps are needed to make the config persist.

#### Preferred Way

Download the file containing the function to the array, using [user scripts](https://forums.unraid.net/topic/48286-plugin-ca-user-scripts/) to copy the values to `.bash_profile`

Run the following to download the file containing the function

```bash
wget -O /mnt/user/appdata/nvim-docker/.nvim-docker.rc https://raw.githubusercontent.com/Lanjelin/nvim-docker/main/.nvim-docker.rc
```

Create a new user script, set it to run `At First Array Start Only`, and paste the following.

```bash
cat /mnt/user/appdata/nvim-docker/.nvim-docker.rc >> /root/.bash_profile
```

#### Alternative Way

Download the file containing the function to the USB-drive, editing the go-file to add it to `.bash_profile` at boot.  
This will result in errors if you're to try to run nvim before the array/docker daemon is started.

Run the following to download the file containing the function

```bash
wget -O /boot/config/.nvim-docker.rc https://raw.githubusercontent.com/Lanjelin/nvim-docker/main/.nvim-docker.rc
```

Run the following to update the go-file

```bash
echo "cat /boot/config/.nvim-docker.rc >> /root/.bash_profile" >> /boot/config/go
```

## TTYD Usage

The image also includes ttyd for the option to run nvim (or zsh) directly in your browser.  
Added is a custom [ttyd.nerd](https://github.com/Lanjelin/nerd-ttyd) that adds JetBrains NerdFont, this requires the flag `-t fontFamily="JetBrains"` to be set.  
More options on ttyd can be found [here](https://github.com/tsl0922/ttyd).

### UnRaid

I've included a template to make it a fast process setting this up in UnRaid.  
Simply run the following to download the template, then navigate to your Docker-tab, click Add Container, and find nvim-docker in the Template-dropdown.

```bash
wget -O /boot/config/plugins/dockerMan/templates-user/my-nvim-docker.xml https://raw.githubusercontent.com/Lanjelin/docker-templates/main/lanjelin/nvim-docker.xml
```

### nvim in the browser

To expose only nvim to the browser, the following could be used as an example.

```bash
docker run -d --name nvim-docker \
  -w "/edit" \
  -p 7681:7681 \
  -v /path/to/project:/edit \
  -v /mnt/user/appdata/nvim-docker:/root \
  ghcr.io/lanjelin/nvim-docker:latest \
  ttyd.nerd -W -t fontFamily="JetBrains" nvim "/edit"
```

```yaml
services:
  nvim-docker:
    container_name: nvim-docker
    working_dir: /edit
    ports:
      - 7681:7681
    volumes:
      - /path/to/project:/edit
      - /mnt/user/appdata/nvim-docker:/root
    image: ghcr.io/lanjelin/nvim-docker:latest
    command: ttyd.nerd -W -t fontFamily="JetBrains" nvim "/edit"
```

### ZSH in the browser

If you want full shell access to the container from your browser, change the last line for something like.

```bash
docker run -d --name nvim-docker \
  -w "/edit" \
  -p 8283:7681 \
  -v /path/to/project:/edit \
  -v /mnt/user/appdata/nvim-docker:/root \
  ghcr.io/lanjelin/nvim-docker:latest \
  ttyd.nerd -W -t fontFamily="JetBrains" zsh
```

```yaml
services:
  nvim-docker:
    container_name: nvim-docker
    working_dir: /edit
    ports:
      - 7681:7681
    volumes:
      - /path/to/project:/edit
      - /mnt/user/appdata/nvim-docker:/root
    image: ghcr.io/lanjelin/nvim-docker:latest
    command: ttyd.nerd -W -t fontFamily="JetBrains" zsh
```

## Security

The container is run with root user in order to be able to read/write files/folders it accesses.  
This always includes some risks, and the container should not be exposed to the internet without taking the proper precautions.
