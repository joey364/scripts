#!/bin/bash

dir="$HOME/Downloads"
files=$(fd --full-path $dir --extension ts)
# ffmpeg -i yourvideoname.ts -c:v libx264 outputfilename.mp4
fd . $dir -e ts -x ffmpeg -i {} -c:v libx264 {}.mp4
# echo $files
