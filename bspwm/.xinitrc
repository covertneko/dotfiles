#!/bin/sh

mkdir -p "$HOME/.local/state/xorg"
exec > "$HOME/.local/state/xorg/xinit.log"
exec 2>&1

export QT_STYLE_OVERRIDE=GTK+

xsetroot -cursor_name left_ptr &

sxhkd &
exec bspwm
