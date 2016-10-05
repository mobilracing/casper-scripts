#!/bin/bash

osascript<<EOD

mount volume "smb://files.server.com"
set server to result as alias
set y to path to desktop
tell application "Finder"
    make alias at y to server
end tell
display dialog "Created an Alias to Network Location on Desktop to " & server with title "Network Alias Creation" buttons {"OK"}

EOD

exit 0