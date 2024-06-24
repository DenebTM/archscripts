#!/usr/bin/env bash
if [[ -z "$1" ]]; then
    echo "Usage: $0 <number of images> [<basename>]"
    exit -1
fi

n="$1"
basename="$2"
for i in $(seq 1 1 $n); do
    read -n 1 -r -s -p $'Press enter to continue.\n'
    echo "Scanning image $i of $n, please wait..."
    fullname="$basename"
    [[ $n -gt 1 ]] && fullname="$fullname"_"$i"
    scanimage --resolution 300 --format=png -o "$fullname".png
done
