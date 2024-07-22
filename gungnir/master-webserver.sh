#!/bin/bash

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        programName=$(basename "$program")
        cd $workingDir
        # Paths to your files
        GUNGNIR_OUTPUT=${program}/gungnir_previous_subdomains.txt
        PREVIOUS_WEBSERVERS=${program}/gungnir_previous_webservers.txt
        NEW_WEBSERVERS=${program}/gungnir_new_webservers.txt
        NUCLEI_INPUT=${program}/${programName}_webservers.txt
        # Ensure the previous subdomains file exists
        touch $PREVIOUS_WEBSERVERS
        touch $NUCLEI_INPUT

        # Check if there are new subdomains to notify
        if [ -s $NEW_WEBSERVERS ]; then
            # Send new webservers to the Discord webhook using notify
            echo "New webservers found for $programName:" | /root/go/bin/notify -silent -bulk -id yahoo
            cat $NEW_WEBSERVERS | /usr/bin/awk '{print $1}' | /root/go/bin/anew |  /root/go/bin/notify -silent -bulk -id yahoo
        fi
    done
fi
