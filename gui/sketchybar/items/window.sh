#!/usr/bin/env sh

WINDOW_SCRIPT='sketchybar --set $NAME label="$INFO"'

window=(
  script="$WINDOW_SCRIPT"
  padding_left=0
  label.font.size=12.0
  associated_display=active
)

sketchybar --add item window left
sketchybar --set window "${window[@]}"
sketchybar --subscribe window front_app_switched
