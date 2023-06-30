#!/usr/bin/env bash

source "$HOME/.config/sketchybar/vars.sh"

front_app=(
  icon.drawing=on
  icon.padding_left=10
  icon.font="$DEFAULT_LABEL_FONT"
  label.font="$DEFAULT_ICON_FONT"
  icon.align="center"
  script="$PLUGIN_DIR/front_app.sh"
  associated_display=active
)

front_app_bracket=(
  background.corner_radius=5
  background.height=25
  associated_display=active
)

separator=(
  icon=􀆊
  icon.font="$ICON_FONT:SemiBold:16.0"
  padding_left=$PADDINGS
  padding_right=$PADDINGS
  label.drawing=off
  associated_display=active
  click_script='yabai -m space --create && sketchybar --trigger space_change'
)

sketchybar --add event window_title_changed  \
           --add event window_focused        \
           --add item front_app left         \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched \
                                 window_title_changed \
                                 window_focused \
           --add bracket front_app_bracket front_app \
           --set front_app_bracket "${front_app_bracket[@]}" \
           --add item separator left \
           --set separator "${separator[@]}"
