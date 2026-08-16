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

### Prerequisites

Ensure you have the respective compositors installed:
- **For Niri**: `niri`
- **For Hyprland**: `hyprland`

### Installation

#### Hyprland (Arch/CachyOS)
Use the provided installation script for a quick setup:
```bash
cd Hyprland-Dots
chmod +x install.sh
./install.sh
```

#### Niri (Ubuntu)
Niri configurations are modular. You can symlink the directories to your `~/.config`:
```bash
ln -s $(pwd)/Niri-Dots/niri ~/.config/niri
```

---

## 🎨 Acknowledgments
- **Theme**: [Tokyo Night](https://github.com/folke/tokyonight.nvim)
- **Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Notifications**: [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)

---
*Maintained with ❤️ by [Abhijeet Thakur](https://github.com/Abhijeetthakur433)*