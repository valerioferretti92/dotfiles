#!/bin/bash

set -e

WALLPAPERS_PATH=${1:-$HOME/repos/public/dotfiles/wallpapers/files}
WALLPAPER_NAME=$(ls ${WALLPAPERS_PATH} | shuf -n 1)

${HOME}/repos/public/dotfiles/wallpapers/setw.sh ${WALLPAPERS_PATH}/${WALLPAPER_NAME}
