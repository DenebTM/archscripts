#!/usr/bin/env sh
infile=$1
outfile="${infile%.*}"
arm-linux-gnueabi-as -ggdb -o $outfile.o $infile &&
arm-linux-gnueabi-ld -o $outfile $outfile.o &&
rm $outfile.o &&
out="$(qemu-arm -g 1234 $outfile)" &&
printf "\n$out\n"
echo
