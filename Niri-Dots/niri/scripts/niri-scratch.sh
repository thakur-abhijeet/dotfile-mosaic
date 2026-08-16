#!/usr/bin/env bash
# ╔══════════════════════════════════════════╗
# ║         niri-scratch.sh                  ║
# ║         Generic Scratchpad Manager       ║
# ╚══════════════════════════════════════════╝

set -euo pipefail

SCRATCH_WORKSPACE="___scratchpad___"

move_to_scratchpad() {
    # Move focused window to the hidden scratchpad workspace
    niri msg action move-window-to-workspace "$SCRATCH_WORKSPACE"
    # Ensure it's floating so it appears on top when summoned
    # Note: We don't know if it's already floating, but niri doesn't have "set-floating true"
    # only "toggle-window-floating". We can check with jq.
    IS_FLOATING=$(niri msg --json focused-window | jq -r '.is_floating')
    if [[ "$IS_FLOATING" == "false" ]]; then
        niri msg action toggle-window-floating
    fi
}

toggle_scratchpad() {
    # Find all windows on the scratchpad workspace
    WINDOWS=$(niri msg --json windows | jq -c ".[] | select(.workspace_name == \"$SCRATCH_WORKSPACE\")")
    
    if [[ -z "$WINDOWS" ]]; then
        # Nothing in scratchpad, maybe spawn the default one?
        ~/.config/niri/scripts/scratchpad.sh
        return
    fi

    # Get current workspace name/id
    CURRENT_WS=$(niri msg --json workspaces | jq -r '.[] | select(.is_focused == true) | .name // .id')

    # If we find any scratchpad window on the current workspace, hide all of them
    ON_CURRENT=$(niri msg --json windows | jq -r ".[] | select(.workspace_name == \"$CURRENT_WS\" and .is_floating == true) | .id")
    
    # This logic is a bit complex for a shell script. 
    # Let's simplify: Toggle focus to the scratchpad workspace.
    # Niri's "named workspaces" are actually quite good for this.
    
    # Check if any window from scratchpad is currently focused
    FOCUSED_WS=$(niri msg --json focused-window | jq -r '.workspace_name')
    
    if [[ "$FOCUSED_WS" == "$SCRATCH_WORKSPACE" ]]; then
        niri msg action focus-workspace-previous
    else
        niri msg action focus-workspace "$SCRATCH_WORKSPACE"
    fi
}

case "${1:-}" in
    move)
        move_to_scratchpad
        ;;
    toggle)
        toggle_scratchpad
        ;;
    *)
        echo "Usage: $0 {move|toggle}"
        exit 1
        ;;
esac
