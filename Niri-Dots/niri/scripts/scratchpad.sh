#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         scratchpad.sh                    ║
# ║         Abhijeet · Ubuntu + Niri         ║
# ╚══════════════════════════════════════════╝
# Toggles a floating Ghostty scratchpad terminal

set -euo pipefail

# =============================================================================
# Config
# =============================================================================
SCRATCHPAD_NAME="niri-scratchpad"

# =============================================================================
# Guards
# =============================================================================
for cmd in niri jq ghostty; do
    if ! command -v "$cmd" &>/dev/null; then
        notify-send --urgency=critical "scratchpad" "'$cmd' is not installed."
        exit 1
    fi
done

# =============================================================================
# Helpers
# =============================================================================

# Get window ID in one jq pass — avoids querying niri msg twice
get_window_id() {
    niri msg --json windows \
        | jq -r ".[] | select(.title == \"$SCRATCHPAD_NAME\") | .id" \
        | head -1
}

# =============================================================================
# Toggle or Spawn
# =============================================================================
WINDOW_ID=$(get_window_id)

if [[ -n "$WINDOW_ID" ]]; then
    # Window exists — toggle float state then focus it
    niri msg action toggle-window-floating --id "$WINDOW_ID"
    niri msg action focus-window           --id "$WINDOW_ID"
else
    # No scratchpad running — spawn one
    # Window rules in rules.kdl handle: floating, size, position
    ghostty \
        --title="$SCRATCHPAD_NAME" \
        --class="$SCRATCHPAD_NAME" &
    disown
fi
