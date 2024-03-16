 #!/bin/bash

 set -e

 # Set random wallapaper
 ${HOME}/repos/public/dotfiles/wallpapers/selectw.sh

 # Get new wallpaper path
 WALLPAPER=$(cat /tmp/wallpaper)

 # Generate color scheme
 wal -s -i ${WALLPAPER} > /dev/null 2>&1

# Reload waybar
${HOME}/repos/public/dotfiles/waybar/start.sh > /dev/null 2>&1 &
