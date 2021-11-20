#!/usr/bin/bash

echo 'Looking for codiums deb file...'
# check if codium*.deb file exits
codium_deb=$(find ~/Downloads/Programs/ -name 'codium*')

if [[ -f $codium_deb ]]; then

  # install debian package
  sudo dpkg -i "$codium_deb" 

  # remove .deb file
  rm "$codium_deb"

  exit 0

else
  echo 'No codium deb file found..'
fi

# find the VsCodium tart file
codium_tar=$(find ~/Downloads/Compressed/ -name 'VSCodium*')

echo 'Looking for codiums tar file...'

if [[ -f $codium_tar  ]]; then

  # unzip the tar ball and copy contents to /usr/share/codium/
  sudo tar -xf "$codium_tar" --directory=/usr/share/codium

  # display success messaege
  echo 'Successfully updated VSCodium'

  echo 'Deleting VSCodium tar archive...'

  # remove tar ball
  rm "$codium_tar"

  echo 'Done!!'

  exit 0
  # if archive is not found echo message and exit
else
  echo 'VSCodium tar archive not found..'
  exit 1

fi
