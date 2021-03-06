#!/bin/bash
cat <<'EOF'
           _     __                     _     
 _ __ ___ | | __/ _|___       _   _ ___| |__  
| '_ ` _ \| |/ / |_/ __|_____| | | / __| '_ \ 
| | | | | |   <|  _\__ \_____| |_| \__ \ |_) |
|_| |_| |_|_|\_\_| |___/      \__,_|___/_.__/ 
                                              
EOF

# find the drive
echo "Filesystem      Mounted on"
df | awk -v OFS='\t' '/\/dev\/s/ {print $1, $6}'

# read mount point of usb
echo ""
echo "Enter the mount point of your usb drive.. e.g. /dev/sdb1"
read mpoint

# unmount the drive
echo $mpoint
if [[ $(findmnt $mpoint) > /dev/null ]]; then
	echo "Mount location found.."
	# unount $mpoint
else
	echo "Enter a valid device location"
	exit 1
fi

# make the new filesystem on the drive
echo ""
echo "Enter the filesystem with which you'd like to format the usb with.."
echo "Options: "
echo "fat:    all operating systems"
echo "exfat:  all operating systems "
echo "ntfs:   windows, linux*, macos* "
echo "ext4:   linux, windows*"
echo "btrfs:  linux only"
echo ""

fs_types=("fat" "exfat" "ntfs" "ext4" "btrfs")
read fs_option

if [[ ${fs_types[*]} =~ ${fs_option} ]]; then
	echo "$fs_option selected"
	# sudo mkfs.$fs_option $mpoint
else
	echo "wrong filesystem type entered"
	exit 1
fi
