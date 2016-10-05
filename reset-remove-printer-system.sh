#!/bin/bash

######################################################
# 
# Created by Craig Richards
# Updated: 10/05/2016
# Repo: https://github.com/mobilracing/casper-scripts
#
######################################################

# Stop the CUPS process.
launchctl stop org.cups.cupsd

# Backup the printer plist.
if [ -e "/Library/Printers/InstalledPrinters.plist" ]
    then
    mv /Library/Printers/InstalledPrinters.plist /Library/Printers/InstalledPrinters.plist.bak
fi

# Backup the CUPS configuration file.
if [ -e "/etc/cups/cupsd.conf" ]
    then
    mv /etc/cups/cupsd.conf /etc/cups/cupsd.conf.bak
fi

# Restore the default CUPS configuration file.
if [ ! -e "/etc/cups/cupsd.conf" ]
    then
    cp /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf
fi

# Backup the printer configuration file.
if [ -e "/etc/cups/printers.conf" ]
    then
    mv /etc/cups/printers.conf /etc/cups/printers.conf.bak
fi

# Start the CUPS process.
launchctl start org.cups.cupsd

# Remove all printers.
lpstat -p | cut -d' ' -f2 | xargs -I{} lpadmin -x {}

exit 0