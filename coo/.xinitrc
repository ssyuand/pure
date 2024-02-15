#!/bin/bash
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"
export _JAVA_AWT_WM_NONREPARENTING=1

FILE=/dev/input/by-id/usb-Topre_Corporation_HHKB_Professional-event-kbd
if [ -L "$FILE" ]; then
	setxkbmap -layout us -option
else
	setxkbmap -layout us -option ctrl:swapcaps
	setxkbmap -option ctrl:swap_rctrl_lwin
fi

~/neoarch/scripts/etc/statusbar.sh &

# typing speed
xset r rate 266 26
# opening animation

exec sxhkd &
exec fcitx5 &

exec dwm
