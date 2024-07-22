#!/bin/bash

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        programName=$(basename "$program")
        cd $workingDir

        while read domain; do
            cat $domain.SUBFINDER | /root/go/bin/httpx -no-color -t 500 ports 80,443,3000,4443,8000,8080,8443,9000,10000,8188,8001,9090 -no-fallback -probe-all-ips -random-agent | /root/go/bin/anew -q $domain.httpx

        done < $ROOT_FILE
    done
fi
