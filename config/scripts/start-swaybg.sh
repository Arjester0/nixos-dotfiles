#!/usr/bin/env bash

wallpaper_file="$HOME/nixos-dotfiles/config/niri/wallpaper"

if [ -r "$wallpaper_file" ]; then
    read -r wallpaper < "$wallpaper_file"
else
    wallpaper="$HOME/Pictures/walls/wallhaven-kx5w77_1920x1080.png"
fi

[ -n "$wallpaper" ] && [ -f "$wallpaper" ] || exit 0

sleep 1
exec swaybg -m fill -i "$wallpaper"
