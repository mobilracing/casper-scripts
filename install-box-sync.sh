#!/bin/bash

policy="Box Sync 4"
loggertag="system-log-tag" # JAMF IT uses the tag "jamfsw-it-logs"
tmpdir="/Library/Application Support/JAMF/tmp"
downloadurl="https://e3.boxcdn.net/box-installers/sync/Sync+4+External/Box%20Sync%20Installer.dmg"

log() {
echo "$1"
/usr/bin/logger -t "$loggertag: $policy" "$1"
}

mountcheck() {
if [ -d "$tmpdir"/boxsyncdmg ]; then
    if [[ $(mount | awk '/boxsyncdmg/ {print $3, $4}') == "$tmpdir/boxsyncdmg" ]]; then
        log "Cleanup: $tmpdir/boxsyncdmg/ is a mounted volume: unmounting"
        /usr/bin/hdiutil detach "$tmpdir"/boxsyncdmg
        if [ $? -eq 0 ]; then
            log "Cleanup: $tmpdir/boxsyncdmg successfully unmounted"
        else
            log "Cleanup: hdiutil error code $?: $tmpdir/boxsyncdmg failed to unmount"
        fi
    fi
fi
}

cleanup() {
log "Cleanup: Starting cleanup items"
mountcheck
if [ -f "$tmpdir"/boxsync.dmg ]; then
    log "Cleanup: Deleting $tmpdir/boxsync.dmg"
    /bin/rm "$tmpdir"/boxsync.dmg
    log "Cleanup complete."
fi
}

trap cleanup exit

log "Beginning installation of $policy"

# Check for the expected size of the downloaded DMG
webfilesize=$(/usr/bin/curl $downloadurl -ILs | awk '/Content-Length:/ {print $2}' | tail -n 1 | tr -d '\r')
log "The expected size of the downloaded file is $webfilesize"

/usr/bin/curl -Ls $downloadurl -o "$tmpdir"/boxsync.dmg
if [ $? -eq 0 ]; then
    log "The Box Sync Installer DMG successfully downloaded"
else
    log "curl error code $?: The Box Sync Installer DMG did not successfully download"
    exit 1
fi

# Check the size of the downloaded DMG
dlfilesize=$(/usr/bin/cksum "$tmpdir"/boxsync.dmg | awk '{print $2}')
log "The size of the downloaded file is $dlfilesize"

# Compare the expected size against the downloaded size
if [[ $webfilesize -ne $dlfilesize ]]; then
    echo "The file did not download properly"
    exit 1
fi

# Check if the $tmpdir/boxsyncdmg directory exists and is a mounted volume
mountcheck

# Mount the /tmp/Box\ Sync\Installer.dmg file
/usr/bin/hdiutil attach "$tmpdir"/boxsync.dmg -mountpoint "$tmpdir"/boxsyncdmg -nobrowse -noverify
if [ $? -eq 0 ]; then
    log "$tmpdir/boxsync.dmg successfully mounted"
else
    log "hdiutil error code $?: $tmpdir/boxsync.dmg failed to mount"
    exit 1
fi

# Check for and kill any Box Sync processes
pids=$(/usr/bin/pgrep "Box Sync")
if [ -n $pids ]; then
    for pid in ${pids[@]}; do
        log "Found Box Sync process $pid: killing"
        /bin/kill $pid
    done
fi

if [ -e /Applications/Box\ Sync.app ]; then
    /bin/rm -rf /Applications/Box\ Sync.app
    log "Deleted an existing copy of Box Sync.app"
fi

log "Copying Box Sync.app to /Applications"
/bin/cp -a "$tmpdir"/boxsyncdmg/Box\ Sync.app /Applications/
if [ $? -eq 0 ]; then
    log "The file copied successfully"
    /usr/sbin/chown -R root:admin /Applications/Box\ Sync.app
else
    log "cp error code $?: The file did not copy successfully"
    exit 1
fi

log "Copying com.box.sync.bootstrapper to /Library/PrivilegedHelperTools"
if [ ! -e /Library/PrivilegedHelperTools ]; then
    /bin/mkdir /Library/PrivilegedHelperTools
fi
/bin/cp -a /Applications/Box\ Sync.app/Contents/Resources/com.box.sync.bootstrapper /Library/PrivilegedHelperTools/
log "Running com.box.sync.bootstrapper"
/Applications/Box\ Sync.app/Contents/Resources/com.box.sync.bootstrapper --install
sleep 1

log "Opening Box Sync.app"
/usr/bin/open /Applications/Box\ Sync.app &

log "Postinstall for $policy complete. Running Recon."

exit 0