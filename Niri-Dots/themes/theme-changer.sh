#!/usr/bin/env bash

# ╔══════════════════════════════════════════╗
# ║         Theme Changer Script             ║
# ╚══════════════════════════════════════════╝

THEMES_DIR="$HOME/.config/themes"
ACTIVE_LINK="$THEMES_DIR/active"

# 1. Get list of themes
themes=($(ls -d $THEMES_DIR/*/ | xargs -n 1 basename | grep -v "active"))

if [ -z "$1" ]; then
    echo "Usage: theme-changer <theme_name>"
    echo "Available themes: ${themes[@]}"
    exit 1
fi

SELECTED_THEME="$1"

if [[ ! " ${themes[@]} " =~ " ${SELECTED_THEME} " ]]; then
    echo "Error: Theme '$SELECTED_THEME' not found."
    exit 1
fi

# 2. Update symlink
ln -sfn "$SELECTED_THEME" "$ACTIVE_LINK"

echo "Theme changed to $SELECTED_THEME"

# 3. Handle apps that don't support symlinks/imports well
# Starship (merge base + theme)
if [ -f "$HOME/.config/starship.base.toml" ]; then
    cat "$HOME/.config/starship.base.toml" "$ACTIVE_LINK/starship.toml" > "$HOME/.config/starship.toml"
fi

# Fuzzel (merge base + theme)
if [ -f "$HOME/.config/fuzzel/fuzzel.base.ini" ]; then
    cat "$HOME/.config/fuzzel/fuzzel.base.ini" "$ACTIVE_LINK/fuzzel.ini" > "$HOME/.config/fuzzel/fuzzel.ini"
fi

# Neofetch (update colors.conf symlink)
ln -sfn "$ACTIVE_LINK/neofetch.conf" "$HOME/.config/neofetch/colors.conf"

# Alacritty (update theme.toml symlink)
ln -sfn "$ACTIVE_LINK/alacritty.toml" "$HOME/.config/alacritty/theme.toml"


# 4. Reload apps
# Waybar
pkill -USR2 waybar || true

# SwayNC
command -v swaync-client >/dev/null && swaync-client -rs || true

# Alacritty (auto-reloads)
touch "/home/abhijeet.thakur@infodevelopers.local/.config/alacritty/alacritty.toml"

# Ghostty
touch "/home/abhijeet.thakur@infodevelopers.local/.config/ghostty/config"

# Tmux
tmux source-file "/home/abhijeet.thakur@infodevelopers.local/.config/tmux/tmux.conf" 2>/dev/null || true

# Niri
# Niri auto-reloads when config is touched
touch "/home/abhijeet.thakur@infodevelopers.local/.config/niri/config.kdl"
touch "/home/abhijeet.thakur@infodevelopers.local/.config/niri/configs/custom.kdl"

echo "Apps reloaded."
