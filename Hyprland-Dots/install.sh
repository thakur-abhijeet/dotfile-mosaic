#!/usr/bin/env bash
# =============================================================================
# Dotfiles Installer
# Author: Abhijeet Thakur
# Description: Robust installer for Hyprland + Fuzzel + Kitty + Starship + Scripts
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

# -----------------------------
# Functions
# -----------------------------
info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() {
  echo -e "\033[1;31m[ERROR]\033[0m $*"
  exit 1
}

backup_if_exists() {
  local file="$1"
  if [ -e "$file" ]; then
    local ts
    ts=$(date +"%Y%m%d%H%M%S")
    mv "$file" "${file}.bak.$ts"
    info "Backed up $file to ${file}.bak.$ts"
  fi
}

# -----------------------------
# Directories
# -----------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
THEMES_DIR="$CONFIG_DIR/themes"

mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_BIN"
mkdir -p "$THEMES_DIR"

# -----------------------------
# Dependencies
# -----------------------------
info "Installing dependencies..."
if command -v pacman >/dev/null 2>&1; then
  sudo pacman -Syu --needed git fzf bat curl alacritty starship jq wl-clipboard \
    wayland-protocols hyprland kitty --noconfirm
else
  warn "Manual installation of dependencies may be required (non-pacman system)"
fi

# -----------------------------
# Copy Configs
# -----------------------------
info "Copying configuration files..."

for folder in hypr fuzzel kitty starship; do
  src="$DOTFILES_DIR/.config/$folder"
  dest="$CONFIG_DIR/$folder"
  mkdir -p "$dest"
  for file in "$src"/*; do
    backup_if_exists "$dest/$(basename "$file")"
    cp -r "$file" "$dest/"
    info "Copied $(basename "$file") to $dest/"
  done
done

# -----------------------------
# Install Scripts (Fuzzel)
# -----------------------------
info "Installing Fuzzel scripts..."
for script in docker-menu emoji-picker switch-theme; do
  src="$DOTFILES_DIR/scripts/$script"
  if [ -f "$src" ]; then
    cp "$src" "$LOCAL_BIN/"
    chmod +x "$LOCAL_BIN/$script"
    info "Installed $script to $LOCAL_BIN/"
  else
    warn "Script $script not found in $DOTFILES_DIR/scripts/"
  fi
done

# -----------------------------
# Themes
# -----------------------------
info "Installing themes..."
for theme in "$DOTFILES_DIR/themes/"*; do
  if [ -d "$theme" ]; then
    cp -r "$theme" "$THEMES_DIR/"
    info "Installed theme $(basename "$theme")"
  fi
done

# -----------------------------
# Starship
# -----------------------------
info "Setting up Starship prompt..."
FISH_CONFIG="$HOME/.config/fish/config.fish"
if ! grep -q 'starship init' "$FISH_CONFIG"; then
  echo 'starship init fish | source' >>"$FISH_CONFIG"
  info "Added Starship initialization to Fish config"
fi

# -----------------------------
# Fonts (optional)
# -----------------------------
info "Installing Nerd Fonts (optional, required for icons)..."
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.3/CaskaydiaCove.zip"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
curl -Lo /tmp/caskaydia.zip "$NERD_FONT_URL"
unzip -o /tmp/caskaydia.zip -d "$FONT_DIR"
fc-cache -fv
info "Fonts installed and font cache updated."

# -----------------------------
# Done
# -----------------------------
info "Dotfiles installation complete!"
echo -e "\033[1;32m[✔] All configs, scripts, and themes installed.\033[0m"
echo "You can launch Fuzzel scripts like: docker-menu, emoji-picker, switch-theme"
echo "Restart your shell or run 'starship init fish | source' to apply the prompt."
