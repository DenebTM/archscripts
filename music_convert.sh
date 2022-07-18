#!/bin/bash
IN="$1"
if [ -z "$IN" ]; then
    echo "You must specify an input directory!"
    exit 1
fi

OLDIFS=$IFS
IFS=$'\n'

function break() {
    echo "Aborted"
    IFS=$OLDIFS
    exit 2
}
trap break INT

for file in "$@"; do
    ffmpeg -i "$file" -q:a 0 -map_metadata 0:s:0 -id3v2_version 3 $(basename "${file%.*}.mp3")
done

IFS=$OLDIFS
