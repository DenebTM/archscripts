#!/usr/bin/env bash
infile=$1
outfile="${infile%.*}"
args=${@:2}
echo "$infile -> $outfile"
gcc -lm $infile -o $outfile && time ./$outfile $args
