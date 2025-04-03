#!/bin/bash

xrandr --output HDMI-A-0 --right-of eDP --auto --rotate left
xrandr --fb 3000x1920
feh --bg-scale ~/Downloads/ninja.webp
feh --bg-scale ~/Downloads/ed10.png --output eDP --bg-scale ~/Downloads/chainsaw.webp --output HDMI-A-0

