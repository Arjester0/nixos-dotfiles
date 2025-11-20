#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/walls/"
CONF="$HOME/nixos-dotfiles/config/hypr/hyprpaper.conf" 

entries=""
for img in "$WALLPAPER_DIR"/*; do
    name="$(basename "$img")"
    entries+="$name\0icon\x1f$img\n"
done

chosen="$(printf "%b" "$entries" | rofi -dmenu -p 'Wallpaper' -show-icons)"

[ -z "$chosen" ] && exit
full="$WALLPAPER_DIR$chosen"

{
    echo "preload = $full"
    echo "wallpaper = ,$full"
} > "$CONF" 

wallust run "$WALLPAPER_DIR/$chosen"

pkill hyprpaper
hyprpaper 
pkill waybar
waybar

