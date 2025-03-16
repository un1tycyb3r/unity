#!/bin/bash

baseDir=~/bugbounty

for program in "$baseDir"/*/; do
    workingDir=$program
    cd $workingDir

    XSS_INPUT=${program}${programName}_xss.txt
    XSS_OUTPUT=${program}${programName}_xss_output.txt
    touch $XSS_OUTPUT

    while read -r line; do
        /home/un1tycyb3r/.cargo/bin/x8 -u $line -w /home/un1tycyb3r/Tools/wordlists/param/httparchive_parameters_top_1m_2024_05_28.txt -W 5 --reflected-only -o $XSS_OUTPUT
    done < $XSS_INPUT

    cat $XSS_OUTPUT | /home/un1tycyb3r/go/bin/notify -silent -bulk -id xss 2> /bugbounty/xsslogs.txt

    rm $XSS_OUTPUT
    
done