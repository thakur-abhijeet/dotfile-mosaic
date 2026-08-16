#!/usr/bin/env bash
# =============================================================================
# Dotfiles Mosaic Package Installer
# Description: Smart, interactive package installer for Niri & Hyprland
# Supports: Arch Linux, Debian/Ubuntu
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

# -----------------------------
# Style & Colors
# -----------------------------
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[✔]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# -----------------------------
# Distro Detection
# -----------------------------
detect_distro() {
    if [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/debian_version ] || [ -f /etc/lsb-release ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# -----------------------------
# Installation Functions
# -----------------------------
install_arch() {
    local pkgs=("$@")
    if [ ${#pkgs[@]} -eq 0 ]; then return; fi
    info "Installing Arch packages: ${pkgs[*]}"
    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
}

install_aur() {
    local pkgs=("$@")
    if [ ${#pkgs[@]} -eq 0 ]; then return; fi
    if command -v yay >/dev/null 2>&1; then
        info "Installing AUR packages via yay: ${pkgs[*]}"
        yay -S --needed --noconfirm "${pkgs[@]}"
    elif command -v paru >/dev/null 2>&1; then
        info "Installing AUR packages via paru: ${pkgs[*]}"
        paru -S --needed --noconfirm "${pkgs[@]}"
    else
        warn "No AUR helper (yay/paru) detected. Please install manually: ${pkgs[*]}"
    fi
}

install_debian() {
    local pkgs=("$@")
    if [ ${#pkgs[@]} -eq 0 ]; then return; fi
    info "Installing Debian/Ubuntu packages: ${pkgs[*]}"
    sudo apt-get update -y
    sudo apt-get install -y "${pkgs[@]}"
}

install_niri_ubuntu() {
    info "Adding DankLinux PPA for Niri..."
    if ! command -v add-apt-repository >/dev/null 2>&1; then
        sudo apt-get update -y
        sudo apt-get install -y software-properties-common
    fi
    if ! grep -q "avengemedia/danklinux" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo add-apt-repository -y ppa:avengemedia/danklinux
    fi
    if ! grep -q "avengemedia/dms" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo add-apt-repository -y ppa:avengemedia/dms
    fi
    sudo apt-get update -y
    sudo apt-get install -y niri
    success "Niri installed successfully!"
}

install_starship() {
    if command -v starship >/dev/null 2>&1; then
        success "Starship is already installed."
        return
    fi
    info "Installing Starship shell prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    success "Starship installed."
}

install_fastfetch_ubuntu() {
    if command -v fastfetch >/dev/null 2>&1; then
        success "Fastfetch is already installed."
        return
    fi
    info "Adding Fastfetch PPA..."
    if ! grep -q "zhangsongcui3371/fastfetch" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    fi
    sudo apt-get update -y
    sudo apt-get install -y fastfetch
    success "Fastfetch installed."
}

install_ghostty_ubuntu() {
    if command -v ghostty >/dev/null 2>&1; then
        success "Ghostty is already installed."
        return
    fi
    info "Installing Ghostty via community PPA/repository..."
    if curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh | bash; then
        success "Ghostty installed."
    else
        warn "Could not install Ghostty automatically. You may need to build from source or install via Snap: sudo snap install ghostty"
    fi
}

install_vicinae() {
    if command -v vicinae >/dev/null 2>&1; then
        success "Vicinae is already installed."
        return
    fi
    info "Installing Vicinae launcher..."
    mkdir -p "$HOME/.local/bin"
    
    local download_url
    # Try fetching the latest github release URL for the AppImage
    download_url=$(curl -s https://api.github.com/repos/vicinaehq/vicinae/releases/latest | jq -r '.assets[] | select(.name | endswith(".AppImage")) | .browser_download_url' | head -n 1 || true)
    
    if [ -n "$download_url" ] && [ "$download_url" != "null" ] && [ "$download_url" != "" ]; then
        info "Downloading Vicinae from: $download_url"
        curl -Lo "$HOME/.local/bin/vicinae" "$download_url"
        chmod +x "$HOME/.local/bin/vicinae"
        success "Vicinae installed successfully to ~/.local/bin/vicinae"
    else
        warn "Could not retrieve Vicinae AppImage from GitHub API. Trying direct download..."
        # Fallback to a guessed URL or guide the user
        local fallback_url="https://github.com/vicinaehq/vicinae/releases/latest/download/vicinae.AppImage"
        if curl -Lo "$HOME/.local/bin/vicinae" "$fallback_url"; then
            chmod +x "$HOME/.local/bin/vicinae"
            success "Vicinae installed successfully to ~/.local/bin/vicinae (fallback)"
        else
            warn "Could not download Vicinae automatically. Please install manually from https://github.com/vicinaehq/vicinae/releases"
        fi
    fi
}

install_fonts() {
    info "Installing CaskaydiaCove Nerd Font (required for icons)..."
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.3/CaskaydiaCove.zip"
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    
    local temp_zip="/tmp/caskaydia.zip"
    if curl -Lo "$temp_zip" "$font_url"; then
        unzip -o "$temp_zip" -d "$font_dir"
        rm -f "$temp_zip"
        if command -v fc-cache >/dev/null 2>&1; then
            fc-cache -fv >/dev/null
        fi
        success "CaskaydiaCove Nerd Font installed and font cache updated."
    else
        warn "Failed to download CaskaydiaCove Nerd Font."
    fi
}

# -----------------------------
# Main Logic
# -----------------------------
main() {
    echo -e "${PURPLE}"
    echo "================================================="
    echo "         🍱 DOTFILES MOSAIC INSTALLER 🍱         "
    echo "================================================="
    echo -e "${NC}"
    
    DISTRO=$(detect_distro)
    info "Detected system distribution: ${CYAN}$DISTRO${NC}"
    
    if [ "$DISTRO" = "unknown" ]; then
        warn "Unsupported or unknown distribution. You can try installing dependencies manually."
        read -p "Do you want to continue anyway? [y/N]: " continue_anyway
        if [[ ! "$continue_anyway" =~ ^[Yy]$ ]]; then
            error "Exiting setup."
        fi
    fi
    
    echo -e "\nWhat desktop configurations do you want to target?"
    echo "  1) Niri-Dots dependencies & application (Ubuntu optimized)"
    echo "  2) Hyprland-Dots dependencies & application (Arch optimized)"
    echo "  3) Full Suite (Niri + Hyprland + shared utilities)"
    echo "  4) Cancel"
    
    read -p "Select option [1-4]: " option
    
    if [ "$option" = "4" ]; then
        info "Installation cancelled."
        exit 0
    fi
    
    # Prompt for optional installations
    read -p "Would you like to install Nerd Fonts? [y/N]: " opt_fonts
    read -p "Would you like to install Vicinae Launcher? (AppImage) [y/N]: " opt_vicinae
    
    # Prepare package lists
    local common_pkgs_arch=(git curl unzip fzf bat jq wl-clipboard wayland-protocols fish alacritty tmux neovim ranger btop fastfetch)
    local common_pkgs_deb=(git curl unzip fzf bat jq wl-clipboard wayland-protocols fish alacritty tmux neovim ranger btop)
    
    local niri_pkgs_arch=(niri swaync waybar lxqt-policykit-agent fuzzel)
    local niri_pkgs_deb=(swaynotificationcenter waybar lxqt-policykit-agent policykit-1-gnome fuzzel)
    
    local hypr_pkgs_arch=(hyprland kitty fuzzel hyprlock)
    local hypr_pkgs_deb=(kitty fuzzel) # Hyprland and hyprlock are usually built or installed separately on Ubuntu
    
    # Execution
    if [ "$DISTRO" = "arch" ]; then
        # Install common packages
        install_arch "${common_pkgs_arch[@]}"
        
        # Install environment packages
        if [ "$option" = "1" ] || [ "$option" = "3" ]; then
            install_arch "${niri_pkgs_arch[@]}"
            if [[ "$opt_vicinae" =~ ^[Yy]$ ]]; then
                install_aur "vicinae-bin"
            fi
        fi
        
        if [ "$option" = "2" ] || [ "$option" = "3" ]; then
            install_arch "${hypr_pkgs_arch[@]}"
        fi
        
        # Arch Ghostty
        info "Installing Ghostty via AUR..."
        install_aur "ghostty" || warn "Could not install ghostty via AUR. Please check AUR helper status."
        
    elif [ "$DISTRO" = "debian" ]; then
        # Install common packages
        install_debian "${common_pkgs_deb[@]}"
        install_starship
        install_fastfetch_ubuntu
        
        # Install environment packages
        if [ "$option" = "1" ] || [ "$option" = "3" ]; then
            install_debian "${niri_pkgs_deb[@]}"
            install_niri_ubuntu
            if [[ "$opt_vicinae" =~ ^[Yy]$ ]]; then
                install_vicinae
            fi
        fi
        
        if [ "$option" = "2" ] || [ "$option" = "3" ]; then
            install_debian "${hypr_pkgs_deb[@]}"
            warn "Hyprland is optimized for Arch. You may need to manually build Hyprland and hyprlock from source on Debian/Ubuntu."
        fi
        
        # Install Ghostty on Debian/Ubuntu
        install_ghostty_ubuntu
    fi
    
    # Install Nerd Fonts if selected
    if [[ "$opt_fonts" =~ ^[Yy]$ ]]; then
        install_fonts
    fi
    
    echo -e "\n${GREEN}=================================================${NC}"
    echo -e "${GREEN}      ✔ PACKAGE INSTALLATION COMPLETED!         ${NC}"
    echo -e "${GREEN}=================================================${NC}"
    echo "Next: run './deploy-configs.sh' to setup your configuration files."
}

main
