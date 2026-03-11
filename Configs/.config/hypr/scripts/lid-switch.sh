#!/bin/bash

# Lid switch handler for multiple external monitors
# Work: DP-1 (3440x1440@60)
# Home: HDMI-A-1 (3440x1440@100)

MONITORS=$(hyprctl monitors all -j)

has_monitor() {
    echo "$MONITORS" | grep -q "\"name\": \"$1\""
}

case "$1" in
    closed)
        # Lid closed: disable internal, use whichever external is connected
        if has_monitor "DP-1"; then
            hyprctl keyword monitor "DP-1,3440x1440@60,0x0,1"
        fi
        if has_monitor "HDMI-A-1"; then
            hyprctl keyword monitor "HDMI-A-1,3440x1440@100,0x0,1"
        fi
        hyprctl keyword monitor "eDP-1,disable"
        ;;
    open)
        # Lid open: enable internal, disable whichever external is connected
        hyprctl keyword monitor "eDP-1,1920x1200@60,0x0,1.5"
        if has_monitor "DP-1"; then
            hyprctl keyword monitor "DP-1,disable"
        fi
        if has_monitor "HDMI-A-1"; then
            hyprctl keyword monitor "HDMI-A-1,disable"
        fi
        ;;
esac
