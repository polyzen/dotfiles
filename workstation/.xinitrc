#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

export AMD_VULKAN_ICD=RADV
export QT_QPA_PLATFORMTHEME=qt5ct

export BROWSER=firefox
export TERMINAL=alacritty

xrdb .Xresources
xset b off s off

picom -b
hsetroot -solid '#282828'
sxhkd &
i3
