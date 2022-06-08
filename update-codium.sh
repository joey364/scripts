#!/usr/bin/bash

echo 'Looking for codiums deb file...'
# check if codium*.deb file exits
codium_bin=$(find ~/Downloads/Programs/ -name 'codium*')
codium_deb=$(find ~/Downloads/Programs/ -name 'codium*.deb')

if [[ -f $codium_bin || -f $codium_deb ]]; then
	echo 'found codium binary'

	if [[ -f '/etc/fedora-release' ]]; then
		echo 'found fedora'
		sudo dnf install -y $codium_bin
	elif [[ -f '/etc/arch-release' ]]; then
		echo 'found arch'
		sudo pacman -S --noconfirm $codium_bin
	elif [[ -f '/etc/debian_version' ]]; then
		echo 'found debian'
		sudo dpkg -i $codium_deb
	else
		echo 'unknown distro'
	fi

	# install debian package
	# sudo dpkg -i "$codium_bin"

	# remove .deb file
	# rm "$codium_bin"
	echo '🎊 done updating VSCodium'

	exit 0

else
	echo 'No codium binary found..'
fi

# find the VsCodium tart file
codium_tar=$(find ~/Downloads/Compressed/ -name 'VSCodium*')

echo 'Looking for codiums tar file...'

if [[ -f $codium_tar ]]; then

	echo 'found codium tar archive'

	# unzip the tar ball and copy contents to /usr/share/codium/
	sudo tar -xf "$codium_tar" --directory=/usr/share/codium

	# display success messaege
	echo 'Successfully updated VSCodium'

	echo 'Deleting VSCodium tar archive...'

	# remove tar ball
	rm "$codium_tar"

	echo '🎊 done updating VSCodium'

	exit 0
	# if archive is not found echo message and exit
else
	echo 'VSCodium tar archive not found..'
	exit 1

fi
