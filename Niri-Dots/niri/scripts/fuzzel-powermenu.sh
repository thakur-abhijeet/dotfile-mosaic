#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         fuzzel-powermenu.sh              ║
# ║         Abhijeet · Ubuntu + Niri         ║
# ╚══════════════════════════════════════════╝
# Fuzzel-based power menu

set -euo pipefail

# =============================================================================
# Guards
# =============================================================================
for cmd in fuzzel notify-send; do
    if ! command -v "$cmd" &>/dev/null; then
        notify-send --urgency=critical "powermenu" "'$cmd' is not installed."
        exit 1
    fi
done

# =============================================================================
# Menu
# =============================================================================
OPTIONS="󰌾  Lock
󰍃  Logout
󰤄  Suspend
󰑐  Reboot
󰐥  Shutdown"

SELECTED=$(printf "%s" "$OPTIONS" \
    | fuzzel --dmenu \
             --prompt="Power ❯ " \
             --width=22 \
             --lines=5) || exit 0

[[ -z "$SELECTED" ]] && exit 0

# =============================================================================
# Confirm destructive actions
# =============================================================================
confirm() {
    local msg="$1"
    REPLY=$(printf "Yes\nNo" \
        | fuzzel --dmenu \
                 --prompt="$msg ❯ " \
                 --width=22 \
                 --lines=2) || exit 0
    [[ "$REPLY" == "Yes" ]]
}

# =============================================================================
# Execute
# =============================================================================
case "$SELECTED" in
    *Lock)
        hyprlock
        ;;
    *Logout)
        confirm "Logout?" && niri msg action quit
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *Reboot)
        confirm "Reboot?" && systemctl reboot
        ;;
    *Shutdown)
        confirm "Shutdown?" && systemctl poweroff
        ;;
    *)
        notify-send "powermenu" "Unknown option: $SELECTED"
        exit 1
        ;;
esac
