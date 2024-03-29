#!/bin/bash

# pre-check for gresource package
# Debian
# apt-get install libglib2.0-0-dbg
# Arch Linux
# pacman -S glib2
# Fedora
# dnf install glib2-devel
set -e

declare WORKDIR=''
declare GRSRC_DIR='/usr/share/gnome-shell'
declare THEME_DIR=''

# setup
setup() {
	WORKDIR=$(mktemp -d)
	THEME_DIR="$WORKDIR/shell-theme/theme"
}

# check dependencies
check_dependencies() {
	if [ "$(command -v gresource)" ]; then
		echo "gresource installed.."
	elif [ -f "/etc/arch-release" ]; then
		echo "instaliing gresource with pacman.."
		sudo pacman -Sy glib2
	elif [ -f "/etc/fedora-release" ]; then
		echo "instaliing gresource with dnf.."
		sudo dnf -y install glib2-devel
	else
		echo "instaliing gresource with apt.."
		sudo apt-get install -y libglib2.0-bin
	fi
}

# extract current shell theme to working directory
extract_gdm_theme() {
	echo "Extracting gst theme"
	gst=/usr/share/gnome-shell/gnome-shell-theme.gresource
	# workdir=${HOME}/shell-theme
	workdir=$WORKDIR/shell-theme

	for r in $(gresource list $gst); do
		r=${r#\/org\/gnome\/shell/}
		if [ ! -d "$workdir/""${r%/*}" ]; then
			mkdir -p "$workdir/${r%/*}"
		fi
	done

	for r in $(gresource list $gst); do
		gresource extract "$gst" "$r" >"$workdir"/"${r#\/org\/gnome\/shell/}"
	done

}

# create backup of current gresource file
create_backup() {
	echo "Creating backup of current gresource file"
	sudo cp $GRSRC_DIR/gnome-shell-theme.gresource $GRSRC_DIR/gnome-shell-theme.gresource.bak
}

# create a shell theme gresource files
create_gresource_xml() {
	# find $THEME_DIR -type f -print >$THEME_DIR/filenames.txt
	# body=$(sed 's,^\./,     <file>,g; s,$,</file>,g' $THEME_DIR/filenames.txt)
	extractedFiles=$(find "$THEME_DIR" -type f -printf "%P\n" | xargs -i echo "<file>{}</file>")

	cat <<EOF >"$THEME_DIR/gnome-shell-theme.gresource.xml"
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
    $extractedFiles
  </gresource>
</gresources>
EOF
}

# copy prefered image to working directory
get_image_location() {
	# image_path=$(zenity --file-selection)
	echo "select an image"
	image_path=$(zenity --file-selection --title="Select image" --filename="$HOME/Pictures/")
	! is_image "$image_path" && (echo 'file selected not an image' && exit 1)
	cp "$image_path" "$THEME_DIR"
}

is_image() {
	if eval file --mime-type -b "$1" | grep -qE 'image|bitmap'; then
		return 0
	else
		return 1
	fi
}

# edit gresource file to include new image

# edit gnome-shell-theme.css
edit_gnome_css() {
	echo "editing gnome-shell.css.."
	replacement='#lockDialogGroup { background-image: url('"$(basename "$image_path")"'); background-size: center center; background-repeat: no-repeat; }'

	sed -i -z -E 's,#lockDialogGroup\s*\{[^}]+\},'"$replacement"',g' "$THEME_DIR/gnome-shell.css"
}

# change background from solid color to image

# compile the new gnome shell gresource file
compile_gresource() {
	echo "compiling gresource.."
	glib-compile-resources --sourcedir="$THEME_DIR" "$THEME_DIR/gnome-shell-theme.gresource.xml"
}

# copy output binary to /usr/share/gnome-shell/
move_gresource() {
	echo "copying gresource file to $GRSRC_DIR.."
	sudo mv "$THEME_DIR/gnome-shell-theme.gresource" $GRSRC_DIR/
}

# restart gdm.servie for changes to take effect
restart_gdm() {
	echo "log out of current session for changes to take effect"
	echo "or reboot if you prefer"
}

# reset
reset() {
	[ -f $GRSRC_DIR/gnome-shell-theme.gresource.bak ] &&
		sudo cp $GRSRC_DIR/gnome-shell-theme.gresource.bak \
			$GRSRC_DIR/gnome-shell-theme.gresource
	echo "restored backup"
	echo "restart gdm to apply changes"
	exit
}

# immediately apply changes
apply_changes() {
	echo "logging out of current session"
	gnome-session-quit
}

# misc
print_banner() {
	cat <<'EOF'
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

main() {
	print_banner

	echo "sudo access required"
	sudo -v

	[[ $1 == '-reset' ]] && reset

	check_dependencies

	setup

	create_backup

	extract_gdm_theme

	get_image_location

	create_gresource_xml

	edit_gnome_css

	compile_gresource

	move_gresource

	restart_gdm

}

main "$@"
