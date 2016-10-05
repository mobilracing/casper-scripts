#!/bin/bash

procList=("Citrix Receiver"
"ReceiverHelper"
"Citrix Receiver Helper"
"Citrix Receiver Authentication"
"Citrix Receiver Helper")

for proc in "${procList[@]}"; do
    runningProc=$(ps axc | grep -i "$proc" | awk '{print $1}')
    if [[ $runningProc ]]; then
        echo "Found running process $proc with PID: ${runningProc}. Killing it..."
        kill $runningProc
    else
        echo "$proc not found running..."
    fi
done