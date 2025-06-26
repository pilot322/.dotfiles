#!/bin/bash

# This script automates the launching of specific applications
# on predefined i3 workspaces.

# --- Configuration ---
# Define your workspace names (optional, but good for readability)
WS_BROWSER_1="2:Web1"
WS_BROWSER_2="6:Web2"
WS_TOOLS="3:DevTools"
WS_COMMUNICATIONS="4:Chat"

# Define specific URLs for Firefox (optional)
FIREFOX_URL_1="https://www.google.com"
FIREFOX_URL_2="https://www.github.com"

# --- Script Logic ---

# Workspace 2: Firefox (with specific website)
echo "Setting up workspace $WS_BROWSER_1..."
i3-msg "workspace \"$WS_BROWSER_1\""
# Ensure the workspace is ready before launching the app
sleep 0.5
# Removed --no-startup-id here, as it's for i3 config's exec
firefox "$FIREFOX_URL_1" &
# Adding a small delay for i3 to process the window
sleep 1

# Workspace 6: Another Firefox (with a different specific website)
echo "Setting up workspace $WS_BROWSER_2..."
i3-msg "workspace \"$WS_BROWSER_2\""
sleep 0.5
# Removed --no-startup-id here
firefox "$FIREFOX_URL_2" &
sleep 1

# Workspace 3: Nemo and DBeaver
echo "Setting up workspace $WS_TOOLS..."
i3-msg "workspace \"$WS_TOOLS\""
sleep 0.5
# Removed --no-startup-id here
nemo &
# Give Nemo a moment to open before DBeaver
sleep 2
# Removed --no-startup-id here
dbeaver &
sleep 1

# Workspace 4: Ferdium
echo "Setting up workspace $WS_COMMUNICATIONS..."
i3-msg "workspace \"$WS_COMMUNICATIONS\""
sleep 0.5
# Removed --no-startup-id here
ferdium &
sleep 1

# Return to workspace 1 after setting everything up (optional)
echo "Returning to workspace 1..."
i3-msg "workspace 1"

echo "Workspace setup complete!"




