#!/usr/bin/env bash

# ╔══════════════════════════════════════════╗
# ║         Theme Changer Script             ║
# ╚══════════════════════════════════════════╝

THEMES_DIR="$HOME/.config/themes"
ACTIVE_LINK="$THEMES_DIR/active"

# 1. Validate input
if [ -z "${1:-}" ]; then
    echo "Usage: theme-changer <theme_name>"
    echo "Available themes:"
    find "$THEMES_DIR" -maxdepth 1 -mindepth 1 -type d ! -name "active" -exec basename {} \;
    exit 1
fi

SELECTED_THEME="$1"

if [ ! -d "$THEMES_DIR/$SELECTED_THEME" ] || [ "$SELECTED_THEME" = "active" ]; then
    echo "Error: Theme '$SELECTED_THEME' not found."
    exit 1
fi

# 2. Update symlink
ln -sfn "$SELECTED_THEME" "$ACTIVE_LINK"

echo "Theme changed to $SELECTED_THEME"

# 3. Handle apps that don't support symlinks/imports well
# Starship (merge base + theme)
if [ -f "$HOME/.config/starship.base.toml" ]; then
    if [ -L "$HOME/.config/starship.toml" ]; then
        rm -f "$HOME/.config/starship.toml"
    fi
    cat "$HOME/.config/starship.base.toml" "$ACTIVE_LINK/starship.toml" > "$HOME/.config/starship.toml"
fi

# Fuzzel (merge base + theme)
if [ -f "$HOME/.config/fuzzel/fuzzel.base.ini" ]; then
    if [ -L "$HOME/.config/fuzzel/fuzzel.ini" ]; then
        rm -f "$HOME/.config/fuzzel/fuzzel.ini"
    fi
    cat "$HOME/.config/fuzzel/fuzzel.base.ini" "$ACTIVE_LINK/fuzzel.ini" > "$HOME/.config/fuzzel/fuzzel.ini"
fi

# Neofetch (update colors.conf symlink)
ln -sfn "$ACTIVE_LINK/neofetch.conf" "$HOME/.config/neofetch/colors.conf"

# Alacritty (update theme.toml symlink)
ln -sfn "$ACTIVE_LINK/alacritty.toml" "$HOME/.config/alacritty/theme.toml"

# Ghostty (update theme.conf symlink)
if [ -d "$HOME/.config/ghostty" ]; then
    ln -sfn "$ACTIVE_LINK/ghostty.conf" "$HOME/.config/ghostty/theme.conf"
fi

# Niri Theme (update theme.kdl symlink)
if [ -d "$HOME/.config/niri/configs" ]; then
    ln -sfn "$ACTIVE_LINK/niri.kdl" "$HOME/.config/niri/configs/theme.kdl"
fi

# Waybar (update colors.css symlink)
if [ -d "$HOME/.config/waybar" ]; then
    ln -sfn "$ACTIVE_LINK/waybar.css" "$HOME/.config/waybar/colors.css"
fi

# SwayNC (update colors.css symlink)
if [ -d "$HOME/.config/swaync" ]; then
    ln -sfn "$ACTIVE_LINK/swaync.css" "$HOME/.config/swaync/colors.css"
fi

# Ranger (update custom.py symlink)
if [ -d "$HOME/.config/ranger/colorschemes" ]; then
    ln -sfn "$ACTIVE_LINK/ranger.py" "$HOME/.config/ranger/colorschemes/custom.py"
fi

# Fish (update theme symlink)
if [ -d "$HOME/.config/fish/themes" ]; then
    ln -sfn "$ACTIVE_LINK/fish.theme" "$HOME/.config/fish/themes/theme"
fi

# Neovim (update theme symlink)
if [ -d "$HOME/.config/nvim/lua/plugins" ]; then
    ln -sfn "$ACTIVE_LINK/nvim.lua" "$HOME/.config/nvim/lua/plugins/theme.lua"
fi

# Tmux Theme (update theme.conf symlink)
if [ -d "$HOME/.config/tmux" ]; then
    ln -sfn "$ACTIVE_LINK/tmux.conf" "$HOME/.config/tmux/theme.conf"
fi

# 4. Reload apps
# Waybar
pkill -USR2 waybar || true

# SwayNC
command -v swaync-client >/dev/null && swaync-client -rs || true

# Alacritty (auto-reloads)
touch "$HOME/.config/alacritty/alacritty.toml"

# Ghostty
touch "$HOME/.config/ghostty/config"

# Tmux
tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || true

# Niri
# Niri auto-reloads when config is touched
touch "$HOME/.config/niri/config.kdl"
touch "$HOME/.config/niri/configs/custom.kdl"

echo "Apps reloaded."
