#!/bin/bash

WALLPAPERS_PATH=${1:-$HOME/repos/public/dotfiles/wallpapers}
WALLPAPER_NAME=$(ls ${WALLPAPERS_PATH} | shuf -n 1)
swww img ${WALLPAPERS_PATH}/${WALLPAPER_NAME}
