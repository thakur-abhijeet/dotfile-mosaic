# 🐧 Dotfiles Mosaic

A curated collection of dotfiles for Niri and Hyprland, tailored for different Linux ecosystems. This repository houses optimized configurations for a productive and aesthetically pleasing Wayland-based desktop environment.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Wayland](https://img.shields.io/badge/Display%20Server-Wayland-blue)](https://wayland.freedesktop.org/)

---

## 🏗️ Architecture

The repository is divided into two main configuration sets, each optimized for a specific distribution flavor:

### 🌌 Niri-Dots (Optimized for Ubuntu)
A scrollable-tiling Wayland compositor configuration focused on smoothness and productivity.
- **OS Focus**: Ubuntu / Debian-based systems.
- **Key Components**: [Niri](https://github.com/YaLTeR/niri), Waybar, SwayNC, Fish Shell.
- **Highlights**: Modular KDL configuration, smooth animations, and Tokyo Night aesthetic.

### 🍱 Hyprland-Dots (Optimized for Arch/CachyOS)
A highly customizable, dynamic tiling Wayland compositor configuration.
- **OS Focus**: Arch Linux / CachyOS.
- **Key Components**: [Hyprland](https://hyprland.org/), Waybar, Wofi/Fuzzel, Starship.
- **Highlights**: Performance-oriented, modular `.conf` structure, and integrated theme switcher.

---

## 📂 Project Structure

```text
.
├── Niri-Dots/           # Niri configurations (Ubuntu optimized)
│   ├── niri/            # Core Niri configs & scripts
│   ├── waybar/          # Status bar layout & styles
│   └── ...              # App-specific configs (Alacritty, Fish, etc.)
├── Hyprland-Dots/       # Hyprland configurations (Arch/CachyOS optimized)
│   ├── .config/hypr/    # Core Hyprland modular configs
│   ├── scripts/         # Utility scripts (theme switchers, etc.)
│   └── install.sh       # Automated installation script
└── README.md            # You are here
```

---

## 🚀 Getting Started

The repository provides centralized scripts at the root level to simplify installation and configuration deployment:

1. **`install.sh`**: Installs all required packages, compositors, and tools based on your Linux distribution (supports Arch/CachyOS and Debian/Ubuntu).
2. **`deploy-configs.sh`**: Handles copying, moving, or linking (recommended) the configuration files to their appropriate system folders (e.g., `~/.config`) with safety backup creation.

### Setup Process

#### 1. Install Dependencies
Run the installer script to select your target desktop environment and download its dependencies:
```bash
chmod +x install.sh
./install.sh
```

#### 2. Deploy Configuration Files
Once packages are installed, deploy the configurations to your active system folders:
```bash
chmod +x deploy-configs.sh
./deploy-configs.sh
```
*Note: We highly recommend selecting the **Symlink** option during deployment, as it links files from the repository to your active config directories, allowing git to track any changes you make in real-time.*

## 🎨 Themes & Customization

The configuration features built-in support for theme switching with a selection of 20+ themes, including **all 19 official Omarchy themes**:

| | Themes List | |
|---|---|---|
| 🌌 Tokyo Night | 🐱 Catppuccin | 🏢 Lumon |
| 🪐 Ethereal | 🌲 Everforest | 📦 Gruvbox |
| 🪨 Miasma | 💻 Hackerman | 🐉 Osaka Jade |
| 🌊 Kanagawa | ❄️ Nord | 🖤 Matte Black |
| 🕳️ Vantablack | ☕ Ristretto | 📼 Retro 82 |
| ☀️ Flexoki Light | 🌹 Rose Pine | 🥛 Catppuccin Latte |
| ⚪ White | | |

### Selecting a Theme
You can dynamically list and apply themes using the interactive theme selector:
```bash
# Launch the interactive theme selector (requires Fuzzel)
bash ~/.config/themes/theme-selector.sh

# Or apply a theme directly by name
bash ~/.config/themes/theme-changer.sh "Tokyo Night"
```

### Upstream Theme Synchronizer
A developer utility `fetch_omarchy_themes.py` is included in `Niri-Dots/themes/`. It connects directly to the upstream Omarchy repository, fetches the latest `colors.toml` files, parses the colors, and updates the generator configurations.
To refresh themes from upstream:
```bash
cd Niri-Dots/themes
python3 fetch_omarchy_themes.py
./generate_themes.sh
```

---

## 💅 Acknowledgments
- **Themes**: Upstream palettes fetched from [Omarchy Linux](https://omarchy.org)
- **Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Notifications**: [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)

---
*Maintained with ❤️ by [Abhijeet Thakur](https://github.com/Abhijeetthakur433)*