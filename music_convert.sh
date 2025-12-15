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
    ext="${file##*.}"

    metadata="0"
    if [ "$ext" == "opus" ] || [ "$ext" == "ogg" ]; then
        metadata="0:s:0"
    fi

    #ffmpeg -i "$file" -c:a libfdk_aac -c:v png -vsync passthrough -map_metadata "$metadata" $(basename "${file%.*}.m4a") &

    outfile=`basename "$file"`
    outfile="${outfile%.*}.mp3"
        if [ -z "$PARALLEL" ]; then
            yes | ffmpeg -i "$file" -q:a 0 -map_metadata "$metadata" -id3v2_version 3 "$outfile"
        else
            yes | ffmpeg -i "$file" -q:a 0 -map_metadata "$metadata" -id3v2_version 3 "$outfile" &
        fi
done

IFS=$OLDIFS
