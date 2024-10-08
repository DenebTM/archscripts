#!/usr/bin/env bash
function newfname {
    # just in case I manage to take two screenshots in one second, this prevents one overwriting the other
    local fn=$1
    local ex=$2
    if [ -f $fn'.'$ex ]; then
        ap="_000"
        while [ -f $fn$ap.$ex ]; do
            ap=$(printf _%03d $((${ap:1:3} + 1)))
        done
    fi
    echo $fn$ap.$ex
}

directory="$HOME/Nextcloud/Pictures/Screenshots/"
time="$(date +%F_%H%M%S)"
filename="$(newfname $directory$time png)"

if [[ "$1" == "f" || "$1" == "a" ]]; then
    spectacle -$1bco $filename
    echo "Screenshot saved to $filename."
elif [[ "$1" == "r" ]]; then
    sleep 0.2 && flameshot gui
    #spectacle -rcbn
    echo "Screenshot saved to clipboard."
fi
