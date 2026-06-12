#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/walls/"
HYPRPAPER_CONF="$HOME/nixos-dotfiles/config/hypr/hyprpaper.conf"
HYPRLOCK_WALLPAPER_CONF="$HOME/nixos-dotfiles/config/hypr/hyprlock-wallpaper.conf"

entries=""
for img in "$WALLPAPER_DIR"/*; do
    name="$(basename "$img")"
    entries+="$name\0icon\x1f$img\n"
done

chosen="$(printf "%b" "$entries" | rofi -dmenu -p 'Wallpaper' -show-icons)"

[ -z "$chosen" ] && exit

full="$WALLPAPER_DIR$chosen"

{
    printf 'preload=%s\n\n' "$full"
    printf 'wallpaper {\n'
    printf '  monitor=eDP-1\n'
    printf '  fit_mode=cover\n'
    printf '  path=%s\n' "$full"
    printf '}\n\n'
    printf 'wallpaper {\n'
    printf '  monitor=HDMI-A-1\n'
    printf '  fit_mode=cover\n'
    printf '  path=%s\n' "$full"
    printf '}\n\n'
    printf 'wallpaper {\n'
    printf '  monitor=\n'
    printf '  fit_mode=cover\n'
    printf '  path=%s\n' "$full"
    printf '}\n'
} > "$HYPRPAPER_CONF"

printf '$lock_wallpaper = %s\n' "$full" > "$HYPRLOCK_WALLPAPER_CONF"

pkill hyprpaper || true
hyprpaper -c "$HOME/.config/hypr/hyprpaper.conf" >/tmp/hyprpaper.log 2>&1 &

wallust --config-dir "$HOME/nixos-dotfiles/config/wallust" run "$full"

makoctl reload
hyprctl reload

pkill waybar
waybar &
