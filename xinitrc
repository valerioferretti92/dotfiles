#!/bin/bash

madrid_office_setup() {
	if [[ ! -z $HDMI_SCREEN ]]
	then
		echo -e "Xft.dpi: 192\nXcursor.size: 32" > ~/.Xresources
		xrdb -merge ~/.Xresources
		export GDK_SCALE=2
		export GDK_DPI_SCALE=0.5
		export QT_AUTO_SCREEN_SET_FACTOR=0
		export QT_SCALE_FACTOR=2
		export QT_FONT_DPI=96
		
		xrandr --output "HDMI-1" --scale 0.9999x0.9999 --pos 0x0
		xrandr --output "eDP-1" --scale 2x2 --pos 3840x0
		
		export PRIMARY_SCREEN_RESOLUTION=3840x2160
		export SECONDARY_SCREEN_RESOLUTION=3840x1920
	else
		echo -e "Xft.dpi: 96\nXcursor.size: 16" > ~/.Xresources
		xrdb -merge ~/.Xresources
		export PRIMARY_SCREEN_RESOLUTION=1920x1080
	fi
}

madrid_livingroom_setup() {
	if [[ ! -z $HDMI_SCREEN ]]
	then
		xrandr --output "HDMI-1" --pos 1920x0
		export SECONDARY_SCREEN_RESOLUTION=1920x1080
	fi
	export PRIMARY_SCREEN_RESOLUTION=1920x1080
	echo -e "Xft.dpi: 96\nXcursor.size: 16" > ~/.Xresources
	xrdb -merge ~/.Xresources
}

juanlespins_setup() {
	if [[ ! -z $HDMI_SCREEN ]]
	then
		xrandr --output "HDMI-1" --pos 1920x0
		export SECONDARY_SCREEN_RESOLUTION=1920x1080
	fi
	export PRIMARY_SCREEN_RESOLUTION=1920x1080
	echo -e "Xft.dpi: 96\nXcursor.size: 16" > ~/.Xresources
	xrdb -merge ~/.Xresources
}

ACTIVE_MONITOR_XCONF_FILES=$(ls -la /etc/X11/xorg.conf.d | grep -i 'monitors.conf$' | wc -l)
if [[ $ACTIVE_MONITOR_XCONF_FILES != "1" ]]
then
	echo "Bad xmonitors config"
	exit -1
fi

MONITOR_SETUP=$(ls /etc/X11/xorg.conf.d | grep -i 'monitors.conf$')
HDMI_SCREEN=$(xrandr --listmonitors | grep HDMI)

if [[ $MONITOR_SETUP == "01-juanlespins.monitors.conf" ]]
then
	juanlespins_setup
elif [[ $MONITOR_SETUP == "02-madrid-office-monitors.conf" ]]
then
	madrid_office_setup
elif [[ $MONITOR_SETUP == "03-madrid-livingroom-monitors.conf" ]]
then
	madrid_livingroom_setup
fi

picom -b &

PYTHONTRACEMALLOC=1 qtile start


