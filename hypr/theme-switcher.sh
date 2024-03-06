 #!/bin/bash

 # Set random wallapaper
 ${HOME}/repos/public/dotfiles/wallpapers/set_wallpaper.sh

 # Get new wallpaper path
 WALLPAPER=$(cat /tmp/wallpaper)

 # Generate color scheme
 wal -s -i ${WALLPAPER}

# Reload waybar
${HOME}/repos/public/dotfiles/waybar/start_waybar.sh
