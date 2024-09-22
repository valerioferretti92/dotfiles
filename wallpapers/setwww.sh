#!/bin/bash

set -e

WALLPAPER_PATH=${1}

swww img ${WALLPAPER_PATH} --transition-step 32 --transition-fps 30 --transition-type fade

exit 0
