#!/usr/bin/env bash
infile=$1
outfile="${infile%.*}"
args="${@:2}"
arm-linux-gnueabihf-as -g -o $outfile.o $infile &&
arm-linux-gnueabihf-ld -g -o $outfile $outfile.o &&
rm $outfile.o &&

#qemu-arm -g 1234 $outfile $args
qemu-arm $outfile $args
