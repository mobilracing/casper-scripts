#!/bin/bash
#joel (at) brunerd.com

#supply idle time to change to
idleTimeMinutes=$4

if [ "$idleTimeMinutes" -ne 1 -a "$idleTimeMinutes" -ne 2 -a "$idleTimeMinutes" -ne 5 -a "$idleTimeMinutes" -ne 10 -a "$idleTimeMinutes" -ne 20 -a "$idleTimeMinutes" -ne 30 -a "$idleTimeMinutes" -ne 60 ]; then
    echo "Time in minutes MUST BE: 1, 2, 5, 10, 20, 30, or 60"
    exit
else    
    #convert to seconds
    idleTimeSeconds=$(( $idleTimeMinutes * 60 ))
fi

#get uid of console owner
eval $(stat -s /dev/console)
consoleUID=$st_uid
consoleUsername=$(id -un $st_uid)

if [ "$consoleUID" -eq 0 ]; then
    echo "No console user (login screen), exiting"
    exit
fi

#run commands as user
su $consoleUsername <<-EOS
osascript -e 'tell application "System Events" to set delay interval of screen saver preferences to '$idleTimeSeconds''
EOS