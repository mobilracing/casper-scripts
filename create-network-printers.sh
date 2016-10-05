#!/bin/sh

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 
# Written by: William Smith
# Professional Services Engineer
# JAMF Software
# bill@talkingmoose.net
# https://github.com/talkingmoose/Casper-Scripts
#
# Originally posted: September 9, 2016
# Last updated: September 9, 2016
#
# Purpose: This is a generic script to create a printer with options
# using a policy in a Casper JSS.
#
# Except where otherwise noted, this work is licensed under
# http://creativecommons.org/licenses/by/4.0/
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# INSTRUCTIONS

# 1) Create a new Script in the JSS and paste the contents of the script into it.
# 2) Under the Options tab of the script, add the parameter labels as shown below.
# 3) Make a new policy and add the script.
# 4) Enter the correct settings for each parameter for the script to the policy.

# $4 = Printer Host Name
# $5 = Printer Location
# $6 = Printer Name
# $7 = Printer URL
# $8 = Printer PPD
# $9 = Printer Options

# create printer
lpadmin -p "$4" -L "$5" -D "$6" -E -v "$7" -P "$8" "$9"

exit 0