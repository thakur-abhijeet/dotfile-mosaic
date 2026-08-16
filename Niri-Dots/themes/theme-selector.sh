#!/usr/bin/env bash
 
THEMES_DIR="$HOME/.config/themes"
themes=""
for d in "$THEMES_DIR"/*/; do
    [ -d "$d" ] || continue
    base=$(basename "$d")
    if [ "$base" != "active" ]; then
        themes+="$base"$'\n'
    fi
done
themes=$(echo -n "$themes" | sort -f)
 
SELECTED=$(echo -n "$themes" | fuzzel -d -p "Select Theme: " --width 20 --lines 10)
 
if [ -n "$SELECTED" ]; then
    bash "$THEMES_DIR/theme-changer.sh" "$SELECTED"
fi
