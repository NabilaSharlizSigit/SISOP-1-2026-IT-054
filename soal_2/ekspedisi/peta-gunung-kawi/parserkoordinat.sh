#!/bin/bash

awk -F'"' '/site_name/ {site=$4} /id/ {id=$4}
/latitude/{
	split($0, a, ": ")
	gsub(/,/, "", a[2])
	x=a[2]
}
/longitude/{
	split($0, b, ": ")
        gsub(/,/, "", b[2])
        y=b[2]

	print id "," site "," x "," y

}' gsxtrack.json

