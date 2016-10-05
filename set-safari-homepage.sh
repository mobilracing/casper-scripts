#!/bin/sh

######################################################
# 
# Created by Craig Richards
# Updated: 10/05/2016
# Repo: https://github.com/mobilracing/casper-scripts
#
######################################################


HOMEPAGE="http://www.homepage.com"

# Set the users homepage for Safari.
# User template
if [ -z "$HOMEPAGE" ]
then
echo "No homepage value set"
else
for USER_TEMPLATE in "/System/Library/User Template"/*
	do
	/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.Safari.plist HomePage -string "$HOMEPAGE"
done

# Existing users
killall cfprefsd
for USER_HOME in /Users/*
	do
		USER_UID=`basename "${USER_HOME}"`
		if [ ! "${USER_UID}" = "Shared" ] 
		then 
			if [ ! -d "${USER_HOME}"/Library/Preferences ]
			then
			mkdir -p "${USER_HOME}"/Library/Preferences
			chown "${USER_UID}" "${USER_HOME}"/Library
			chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
			fi
			if [ -d "${USER_HOME}"/Library/Preferences ]
			then
				echo "Working on home folder preference file: ${USER_HOME}/Library/Preferences/com.apple.Safari.plist"
				mv "${USER_HOME}"/Library/Preferences/com.apple.Safari.plist "${USER_HOME}"/Library/Preferences/com.apple.Safari.plist_bak
				/usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.Safari.plist HomePage -string "$HOMEPAGE"
    			chown $USER_UID "${USER_HOME}"/Library/Preferences/com.apple.Safari.plist
			fi
		fi
	done
fi