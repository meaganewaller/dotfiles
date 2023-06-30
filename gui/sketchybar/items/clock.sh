#!/bin/bash

clock=(
  update_freq=10
  label.padding_left=5
  label.padding_right=5
  align=center
  script="$PLUGIN_DIR/clock.sh"
  label.font.size=10.5
  background.height=$BACKGROUND_HEIGHT
  background.corner_radius=11
)

sketchybar --add item clock right \
  --set clock "${clock[@]}"
