#!/bin/bash

set -e

WALLPAPERS_PATH=${1:-$HOME/repos/public/dotfiles/wallpapers/files}
WALLPAPER_NAME=$(ls ${WALLPAPERS_PATH} | shuf -n 1)

echo ${WALLPAPERS_PATH}/${WALLPAPER_NAME} > /tmp/wallpaper

${HOME}/repos/public/dotfiles/wallpapers/setwww.sh ${WALLPAPERS_PATH}/${WALLPAPER_NAME} > /dev/null 2>&1 &
