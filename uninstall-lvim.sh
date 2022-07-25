#!/bin/bash

echo 'Removing ~/.local/share/lunarvim..'
rm -rf ~/.local/share/lunarvim && echo 'done'

echo 'Removing /usr/local/bin/lvim..'
sudo rm /usr/local/bin/lvim && echo 'done'

echo 'Removing ~/.local/bin/lvim'
rm ~/.local/bin/lvim && echo 'done'

echo 'Removing ~/.local/share/applications/lvim.desktop'
rm -rf ~/.local/share/applications/lvim.desktop
echo 'Done uninstalling Lunarvim..'
