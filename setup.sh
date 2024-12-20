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
	zsh
	tmux
	build-essential
	software-properties-common
	ca-certificates
	gpg
	wget
	gcc
	g++
	gcc-14
	g++-14
	clang
	clang-18
	llvm-18
	openssh-server
	openssl
	python3-pip
	python3-dev
	python3-virtualenv
	qt6-base-dev
	ripgrep

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

snap_packages=(
	libreoffice
	inkscape
	gimp
)


is_dpkg_installed() {
	dpkg -l | grep -q "^ii $1\s"
}

is_snap_installed() {
	snap -l | grep -q "^$1\s"
}

package_installer() {
	installer_cmd="$1"
	is_installed_function="$2"
	shift 2
	packages="$@"
	for package in "$packages[@]}"; do
		if $is_installed_function "$package"; then
			echo "$package is already installed"
		else
			sudo "$installer_cmd" "$package"
		fi
	done
}

for package in "${apt_packages[@]}"; do
	if is_installed "$package"; then
		echo "$package is already installed"
	else
		sudo apt install -y "$package"
	fi
done

for package in "$snap_packages[@]"; do
	if is_snap_installed "$package"; then
		echo "$package is already isntalled"
	else
		sudo snap install "$package"
	fi
done


for package in "$snap_packages_classic[@]"; do
	if is_snap_installed "$package"; then
		echo "$package is already isntalled"
	else
		sudo snap install "$package" --classic
	fi
done





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
## Oh-my-zsh
##

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## End Oh-my-zsh

##
## Cmake
##

test -f /usr/share/doc/kitware-archive-keyring/copyright ||
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
sudo apt update
test -f /usr/share/doc/kitware-archive-keyring/copyright ||
sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
sudo apt install kitware-archive-keyring



## End Cmake

##
## Regolith
##
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_2-ubuntu-noble-amd64 noble main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
sudo apt update
sudo apt install regolith-desktop regolith-session-flashback regolith-look-gruvbox

## End Regolith

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


##
## Zenoh
##
echo "deb [trusted=yes] https://download.eclipse.org/zenoh/debian-repo/ /" | sudo tee -a /etc/apt/sources.list > /dev/null
sudo apt update
sudo apt install zenoh

## End Zenoh



##
## VSCode
##
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code

## End VScode
