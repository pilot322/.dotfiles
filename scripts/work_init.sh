#!/bin/bash

comms

# Open Firefox on workspace 6
i3-msg workspace 6
firefox gemini.google.com &>/dev/null &

# Open Spotify on workspace 8
i3-msg workspace 8
spotify &>/dev/null &
