#!/bin/bash

# ╔══════════════════════════════════════════╗
# ║         Niri — Pro Monitor Switcher      ║
# ║         Dynamic Mode & Position          ║
# ╚══════════════════════════════════════════╝

CONFIG_DIR="$HOME/.config/niri/configs"
MONITOR_FILE="$CONFIG_DIR/monitor.kdl"

# --- Functions ---

get_modes() {
    local output=$1
    # Extract modes for the specific output
    niri msg outputs | sed -n "/($output)/,/Output/p" | grep -E '^[[:space:]]{4}[0-9]' | awk '{print $1}' | sort -ur
}

select_mode() {
    local output=$1
    local modes=$(get_modes "$output")
    echo "$modes" | fuzzel -d -p "$output Resolution: "
}

# --- Main Logic ---

# 1. Choose General Setup
SETUP=$(echo -e "󰍹  Dual Monitor\n󰋦  External Only\n󰄄  Laptop Only" | fuzzel -d -p "Select Setup: ")

case "$SETUP" in
    *"Dual Monitor"*)
        # 1a. Choose Position
        POS=$(echo -e "󰄄  External on LEFT\n󰄄  External on RIGHT" | fuzzel -d -p "Position: ")
        
        # 1b. Choose Resolutions
        EXT_MODE=$(select_mode "HDMI-A-1")
        LAP_MODE=$(select_mode "eDP-1")
        
        [ -z "$EXT_MODE" ] || [ -z "$LAP_MODE" ] && exit 0

        # Extract widths for positioning (e.g. 1920x1080 -> 1920)
        EXT_WIDTH=$(echo "$EXT_MODE" | cut -d'x' -f1)
        LAP_WIDTH=$(echo "$LAP_MODE" | cut -d'x' -f1)

        if [[ "$POS" == *"LEFT"* ]]; then
            # External Left (x=0), Laptop Right (x=EXT_WIDTH)
            CONFIG="output \"eDP-1\" {
    mode \"$LAP_MODE\"
    scale 1.0
    position x=$EXT_WIDTH y=0
}
output \"HDMI-A-1\" {
    mode \"$EXT_MODE\"
    scale 1.0
    position x=0 y=0
}"
        else
            # Laptop Left (x=0), External Right (x=LAP_WIDTH)
            CONFIG="output \"eDP-1\" {
    mode \"$LAP_MODE\"
    scale 1.0
    position x=0 y=0
}
output \"HDMI-A-1\" {
    mode \"$EXT_MODE\"
    scale 1.0
    position x=$LAP_WIDTH y=0
}"
        fi
        ;;

    *"External Only"*)
        EXT_MODE=$(select_mode "HDMI-A-1")
        [ -z "$EXT_MODE" ] && exit 0
        CONFIG="output \"eDP-1\" {
    off
}
output \"HDMI-A-1\" {
    mode \"$EXT_MODE\"
    scale 1.0
    position x=0 y=0
}"
        ;;

    *"Laptop Only"*)
        LAP_MODE=$(select_mode "eDP-1")
        [ -z "$LAP_MODE" ] && exit 0
        CONFIG="output \"eDP-1\" {
    mode \"$LAP_MODE\"
    scale 1.0
    position x=0 y=0
}
output \"HDMI-A-1\" {
    off
}"
        ;;

    *)
        exit 0
        ;;
esac

# Write to config and reload
echo "$CONFIG" > "$MONITOR_FILE"
niri msg action reload-config
notify-send "Monitor Config" "Applied: $SETUP" -i display
