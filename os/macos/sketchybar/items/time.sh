#!/bin/bash

time=(
  script="$PLUGIN_DIR/time.sh"
  icon="⏰"
  icon.color=$YELLOW
  icon.font.size=10
  icon.drawing=on
  label.color=$YELLOW
  icon.padding_left=8
  icon.padding_right=4
  icon.y_offset=0
  label.font="Fira Code:Medium:13.0"
  label.padding_left=4
  label.padding_right=4
  label.y_offset=0
  update_freq=30
)

time_dot=(
  icon=􀀁
  icon.color=$ORANGE
  icon.font.size=6
  icon.padding_right=0
  icon.padding_left=7
  icon.y_offset=0
)

time_bracket=(
  background.color=$TRANSPARENT
  background.border_color=$GV_AQUA
  background.border_width=1
  background.corner_radius=11
  background.y_offset=0
  background.height=24
  background.padding_left=20
  background.padding_right=20
)

sketchybar --add item time_dot right \
           --set time_dot "${time_dot[@]}"

sketchybar --add item time right \
           --set time "${time[@]}" \
           --subscribe time system_woke

sketchybar --add bracket time_bracket time time_dot calendar \
           --set time_bracket "${time_bracket[@]}"

sketchybar --move calendar after time
sketchybar --move time_dot after time
