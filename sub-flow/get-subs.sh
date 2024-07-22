#!/bin/bash

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
        workingDir=$program
        programName=$(basename "$program")
        cd $workingDir
        ROOT_FILE=${program}/roots.txt

        while read domain; do
            /root/go/bin/subfinder -d $domain -all -silent | anew -q $domain.SUBFINDER

        done < $ROOT_FILE
    done
fi
