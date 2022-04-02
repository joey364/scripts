#!/bin/bash

adb_location=$(which adb)
adb devices

# TODO: check from output to see if no permissions was returned

sudo chown root:joel $adb_location

sudo chmod 4550 $adb_location

echo "Killing adb server.."
sudo adb kill-server

echo "Starting adb server.."
sudo adb start-server

# TODO: confirm permissions restored

adb devices
