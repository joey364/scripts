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

}

}


}


	fi



}

