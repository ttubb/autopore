#!/bin/bash

#This script is designed to write a list of nanopore read files required by necat ( https://github.com/xiaochuanle/NECAT ) based on the filenames given as command line paramters.

#Constants
OUTPUT_FILENAME=reads_list.txt

#Check if a file with this name already exists
if [ -f $OUTPUT_FILENAME ]; then
    echo "A file named ${OUTPUT_FILENAME} already exists in the current working directory."
    exit 3
fi

#Write all command line arguments into the output file as separate lines
FIRSTLINE=1
for readname in "$@"; do
    if [ $FIRSTLINE -eq 1 ]; then
	FIRSTLINE=0
	echo "$readname" > $OUTPUT_FILENAME
    else
	echo "$readname" >> $OUTPUT_FILENAME
    fi
done
