#!/bin/bash

# pre-check for gresource package
# Debian
# apt-get install libglib2.0-0-dbg
# Arch Linux
# pacman -S glib2
# Fedora
# dnf install glib2-devel

tmp_dir=$(mktemp -d)

# check dependencies
check_dependencies() {
	if [ "$(cammand -v gresource)" ]; then
		echo "gresource installed.."
	elif [ -f "/etc/arch-release" ]; then
		echo "instaliing gresource with pacman.."
		pacman -S glib2
	elif [ -f "/etc/fedora-release" ]; then
		echo "instaliing gresource with dnf.."
		dnf install glib2-devel
	else
		echo "instaliing gresource with apt.."
		apt-get install libglib2.0-bin
	fi
}

# extract current shell theme to working directory

# create a shell theme gresource files

# copty prefered image to working directory

# edit gresource file to include new image

# edit gnome-shell-theme.css

# change background from solid color to image

# compile the new gnome shell gresource file

# copy output binary to /usr/share/gnome-shell/

# restart gdm.servie for changes to take effect

# misc
print_banner(){
cat<<'EOF'
      _                                        _           
  ___| |__   __ _ _ __   __ _  ___    __ _  __| |_ __ ___  
 / __| '_ \ / _` | '_ \ / _` |/ _ \  / _` |/ _` | '_ ` _ \ 
| (__| | | | (_| | | | | (_| |  __/ | (_| | (_| | | | | | |
 \___|_| |_|\__,_|_| |_|\__, |\___|  \__, |\__,_|_| |_| |_|
                        |___/        |___/                 
 _                _                                   _ 
| |__   __ _  ___| | ____ _ _ __ ___  _   _ _ __   __| |
| '_ \ / _` |/ __| |/ / _` | '__/ _ \| | | | '_ \ / _` |
| |_) | (_| | (__|   < (_| | | | (_) | |_| | | | | (_| |
|_.__/ \__,_|\___|_|\_\__, |_|  \___/ \__,_|_| |_|\__,_|
                      |___/                             
EOF
}
