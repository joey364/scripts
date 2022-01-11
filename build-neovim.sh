#!/bin/bash

# deps
# Ubuntu / Debian build deps
# sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# CentOS/RHEL/Fedora
# sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl

# Arch Linux
# sudo pacman -S base-devel cmake unzip ninja tree-sitter curl

# take input for install type
install_type=$1

# install build dependencies
install_build_deps() {
	echo "Installing build dependencies.."
	os_type=$(uname -s)
	case "$os_type" in
	Linux)
		echo "linux you dey top"
		if [[ -f "/etc/fedora-release" || -f "/etc/redhat-release" ]]; then
			echo "red hat you dey top"
			sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl
		elif [[ -f "/etc/arch-release" ]]; then
			echo "i use arch btw.."
			sudo pacman -S base-devel cmake unzip ninja tree-sitter curl
		else
			echo "debian this"
			sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
		fi
		;;
	*)
		echo "we no dey support your os some"
		exit 1
		;;
	esac
}

# make command to build release version of nvim
make_release() {
	sudo make install CMAKE_BUILD_TYPE=Release
}

# make command to build nightly version of nvim
make_nightly() {
	sudo make install CMAKE_BUILD_TYPE=Debug
}

# clone neovim repo and build
install_with_clone() {
	if [[ $1 == 'stable' ]]; then
		echo "Installing stable release of neovim"
		git clone --branch stable --single-branch https://github.com/neovim/neovim
		cd neovim && make_release
	elif [[ $! == 'dev' ]]; then
		echo "Installing nightly release of neovim"
		git clone https://github.com/neovim/neovim --depth=1
		cd neovim && make_nightly
	else
		echo 'Pass stable or dev to script and try again..'
		echo 'e.g. ./build-neovim.sh dev'
		exit 0
	fi
}

# use already existing repo
install_without_clone() {
	sudo cp -r "$HOME/neovim" .
	cd neovim && git pull
	if [[ $1 == 'stable' ]]; then
		git checkout stable && make_release
	elif [[ $1 == 'dev' ]]; then
		git checkout master && make_nightly
	else
		echo 'Pass stable or dev to script and try again..'
		echo 'e.g. ./build-neovim.sh dev'
		exit 0
	fi
}

# create a temp directory and move into it
cd "$(mktemp -d)" || return

install_build_deps

# check for nvim repo locally
if [[ -d "$HOME/neovim" ]]; then
	echo "nvim repo already here"
	install_without_clone $install_type
else
	echo "nvim repo not here"
	install_with_clone $install_type
fi

cd .. && sudo rm -rf neovim/
