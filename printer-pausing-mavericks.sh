#!/bin/bash

######################################################
# 
# Created by Craig Richards
# Updated: 10/05/2016
# Repo: https://github.com/mobilracing/casper-scripts
#
######################################################

# This allows users to print to SMB printers without it pausing.
/usr/bin/security authorizationdb write system.print.operator allow

exit 0