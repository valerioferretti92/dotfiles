#!/bin/bash

set -e

WALLPAPER_PATH=$(find "$HOME/repos/public/dotfiles/wallpapers/files" -type f | fzf --bind='ctrl-a:execute(feh --image-bg "#1b1c16" --scale-down {} > /dev/null 2>&1 &)')

if [ -z "$WALLPAPER_PATH" ]; then
	exit -1
fi

echo ${WALLPAPER_PATH} > /tmp/wallpaper

${HOME}/repos/public/dotfiles/wallpapers/setwww.sh ${WALLPAPER_PATH} > /dev/null 2>&1 &
