#!/usr/bin/env bash

module add qmutil

mkfifo "$$"
b=`basename *.log .log`
extract-gdrv-ene *.log > "$$" &
tail -n +4 "$$" > ${b}.dat
fg
rm "$$"
gnuplot <<EOT
set term pngcairo
set output "${b}.png"
plot "${b}.dat" using 1:3 with linespoints pointtype 5
EOT
