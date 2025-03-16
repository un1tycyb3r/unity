#!/bin/bash

baseDir=~/bugbounty

for program in "$baseDir"/*/; do
    workingDir=$program
    cd $workingDir

    NUCLEI_INPUT=${program}${programName}_webservers.txt
    XSS_INPUT=${program}${programName}_xss.txt
    touch $XSS_INPUT

    cat $NUCLEI_INPUT | /home/un1tycyb3r/go/bin/anew $XSS_INPUT
    
done