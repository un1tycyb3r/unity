#!/bin/bash

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        cd $workingDir
        # Paths to your files
        GUNGNIR_OUTPUT="${program}subdomains.txt"
        PREVIOUS_SUBDOMAINS="${program}gungnir_previous_subdomains.txt"
        # Ensure the previous subdomains file exists
        touch $PREVIOUS_SUBDOMAINS
        
        if [[ -f "$GUNGNIR_OUTPUT" ]]; then
            # Extract new subdomains using anew
            cat "$GUNGNIR_OUTPUT" | /root/go/bin/anew "$PREVIOUS_SUBDOMAINS"
        fi
    done
fi
