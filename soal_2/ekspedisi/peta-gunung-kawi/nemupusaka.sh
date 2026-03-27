#!/bin/bash

awk 'BEGIN {FS=","} {
        sumx+=$3
        sumy+=$4
} END { print "Koordinat pusat:\n(" sumx/4 "," sumy/4 ")" }' titik-penting.txt
