#!/bin/bash

######################################################
# 
# Created by Craig Richards
# Updated: 10/05/2016
# Repo: https://github.com/mobilracing/casper-scripts
#
######################################################

# Adds Everyone to the lpadmin group so they can change/create printers without being an admin.
/usr/sbin/dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin

exit 0