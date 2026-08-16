#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         niri-workspaces.sh               ║
# ║         Abhijeet · Waybar · Niri         ║
# ╚══════════════════════════════════════════╝
# Outputs workspace indicators for Waybar custom module
# Note: niri/workspaces module handles this natively now —
# this script is kept as a fallback

set -euo pipefail

FOCUSED="●"
INACTIVE="○"

output=""

while IFS= read -r line; do
    if echo "$line" | grep -q "(focused)"; then
        output="$output $FOCUSED"
    elif echo "$line" | grep -qE "^ [0-9]+:"; then
        output="$output $INACTIVE"
    fi
done < <(niri msg workspaces 2>/dev/null)

echo "${output# }"
