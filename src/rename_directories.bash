#!/bin/bash

echo "Rename folders and directories ${2} -> ${3}";

# Rename directories
find ${1} -type d -name "${2}*"  | while read FILE ; do
    newfile="$(echo ${FILE} |sed -e "s/${2}/${3}/")" ;
    mv   "${FILE}" "${newfile}" ;
done

# Rename files
find ${1} -type f -name "${2}*" | while read FILE ; do
    newfile="$(echo ${FILE} |sed -e "s/${2}/${3}/")" ;
    mv   "${FILE}" "${newfile}" ;
done