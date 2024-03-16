 #!/bin/bash

 set -e

 # Set random wallapaper
 ${HOME}/repos/public/dotfiles/wallpapers/randomw.sh

 # Get new wallpaper path
 WALLPAPER=$(cat /tmp/wallpaper)

 # Generate color scheme
 wal -s -i ${WALLPAPER}

# Reload waybar
${HOME}/repos/public/dotfiles/waybar/start.sh
