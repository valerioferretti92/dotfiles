#!/bin/bash

set -e

LOCK_FILE="/tmp/wallpaper.lock"

# Function to remove lock file
remove_lock_file() {
		echo "Removing $LOCK_FILE..."
		if [ -f "$LOCK_FILE" ];
		then
				rm -f "$LOCK_FILE"
				echo "$LOCK_FILE removed."
		else
				echo "$LOCK_FILE does not exist."
		fi
}

# Trap any signals or errors and remove lock file before exiting
trap 'remove_lock_file' EXIT

# Check if lock file exists
if [ -f "$LOCK_FILE" ]; then
		echo "Lock file exists. Exiting."
		exit 0
fi

# Create lock file
touch "$LOCK_FILE"

WALLPAPERS_PATH=${1:-$HOME/repos/public/dotfiles/wallpapers}
WALLPAPER_NAME=$(ls ${WALLPAPERS_PATH} | shuf -n 1)

# Hyprpaper
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "${WALLPAPERS_PATH}/${WALLPAPER_NAME}"
hyprctl hyprpaper wallpaper "eDP-1,${WALLPAPERS_PATH}/${WALLPAPER_NAME}"
hyprctl hyprpaper wallpaper "HDMI-A-1,${WALLPAPERS_PATH}/${WALLPAPER_NAME}"

exit 0
