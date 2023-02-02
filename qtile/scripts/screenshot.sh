#!/bin/bash

print_help() {
	usage="$(basename "$0") [--help|-h] [--fullscreen|-f] [--selection|-s]"
	echo "Usage: $usage"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]
then
	print_help
	exit 0
fi

if [ "$1" = "--fullscreen"  ] || [ "$1" = "-f" ]
then
	play "$(dirname "$0")/../files/camera-shutter.wav"
	magick import -quiet -window root /home/stacksmasher/Pictures/$(date +%FZ%T-screenshot.png)
	exit 0
fi

if [ "$1" = "--selection" ] || [ "$1" = "-s" ]
then
	play "$(dirname "$0")/../files/camera-shutter.wav"
	magick import -quiet /home/stacksmasher/Pictures/$(date +%FZ%T-screenshot.png)
	exit 0
fi

echo "Bad parameters"
print_help
