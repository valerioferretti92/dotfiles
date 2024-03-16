#!/bin/bash

set -e

WALLPAPER_PATH=$(find "$HOME/repos/public/dotfiles/wallpapers/files" -type f | fzf)

if [ -z "$WALLPAPER_PATH" ]; then
	exit -1
fi

${HOME}/repos/public/dotfiles/wallpapers/setw.sh $WALLPAPER_PATH > /dev/null 2>&1
