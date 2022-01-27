#!/bin/bash

adb_location=$(which adb)
adb devices

# TODO: check from output to see if no permissions was returned

sudo chown root:joel $adb_location

sudo chmod 4550 $adb_location

sudo adb kill-server

sudo adb start-server

# TODO: confirm permissions restored
