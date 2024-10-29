#!/bin/bash

set -e
sudo -v || exit
apt_repositories=(
	ppa:neovim-ppa/stable
	universe
)

apt_packages=(
	git
	htop
	curl
	neovim
	build-essential
	software-properties-common
	ca-certificates
	gcc
	g++
	gcc-14
	g++-14
	clang
	clang-18
	llvm-18
	python3-pip
	python3-dev
	python3-virtualenv
	qt6-base-dev
	
	# Python compile dependencies
	libssl-dev
	zlib1g-dev
	libbz2-dev
	libreadline-dev
	libsqlite3-dev
	libncursesw5-dev 
	xz-utils 
	tk-dev 
	libxml2-dev 
	libxmlsec1-dev 
	libffi-dev 
	liblzma-dev

	# Gogh requirements
	# https://github.com/Gogh-Co/Gogh
	dconf-cli
	uuid-runtime
)

snap-packages=(
	libreoffice
)

snap-packages-classic=(
	code
	cmake
)

##
## Nerd Fonts
##
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraMono.zip
cd ~/.local/share/fonts
unzip FiraCode.zip
unzip FiraMono.zip
rm FiraCode.zip FiraMono.zip LICENSE README.md

fc-cache -fv

## End nerdfonts


##
## Docker Setup
##

# Add Docker's official GPG key:
sudo apt-get update
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

## End Docker setup

##
## Gogh theme setup
##
# Clone the repo into "$HOME/src/gogh"
mkdir -p "$HOME/src"
cd "$HOME/src"
git clone https://github.com/Gogh-Co/Gogh.git gogh
cd gogh

# necessary in the Gnome terminal on ubuntu
export TERMINAL=gnome-terminal

# Enter theme installs dir
cd installs
./gruvbox-dark.sh
## End Gogh theme setup

## 
## Rust
##
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
## End Rust setup

##
## Pyenv installer
##
curl https://pyenv.run | sh --  

## End Pyenv install

##
## ROS
## 
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update 
sudo apt install ros-dev-tools ros-jazzy-desktop
## End ROS install 

##
## Spaceship prompts
#
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

