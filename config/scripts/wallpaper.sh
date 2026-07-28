#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/walls/"
NIRI_WALLPAPER="$HOME/nixos-dotfiles/config/niri/wallpaper"

entries=""
for img in "$WALLPAPER_DIR"/*; do
    name="$(basename "$img")"
    entries+="$name\0icon\x1f$img\n"
done

chosen="$(printf "%b" "$entries" | rofi -dmenu -p 'Wallpaper' -show-icons)"

[ -z "$chosen" ] && exit

full="$WALLPAPER_DIR$chosen"

printf '%s\n' "$full" > "$NIRI_WALLPAPER"

pkill swaybg || true
swaybg -m fill -i "$full" >/tmp/swaybg.log 2>&1 &

wallust --config-dir "$HOME/nixos-dotfiles/config/wallust" run "$full"

makoctl reload

pkill waybar
waybar &
