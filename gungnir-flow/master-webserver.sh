#!/bin/bash

baseDir=~/bugbounty

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        programName=$(basename "$program")
        cd $workingDir
        # Paths to your files
        GUNGNIR_OUTPUT=${program}/gungnir_new_subdomains.txt
        PREVIOUS_WEBSERVERS=${program}/gungnir_previous_webservers.txt
        NEW_WEBSERVERS=${program}/gungnir_new_webservers.txt
	    FINAL_WEBSERVERS=${program}/${programName}_final_webservers.txt
        NUCLEI_INPUT=${program}/${programName}_webservers.txt
        # Ensure the previous subdomains file exists
        touch $PREVIOUS_WEBSERVERS
        touch $NUCLEI_INPUT
	    touch $FINAL_WEBSERVERS

	    # Extract new subdomains using anew
        cat $GUNGNIR_OUTPUT | /home/un1tycyb3r/go/bin/httpx -sc -ports 80,443,3000,4443,8000,8080,8443,9000,10000,8188,8001,9090 -no-fallback -random-agent | /home/un1tycyb3r/go/bin/anew $PREVIOUS_WEBSERVERS >> $NEW_WEBSERVERS
        cat $NEW_WEBSERVERS | /usr/bin/awk '{print $1}' | /home/un1tycyb3r/go/bin/anew >> $FINAL_WEBSERVERS
        cat $FINAL_WEBSERVERS | /home/un1tycyb3r/go/bin/anew $NUCLEI_INPUT

        # Check if there are new subdomains to notify
        if [ -s $NEW_WEBSERVERS ]; then
            # Send new webservers to the Discord webhook using notify
            echo "**New webservers found for $programName**" | /home/un1tycyb3r/go/bin/notify -silent -bulk -id yahoo 2> /bugbounty/webserverlogs.txt
            cat $NEW_WEBSERVERS | /home/un1tycyb3r/go/bin/notify -silent -bulk -id yahoo 2> /bugbounty/webserverlogs.txt
	    
        fi

        rm $GUNGNIR_OUTPUT
        rm $NEW_WEBSERVERS
        rm $FINAL_WEBSERVERS
    done

fi
