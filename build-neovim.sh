#!/bin/bash

# deps
# Ubuntu / Debian build deps
# sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

# CentOS/RHEL/Fedora
# sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl

# Arch Linux
# sudo pacman -S base-devel cmake unzip ninja tree-sitter curl

# install type options
# build from remote
# build from local repo
# build stable, release, @version

# take input for install type
# install_type=$1
# TODO: ADD OPTION FOR CUSTOM PATH FOR LOCAL REPO
set -e

_print_header() {
	cat <<'EOF'
 _           _ _     _              _           
| |__  _   _(_) | __| |  _ ____   _(_)_ __ ___  
| '_ \| | | | | |/ _` | | '_ \ \ / / | '_ ` _ \ 
| |_) | |_| | | | (_| | | | | \ V /| | | | | | |
|_.__/ \__,_|_|_|\__,_| |_| |_|\_/ |_|_| |_| |_|
                                                
EOF
}

# install build dependencies
_install_build_deps() {
	echo "installing build dependencies.."
	os_type=$(uname -s)
	case "$os_type" in
	Linux)
		if [[ -f "/etc/fedora-release" || -f "/etc/redhat-release" ]]; then
			echo "installing build dependencies with dnf.."
			sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make \
				pkgconfig unzip patch gettext curl
		elif [[ -f "/etc/arch-release" ]]; then
			echo "i use arch btw.."
			sudo pacman -Sy base-devel cmake unzip ninja tree-sitter curl
		else
			echo "installing build dependencies with apt-get"
			sudo apt-get -y install ninja-build \
				gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
		fi
		;;
	*)
		echo "we no dey support your os some"
		exit 1
		;;
	esac
}

# make command to build release version of nvim
_make_release() {
	sudo make install CMAKE_BUILD_TYPE=Release
}

# make command to build nightly version of nvim
_make_nightly() {
	sudo make install CMAKE_BUILD_TYPE=Debug
}

_cleanup() {
	cd .. && sudo rm -rf neovim/
}

_usage() {
	echo "Usage: build-neovim.sh [<options>]"
	echo ""
	echo "Options:"
	echo "    -h                     Print this help message"
	echo "    -i                     Install build dependencies"
	echo "    -p <path_to_dir>       Specify a custom path to repo"
	echo "                              default: $HOME/neovim"
	echo "    -s                     Build stable release of neovim"
	echo "    -d                     Build nightly release of neovim"
	echo "    -r <release_number>    Build a specific release of neovim ie. x.x.x"
	exit 0
}

_prep() {
	echo "preparing to build neovim.."
	install_dir=$(basename "$(mktemp -d)")

	echo "changing directory to /tmp/$install_dir.."
	cd /tmp/$install_dir || return
	_get_nvim_repo "$1"
}

decalre LOCAL_REPO_PATH

_get_nvim_repo() {
	echo "getting nvim repo.."

	path=${LOCAL_REPO_PATH:-"$HOME/neovim"}

	echo path: $path

	if [[ -d $path ]]; then
		echo "found existing repo at $path.."
		echo "copying files.."
		cp -r $path /tmp/$install_dir
		echo "getting latest commits.."
		cd "$(basename $path)" && git pull || return
	else
		echo 'cloning nvim repo..'
		# git clone 'https://github.com/neovim/neovim'
		[[ $? -ne 0 ]] && echo 'failed to clone nvim repo..' && exit 1
		cd neovim || return
	fi
}

_validate_path_provided() {
	echo "validating path.."
	[[ -d $1 ]] && cd $1 || (echo "path does not exist" && return 1)
	if [[ $(git remote -v | awk '{print $2}' | head -1) == "https://github.com/neovim/neovim" ]]; then
		echo "all good"
		LOCAL_REPO_PATH=$1
		cd - &>/dev/null && return 0
	else
		echo "not a valid repo"
		cd - &>/dev/null && return 1
	fi

}

_build_stable() {
	echo "building stable release of neovim.."
	git checkout stable && _make_release
	echo "you are on the stable release of neovim!"
}

_build_dev() {
	echo "building nightly release of neovim.."
	git checkout master && _make_nightly
	echo "you are on nightly release of neovim!"
}

_build_at_version() {
	echo "building at specific version of neovim.."
	git checkout $1 && _make_release
	echo "you are on neovim release version $1"
}

main() {

	print_header

	[[ $# -eq 0 ]] && _usage
	[[ $# -gt 2 ]] && echo hey

	while getopts ":hdsr:ip:" opt; do
		case $opt in
		h)
			_usage
			;;
		p)
			_validate_path_provided $OPTARG
			;;
		i)
			_install_build_deps
			;;
		d)
			echo "installing nightly release of neovim.."
			_prep "$@"
			_build_dev
			# _cleanup
			;;
		s)
			echo "installing stable release of neovim.."
			_prep "$@"
			_build_stable
			# _cleanup
			;;
		r)
			echo "installing a specific version of neovim.."
			[[ $OPTARG != [0-9]\.[0-9]\.[0-9] ]] && echo 'version must be in format x.x.x' && exit 1
			_prep "$@"
			_build_at_version "v$OPTARG"
			# _cleanup
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			_usage
			;;
		esac
	done
}

main "$@"
