#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

export BROWSER=firefox
export TERMINAL=termite

export FT2_SUBPIXEL_HINTING=1 

xset s off
xrdb .Xresources
sxhkd &
i3
