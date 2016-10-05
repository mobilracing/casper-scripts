#!/bin/sh
####################################################################################################
#
# GitRepo: https://github.com/macmule/Dockutil-Add-App
#
# License: https://macmule.com/license/
#
####################################################################################################

###
# Get the Username of the logged in user
###
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

echo "$loggedInUser..."

# HARDCODED VALUES ARE SET HERE

# Applications Path, specify full path as in: /Applications/Safari.app
appPath1=""
appPath2=""
appPath3=""
appPath4=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "appPath1"
if [ "$4" != "" ] && [ "$appPath" == "" ];then
    appPath1=$4
fi
if [ "$5" != "" ] && [ "$appPath" == "" ];then
    appPath2=$5
fi
if [ "$6" != "" ] && [ "$appPath" == "" ];then
    appPath3=$6
fi
if [ "$7" != "" ] && [ "$appPath" == "" ];then
    appPath4=$7
fi

##
# Error if variable appPath is empty
##
if [ "$appPath1" == "" ]; then
	echo "Error:  No value was specified for the appPath variable..."
	exit 1
fi
if [ "$appPath2" == "" ]; then
	echo "Error:  No value was specified for the appPath variable..."
	exit 1
fi
if [ "$appPath3" == "" ]; then
	echo "Error:  No value was specified for the appPath variable..."
	exit 1
fi
if [ "$appPath4" == "" ]; then
	echo "Error:  No value was specified for the appPath variable..."
	exit 1
fi

###
# Add the App as given at $appPath
###

echo "Will add "$appPath1"..."
sudo -u "$loggedInUser" /usr/local/bin/dockutil --add "$appPath1" --no-restart /Users/"$loggedInUser"
echo "Added "$appPath1" to /Users/"$loggedInUser"..."
sleep 2

echo "Will add "$appPath2"..."
sudo -u "$loggedInUser" /usr/local/bin/dockutil --add "$appPath2" --no-restart /Users/"$loggedInUser"
echo "Added "$appPath2" to /Users/"$loggedInUser"..."
sleep 2

echo "Will add "$appPath3"..."
sudo -u "$loggedInUser" /usr/local/bin/dockutil --add "$appPath3" --no-restart /Users/"$loggedInUser"
echo "Added "$appPath3" to /Users/"$loggedInUser"..."
sleep 2

echo "Will add "$appPath4"..."
sudo -u "$loggedInUser" /usr/local/bin/dockutil --add "$appPath4" --no-restart /Users/"$loggedInUser"
echo "Added "$appPath4" to /Users/"$loggedInUser"..."
sleep 2

sudo killall Dock