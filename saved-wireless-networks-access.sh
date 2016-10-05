#!/bin/bash

######################################################
# 
# Created by Craig Richards
# Updated: 10/05/2016
# Repo: https://github.com/mobilracing/casper-scripts
#
######################################################

# If managing the wireless settings, this allows the user access to the saved wireless networks in System Preferences.
security authorizationdb write system.preferences.network allow
security authorizationdb write system.services.systemconfiguration.network allow

exit 0