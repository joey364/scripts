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

# keep alive
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

# copy dnf.conf to /etc/dnf/dnf.conf
echo "copying dnf.conf /etc/dnf/dnf.conf .."
echo "
[main]
best=False
clean_requirements_on_remove=True
defaultyes=True
fatestmirror=True
gpgcheck=1
installonly_limit=2
max_parallel_downloads=10
skip_if_unavailable=True
" | sudo tee /etc/dnf/dnf.conf

# update the system
sudo dnf update -y

echo "Enabling RPM Fusion free repos.."
sudo dnf install -y \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm

# rpmfusion non-free repos
echo "Enabling RPM Fusion non-free repos.."
sudo dnf install -y \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)."noarch.rpm

# add flathub repo
echo "Adding FlatHub.."
flatpak remote-add -y --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install media codecs
echo "Installing media codecs.."
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
	gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel

sudo dnf install -y lame\* --exclude=lame-devel

sudo dnf group upgrade --with-optional Multimedia

# openh264 codec
echo "Adding openh264 codec.."
# enable it
sudo dnf config-manager --set-enabled fedora-cisco-openh264

# install the plugins
# ppst gstreamer1-plugin-openh264 already installed
sudo dnf install -y mozilla-openh264

# install appStream metadata
echo "Installing appStream metadata.."
sudo dnf groupupdate core -y

# post multimedia install
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

sudo dnf groupupdate sound-and-video

echo
echo "all done have a nice day 😄"
