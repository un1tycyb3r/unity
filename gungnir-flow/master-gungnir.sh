#!/bin/bash

baseDir=~/bugbounty

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        cd $workingDir
        # Paths to your files
        GUNGNIR_OUTPUT="${program}subdomains.txt"
        PREVIOUS_SUBDOMAINS="${program}gungnir_previous_subdomains.txt"
	    NEW_SUBDOMAINS="${program}gungnir_new_subdomains.txt"
        # Ensure the previous subdomains file exists
        touch $PREVIOUS_SUBDOMAINS
        
        if [[ -f "$GUNGNIR_OUTPUT" ]]; then
            # Extract new subdomains using anew
            cat $GUNGNIR_OUTPUT | /home/un1tycyb3r/go/bin/anew $PREVIOUS_SUBDOMAINS >> $NEW_SUBDOMAINS
        fi
    done
fi

