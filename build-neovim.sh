#!/bin/bash

# deps
# Ubuntu / Debian build deps
# sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# CentOS/RHEL/Fedora
# sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl

# Arch Linux
# sudo pacman -S base-devel cmake unzip ninja tree-sitter curl

install_type=$1

cd "$(mktemp -d)" || return

if [[ $install_type == "stable" ]]; then
	git clone --branch stable --single-branch https://github.com/neovim/neovim
elif [[ $install_type == "dev" ]]; then
	git clone https://github.com/neovim/neovim --depth=1
else
	echo 'Pass stable or dev to script and try again..'
	exit 0
fi

cd neovim && sudo make install CMAKE_BUILD_TYPE=Release

cd .. && sudo rm -rf neovim/
