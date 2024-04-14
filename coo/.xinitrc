#!/bin/bash
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"

setxkbmap -layout us -option ctrl:swapcaps
setxkbmap -option altwin:swap_lalt_lwin
setxkbmap -option ctrl:swap_rctrl_lwin

~/pure/coo/statusbar.sh &
brillo -e -S 33

# typing speed
xset r rate 266 26

exec sxhkd &
exec fcitx5 &
exec dwm
