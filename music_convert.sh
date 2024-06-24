#!/usr/bin/env bash
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
    metadata="0"
    if [ "${file##*.}" == "opus" ] || [ "${file##*.}" == "ogg" ]; then
        metadata="0:s:0"
    fi
    #ffmpeg -i "$file" -c:a libfdk_aac -c:v png -vsync passthrough -map_metadata "$metadata" $(basename "${file%.*}.m4a") &
    ffmpeg -i "$file" -c:v png -ab 320k -vsync passthrough -map_metadata "$metadata" -id3v2_version 3 -write_id3v1 1 $(basename "${file%.*}.mp3") &
done

IFS=$OLDIFS
