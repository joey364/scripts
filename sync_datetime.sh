#!/usr/bin/env bash

is_connected=$(nmcli general status | grep '^connected' >/dev/null && echo "yay")

spinner_options=("dot" "line" "minidot" "jump" "pulse" "points" "globe" "moon" "monkey" "meter" "hamburger")

# select random index from from the spinner_options array
rand_idx=$(shuf -i 0-$((${#spinner_options[@]} - 1)) -n 1)

if [[ $is_connected = 'yay' ]]; then
	echo connected
	gum spin --spinner="${spinner_options[rand_idx]}" --show-output --title="syncing datetime" -- sudo htpdate -s google.com
	# sudo htpdate -s google.com
else
	echo not connected to the internet
	echo please get connected
	exit 1
fi
