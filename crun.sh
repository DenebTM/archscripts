#!/usr/bin/env bash
infile=$1
outfile="${infile%.*}"
args=${@:2}
echo "$infile -> $outfile"
gcc -lm -Wall -Werror -Wextra -Wpedantic -std=c99 $infile -o $outfile && time ./$outfile $args
echo
