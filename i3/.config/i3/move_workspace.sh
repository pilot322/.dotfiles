#!/bin/bash

# Define monitor names
LEFT_MONITOR="eDP"
RIGHT_MONITOR="HDMI-A-0"

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

