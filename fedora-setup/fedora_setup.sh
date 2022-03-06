#!/bin/bash

cat <<'EOF'
  __          _                            _               
 / _| ___  __| | ___  _ __ __ _   ___  ___| |_ _   _ _ __  
| |_ / _ \/ _` |/ _ \| '__/ _` | / __|/ _ \ __| | | | '_ \ 
|  _|  __/ (_| | (_) | | | (_| | \__ \  __/ |_| |_| | |_) |
|_|  \___|\__,_|\___/|_|  \__,_| |___/\___|\__|\__,_| .__/ 
                                                    |_|    
EOF

# enable RPM Fusion free and non-free repos
# RPM Fusion free repos
echo "Sudo access required.."
sudo -v

# update the system
sudo dnf update -y

# copy dnf.conf to /etc/dnf/dnf.conf
echo "moving dnf.conf /etc/dnf/dnf.conf .."
# TODO: potential issue here (check cwd)
sudo mv ./dnf.conf /etc/dnf/dnf.conf

echo "Enabling RPM Fusion free repos.."
dnf install \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm

# rpmfusion non-free repos
echo "Enabling RPM Fusion non-free repos.."
dnf install \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)."noarch.rpm

# add flathub repo
echo "Adding FlatHub repo.."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install media codecs
echo "Installing media codecs"
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} \
	gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel

dnf install lame\* --exclude=lame-devel

dnf group upgrade --with-optional Multimedia

# openh264 codec
echo "Adding openh264 codec.."
# enable it
dnf config-manager --set-enabled fedora-cisco-openh264

# install the plugins
# ppst gstreamer1-plugin-openh264 already installed
dnf install mozilla-openh264

echo
echo "all done have a nice day 😄"
