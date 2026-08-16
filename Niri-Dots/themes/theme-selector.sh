#!/usr/bin/env bash

THEMES_DIR="$HOME/.config/themes"
themes=$(ls -d $THEMES_DIR/*/ | xargs -n 1 basename | grep -v "active")

SELECTED=$(echo "$themes" | fuzzel -d -p "Select Theme: " --width 20 --lines 10)

if [ -n "$SELECTED" ]; then
    bash "$THEMES_DIR/theme-changer.sh" "$SELECTED"
fi
