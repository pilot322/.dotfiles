#!/bin/bash

# Get connected monitors from xrandr
MONITORS=($(xrandr --query | grep " connected" | awk '{print $1}'))

# Check if we have exactly two monitors
if [[ ${#MONITORS[@]} -ne 2 ]]; then
    echo "Error: Expected exactly 2 connected monitors, found ${#MONITORS[@]}"
    exit 1
fi

# Define monitor names
LEFT_MONITOR="${MONITORS[0]}"
RIGHT_MONITOR="${MONITORS[1]}"

# Get active workspace
ACTIVE_WS=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Get active output (monitor)
ACTIVE_OUTPUT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).output')

# Determine target output
if [[ "$ACTIVE_OUTPUT" == "$LEFT_MONITOR" ]]; then
    TARGET_OUTPUT="$RIGHT_MONITOR"
else
    TARGET_OUTPUT="$LEFT_MONITOR"
fi

# Move workspace
i3-msg "workspace $ACTIVE_WS; move workspace to output $TARGET_OUTPUT"
