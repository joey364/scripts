#!/usr/bin/env bash

is_connected=$(nmcli general status | grep '^connected' >/dev/null && echo "yay")

if [[ $is_connected = 'yay' ]]; then
	echo connected
	# gum spin --spinner="meter" --title="syncing datetime" -- sudo htpdate -s google.com
	sudo htpdate -s google.com
else
	echo not connected to the internet
	echo please get connected
	exit 1
fi
