#!/bin/bash

######################################################
# 
# Created by Craig Richards
# Updated: 10/05/2016
# Repo: https://github.com/mobilracing/casper-scripts
#
######################################################

# Check to make sure that the local admin account has been moved to /var/.
if [ -d /var/localadmin ]
then 
	# If localadmin exists in /var/, end script.
	echo "Directory exists."
else
	# Hide the localadmin account.
	dscl . create /Users/localadmin IsHidden 1
	# Move the localadmin home directory and update its user record.
	mv /Users/localadmin /var/localadmin
	dscl . create /Users/localadmin NFSHomeDirectory /var/localadmin
	# Remove the Public Folder share point.
	dscl . -delete "/SharePoints/localadmin's Public Folder"
	#Remove the localadmin account from FileVault 2.
	fdesetup remove -user localadmin
fi