#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
ROFI_THEME="$HOME/dotfiles/home/apps/rofi/wallpaper.rasi"

wallpaper=$(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f  \
    -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \
		| while read -r image; do
        printf "%s\0icon\x1f%s\n" "$(basename "$image")" "$image"
    done \
    | rofi -dmenu -i -p "Wallpapers" -theme "$ROFI_THEME"
)

if [[ -n "$wallpaper" ]]; then
    plasma-apply-wallpaperimage "$WALLPAPER_DIR/$wallpaper"
fi
