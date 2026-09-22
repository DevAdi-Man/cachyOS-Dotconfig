#!/usr/bin/env bash
# wallpaper-change.sh — Super+F1 random wallpaper
WALLPAPER=$(find "$HOME/Pictures/wallpapers" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | shuf -n 1)

[ -z "$WALLPAPER" ] && exit 1
omarchy-theme-bg-set "$WALLPAPER"
