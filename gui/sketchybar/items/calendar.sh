#!/bin/bash

calendar=(
  icon="📅"
  icon.font.size=10
  label.color="$GV_PURPLE"
  icon.padding_right=0
  label.align=right
  label.padding_right=0
  label.padding_left=2
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
  click_script="$PLUGIN_DIR/zen.sh"
)

sketchybar --add item calendar right \
  --set calendar "${calendar[@]}" \
  --subscribe calendar system_woke

