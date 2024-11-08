#!/bin/bash

space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)
icon_mode=$(echo $NAME | cut -d"_" -f2)

if [ "$icon_mode" = "$yabai_mode" ]; then
  sketchybar --set "$NAME" icon.highlight="on"
else
  sketchybar --set "$NAME" icon.highlight="off"
fi

##source "$HOME/.config/sketchybar/icons.sh"
##yabai_mode=$(yabai -m query --spaces --space | jq -r '.type')
##icon=""
##
##case $layout in
##  stack)
##    yabai -m space --layout stack
##    icon=$YABAI_STACK
##    ;;
##  float)
##    yabai -m space --layout float
##    icon=$YABAI_FLOAT
##    ;;
##  bsp)
##    yabai -m space --layout bsp
##    icon=$YABAI_GRID
##    ;;
##esac
##
##sketchybar --set $NAME icon=$icon
