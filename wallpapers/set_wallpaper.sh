#!/bin/bash

set -e

LOCK_FILE="/tmp/wallpaper.lock"

# Function to remove lock file
remove_lock_file() {
		if [ -f "$LOCK_FILE" ];
		then
				rm -f "$LOCK_FILE"
				echo "$LOCK_FILE removed."
		else
				echo "$LOCK_FILE does not exist."
		fi
}

# Check if lock file exists
if [ -f "$LOCK_FILE" ]; then
		echo "Lock file exists. Exiting."
		exit 0
fi

# Trap any signals or errors and remove lock file before exiting
trap 'remove_lock_file' EXIT

# Create lock file
touch "$LOCK_FILE"
echo "$LOCK_FILE created."

WALLPAPERS_PATH=${1:-$HOME/repos/public/dotfiles/wallpapers/files}
WALLPAPER_NAME=$(ls ${WALLPAPERS_PATH} | shuf -n 1)

# Hyprpaper
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "${WALLPAPERS_PATH}/${WALLPAPER_NAME}"

MONITORS=$(hyprctl monitors | grep Monitor | sed 's/^Monitor \(.*\) (ID [0-9]*):$/\1/')
for MONITOR in $MONITORS
do
	hyprctl hyprpaper wallpaper "${MONITOR},${WALLPAPERS_PATH}/${WALLPAPER_NAME}" &
done

# Storing wallpaper pathin temp file
echo ${WALLPAPERS_PATH}/${WALLPAPER_NAME} > /tmp/wallpaper
exit 0
