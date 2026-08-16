#!/usr/bin/env bash
# =============================================================================
# Dotfiles Mosaic Config Deployer
# Description: Safely copy, move, or symlink dotfiles configurations
# Supports: Hyprland-Dots and Niri-Dots configurations
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
# Setup Directories
# -----------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
BACKUP_DIR="$HOME/.config-backups"

mkdir -p "$CONFIG_DIR"
mkdir -p "$LOCAL_BIN"
mkdir -p "$BACKUP_DIR"

# -----------------------------
# Backup Routine
# -----------------------------
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        local ts
        ts=$(date +"%Y%m%d%H%M%S")
        local base
        base=$(basename "$target")
        local backup_dest="$BACKUP_DIR/${base}.bak.${ts}"
        
        info "Backing up existing: ${CYAN}$target${NC} to ${YELLOW}$backup_dest${NC}"
        mv "$target" "$backup_dest"
    fi
}

# -----------------------------
# Deployment Routine
# -----------------------------
deploy_item() {
    local src="$1"
    local dest="$2"
    local method="$3" # "symlink", "copy", "move"

    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
        warn "Source path does not exist, skipping: $src"
        return
    fi

    # Ensure target parent directory exists
    mkdir -p "$(dirname "$dest")"

    # Check if target already exists
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        # If method is symlink and destination is already a symlink pointing to source, we are done
        if [ "$method" = "symlink" ] && [ -L "$dest" ]; then
            local current_link
            current_link=$(readlink -f "$dest" || true)
            local target_link
            target_link=$(readlink -f "$src" || true)
            if [ "$current_link" = "$target_link" ]; then
                success "Already linked: $dest"
                return
            fi
        fi
        
        # Otherwise, run the backup
        backup_if_exists "$dest"
    fi

    # Execute deployment
    case "$method" in
        symlink)
            ln -sf "$src" "$dest"
            success "Created link: $dest -> $src"
            ;;
        copy)
            cp -r "$src" "$dest"
            success "Copied: $src -> $dest"
            ;;
        move)
            mv "$src" "$dest"
            success "Moved: $src -> $dest"
            ;;
    esac
}

# -----------------------------
# Configuration Handlers
# -----------------------------
deploy_hyprland() {
    local method="$1"
    info "Deploying Hyprland-Dots configuration..."
    
    # 1. Deploy everything from Hyprland-Dots/.config
    local config_src="$DOTFILES_DIR/Hyprland-Dots/.config"
    if [ -d "$config_src" ]; then
        # Loop through all files/directories in .config (including hidden ones, excluding . and ..)
        find "$config_src" -maxdepth 1 -mindepth 1 | while read -r item; do
            local base
            base=$(basename "$item")
            deploy_item "$item" "$CONFIG_DIR/$base" "$method"
        done
    fi

    # 2. Deploy scripts to ~/.local/bin
    local scripts_src="$DOTFILES_DIR/Hyprland-Dots/scripts"
    if [ -d "$scripts_src" ]; then
        find "$scripts_src" -maxdepth 1 -mindepth 1 | while read -r item; do
            local base
            base=$(basename "$item")
            deploy_item "$item" "$LOCAL_BIN/$base" "$method"
            chmod +x "$LOCAL_BIN/$base" 2>/dev/null || true
        done
    fi

    # 3. Deploy themes
    local themes_src="$DOTFILES_DIR/Hyprland-Dots/themes"
    if [ -d "$themes_src" ]; then
        find "$themes_src" -maxdepth 1 -mindepth 1 | while read -r item; do
            local base
            base=$(basename "$item")
            deploy_item "$item" "$CONFIG_DIR/themes/$base" "$method"
        done
    fi

    # 4. Deploy wallis (wallpapers)
    local wallis_src="$DOTFILES_DIR/Hyprland-Dots/wallis"
    if [ -d "$wallis_src" ]; then
        find "$wallis_src" -maxdepth 1 -mindepth 1 | while read -r item; do
            local base
            base=$(basename "$item")
            deploy_item "$item" "$CONFIG_DIR/wallis/$base" "$method"
        done
    fi

    # Initialize default theme (Tokyo Night)
    if [ -f "$LOCAL_BIN/switch-theme" ]; then
        info "Initializing default Hyprland theme: Tokyo Night..."
        bash "$LOCAL_BIN/switch-theme" "Tokyo Night" || warn "Could not initialize theme. Theme assets might be missing."
    fi
}

