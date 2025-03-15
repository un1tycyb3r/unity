#!/bin/bash


baseDir=~/bugbounty

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        programName=$(basename "$program")
        cd $workingDir
        NUCLEI_INPUT=${program}${programName}_webservers.txt
        NUCLEI_OUTPUT=${program}${programName}_nuclei_output.txt
        NUCLEI_PREVIOUS_OUTPUT=${program}${programName}_nuclei_previous_output.txt
        NUCLEI_NEW_OUTPUT=${program}${programName}_nuclei_new_output.txt





        # Ensure the previous nuclei output file exists
        touch $NUCLEI_OUTPUT
        touch $NUCLEI_PREVIOUS_OUTPUT

        # Run Nuclei Checks
        cat $NUCLEI_INPUT | /home/un1tycyb3r/go/bin/nuclei -t /home/un1tycyb3r/Tools/my-templates -nh -c 200 -stream -o $NUCLEI_OUTPUT

        cat $NUCLEI_OUTPUT | /home/un1tycyb3r/go/bin/anew $NUCLEI_PREVIOUS_OUTPUT > $NUCLEI_NEW_OUTPUT

        # Check if there are new subdomains to notify
        if [ -s $NUCLEI_NEW_OUTPUT ]; then
            # Send new webservers to the Discord webhook using notify
            cat $NUCLEI_NEW_OUTPUT | /home/un1tycyb3r/go/bin/notify -silent -bulk -id nuclei
        fi

        # Clean up the new webservers file
        rm $NUCLEI_INPUT
        rm $NUCLEI_OUTPUT
        rm $NUCLEI_NEW_OUTPUT
    done
fi

