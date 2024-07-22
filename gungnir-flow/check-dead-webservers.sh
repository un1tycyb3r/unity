#!/bin/bash

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        programName=$(basename "$program")
        cd $workingDir

        SUBS=${program}/gungnir_previous_subdomains.txt
        PREVIOUS_WEBSERVERS=${program}/gungnir_previous_webservers.txt
        NEW_WEBSERVERS=${program}/gungnir_new_webservers.txt
        FINAL_WEBSERVERS=${program}/${programName}_final_webservers.txt
        NUCLEI_INPUT=${program}/${programName}_webservers.txt


        touch $PREVIOUS_WEBSERVERS
        touch $NEW_WEBSERVERS

        cat $GUNGNIR_OUTPUT | /root/go/bin/httpx -no-color -t 500 ports 80,443,3000,4443,8000,8080,8443,9000,10000,8188,8001,9090 -no-fallback -probe-all-ips -random-agent | /root/go/bin/anew $PREVIOUS_WEBSERVERS >> $NEW_WEBSERVERS

        cat $NEW_WEBSERVERS | /usr/bin/awk '{print $1}' | /root/go/bin/anew >> $FINAL_WEBSERVERS

        cat $FINAL_WEBSERVERS | /root/go/bin/anew $NUCLEI_INPUT

        # Check if there are new subdomains to notify
        if [ -s $FINAL_WEBSERVERS ]; then
            # Send new webservers to the Discord webhook using notify
            echo "New webservers found for $programName:" | /root/go/bin/notify -silent -bulk -id yahoo 2> /root/webserverlogs.txt
            cat $FINAL_WEBSERVERS | /root/go/bin/notify -silent -bulk -id yahoo 2> /root/webserverlogs.txt
            rm $NEW_WEBSERVERS
            rm $FINAL_WEBSERVERS
        fi
    done

fi




