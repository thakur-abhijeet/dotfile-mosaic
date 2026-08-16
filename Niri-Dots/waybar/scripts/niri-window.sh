#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         niri-window.sh                   ║
# ║         Abhijeet · Waybar · Niri         ║
# ╚══════════════════════════════════════════╝
# Outputs focused window title for Waybar custom module
# Note: niri/window module handles this natively now —
# this script is kept as a fallback for custom/window use

set -euo pipefail

title=$(niri msg --json focused-window 2>/dev/null |
    jq -r '.title // empty')

if [[ -z "$title" ]]; then
    echo ""
else
    # Truncate to 30 chars
    echo "${title:0:30}"
fi