deploy_niri() {
    local method="$1"
    info "Deploying Niri-Dots configuration..."

    local niri_src="$DOTFILES_DIR/Niri-Dots"
    if [ ! -d "$niri_src" ]; then
        warn "Niri-Dots folder not found in repository."
        return
    fi

    # 1. Directories that go into ~/.config/
    local dirs=(
        alacritty btop fish fuzzel ghostty gtk-3.0 gtk-4.0 hyprlock
        neofetch niri nvim ranger spicetify swaync themes tmux vicinae wallis waybar
    )
    for folder in "${dirs[@]}"; do
        deploy_item "$niri_src/$folder" "$CONFIG_DIR/$folder" "$method"
    done

    # 2. Files that go into ~/.config/
    local config_files=(
        starship.base.toml starship.toml starship_palette.toml
    )
    for file in "${config_files[@]}"; do
        deploy_item "$niri_src/$file" "$CONFIG_DIR/$file" "$method"
    done

    # 3. Files that go into ~/ (home directory)
    local home_files=(
        .bash_profile .bashrc
    )
    for file in "${home_files[@]}"; do
        deploy_item "$niri_src/$file" "$HOME/$file" "$method"
    done

    # Ensure executable permissions on Niri scripts and themes
    find "$CONFIG_DIR/niri/scripts" -type f -exec chmod +x {} + 2>/dev/null || true
    find "$CONFIG_DIR/themes" -name "*.sh" -exec chmod +x {} + 2>/dev/null || true

    # Initialize default theme (Tokyo Night)
    if [ -f "$CONFIG_DIR/themes/theme-changer.sh" ]; then
        info "Initializing default Niri theme: Tokyo Night..."
        bash "$CONFIG_DIR/themes/theme-changer.sh" "Tokyo Night" || warn "Could not initialize theme. Theme assets might be missing."
    fi
}

# -----------------------------
# Main Logic
# -----------------------------
main() {
    echo -e "${CYAN}"
    echo "================================================="
    echo "       🍱 DOTFILES MOSAIC CONFIG DEPLOYER 🍱     "
    echo "================================================="
    echo -e "${NC}"

    echo "Select which configurations to deploy:"
    echo "  1) Niri-Dots (Ubuntu optimized)"
    echo "  2) Hyprland-Dots (Arch optimized)"
    echo "  3) Both (Niri + Hyprland)"
    echo "  4) Cancel"
    read -p "Select option [1-4]: " config_choice

    if [ "$config_choice" = "4" ]; then
        info "Deployment cancelled."
        exit 0
    fi

    echo -e "\nSelect deployment method:"
    echo -e "  1) ${GREEN}Symlink${NC} (Recommended: keeps files linked to this git repo)"
    echo -e "  2) ${YELLOW}Copy${NC} (Duplicate config files to target directories)"
    echo -e "  3) ${RED}Move${NC} (Move configs to target directories - files will be deleted from repo)"
    echo "  4) Cancel"
    read -p "Select option [1-4]: " method_choice

    local method=""
    case "$method_choice" in
        1) method="symlink" ;;
        2) method="copy" ;;
        3)
            method="move"
            warn "You selected 'Move'. This will delete the configurations from your local git clone folder!"
            read -p "Are you absolutely sure you want to proceed with MOVE? [y/N]: " confirm_move
            if [[ ! "$confirm_move" =~ ^[Yy]$ ]]; then
                error "Move deployment cancelled."
            fi
            ;;
        *)
            info "Deployment cancelled."
            exit 0
            ;;
    esac

    # Perform deployment
    if [ "$config_choice" = "1" ] || [ "$config_choice" = "3" ]; then
        deploy_niri "$method"
    fi

    if [ "$config_choice" = "2" ] || [ "$config_choice" = "3" ]; then
        deploy_hyprland "$method"
    fi

    echo -e "\n${GREEN}=================================================${NC}"
    echo -e "${GREEN}      ✔ CONFIGURATIONS DEPLOYED SUCCESSFULLY!    ${NC}"
    echo -e "${GREEN}=================================================${NC}"
    info "If any original files were overwritten, backups are stored in: ${YELLOW}$BACKUP_DIR${NC}"
    
    if [ "$config_choice" = "1" ] || [ "$config_choice" = "3" ]; then
        echo -e "\nTo activate a theme in Niri-Dots, run:"
        echo -e "  ${CYAN}bash ~/.config/themes/theme-selector.sh${NC}"
    fi
}

main
