#!/bin/sh

######################################################################################################
## Script written by John Chumley (chumley_j@wustl.edu) with code contributions by Matt Dunlop      ##
## (dunlop_m@wustl.edu) from the Pediatric Computing Facility.                                      ##
## Last Modified 4/15/16																			##
##																								    ##
## The Decommision Script is designed to do the following:                                          ##
## 1. Remove Encryption                                                                             ##
## 2. Remove the computer from the Domain                                                           ##
## 3. Delete the computer entry from JSS                                                            ##
## 4. Remove DNS/Search Domains from local system                                                   ##
## 5. Remove Self Service icon from the Dock (dockutil)                                             ##
## 6. Remove JAMF Framework                                                                         ##
## 7. Close Self Service                                                                            ##
######################################################################################################


##Set Variables
password="$4"
UUID=$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Hardware UUID:/ { print $3 }')

## 1. Encryption Removal Section ##
osascript <<EOD

	tell application "Terminal"
		set currentTab to do script ("sudo fdesetup disable;") in window 1
	delay 5
		set currentTab to do script ("$4") in window 1
	delay 5
		set currentTab to do script ("$4") in window 1
	delay 5
		set currentTab to do script ("sudo fdesetup disable;") in window 1
	delay 5
		set currentTab to do script ("$4") in window 1
	delay 5
		set currentTab to do script ("killall Terminal;") in window 1
	delay 5
	end tell

## 2. Remove the computer from the domain ##

set user_name_dialog to display dialog "Enter a domain account name: " default answer "" buttons {"Next"} default button "Next"
set user_name to text returned of user_name_dialog
set user_password_dialog to display dialog "Enter the domain account password. " default answer "" buttons {"Next"} default button "Next" with hidden answer
set user_password to text returned of user_password_dialog

do shell script "dsconfigad -f -r -u " & user_name & " -p " & user_password & "" with administrator privileges

EOD

## 3. delete computer from casper with UUID
curl -k -v -u localadmin:$4* https://mycompany.jss.com:8443/JSSResource/computers/udid/$UUID -X DELETE

## 4. Remove DNS/Search Domains from local system
osascript <<EOD

try
	do shell script "/usr/sbin/networksetup -setdnsservers \"Ethernet\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setdnsservers \"Ethernet 1\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setdnsservers \"Ethernet 2\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setdnsservers \"Thunderbolt Ethernet\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setdnsservers \"Thunderbolt Ethernet 1\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setdnsservers \"Thunderbolt Ethernet 2\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setsearchdomains \"Ethernet\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setsearchdomains \"Ethernet 1\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setsearchdomains \"Ethernet 2\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setsearchdomains \"Thunderbolt Ethernet\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setsearchdomains \"Thunderbolt Ethernet 1\" \"Empty\"" with administrator privileges
end try
try
	do shell script "/usr/sbin/networksetup -setsearchdomains \"Thunderbolt Ethernet 2\" \"Empty\"" with administrator privileges
end try

EOD

## 5. Remove Self Service Icon (dockutil)
/usr/local/bin/dockutil --remove 'Self Service' --allhomes

## 6. Remove JAMF Framework
JAMF removeframework 

## 7. Close Self Service 
ps -ef | grep 'Self Service' | grep -v grep | awk '{print $2}' | xargs kill