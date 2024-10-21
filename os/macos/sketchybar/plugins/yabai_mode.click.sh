#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"

layout=$(yabai -m query --spaces --space | jq -r '.type')
icon=""

case $layout in
  stack)
    yabai -m space --layout stack
    icon=$YABAI_STACK
    ;;
  float)
    yabai -m space --layout float
    icon=$YABAI_FLOAT
    ;;
  bsp)
    yabai -m space --layout bsp
    icon=$YABAI_GRID
    ;;
esac

sketchybar --set $NAME icon="$icon"
