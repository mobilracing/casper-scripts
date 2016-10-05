#!/bin/bash

######################################################
# 
# Created by Craig Richards
# Updated: 10/05/2016
# Repo: https://github.com/mobilracing/casper-scripts
#
######################################################

# Mount the disk image to prep for installation.
hdiutil attach /Library/Application\ Support/JAMF/Waiting\ Room/bomgar.dmg

# Run the installer.
/Volumes/bomgar-scc/Double-Click\ To\ Start\ Support\ Session.app/Contents/MacOS/sdcust

# Wait for the process to fully finish with some extra time.
sleep 30

# Unmount the disk image.
hdiutil detach /Volumes/bomgar-scc

# Wait for the unmount to complete.
sleep 10

# Delete the disk image from its download location.
rm -R /Library/Application\ Support/JAMF/Waiting\ Room/bomgar.dmg

exit 0