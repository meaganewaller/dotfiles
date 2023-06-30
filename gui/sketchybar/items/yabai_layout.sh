#!/bin/bash

sketchybar --add item yabai_layout left
sketchybar --set yabai_layout script="$PLUGIN_DIR/yabai_layout.sh" \
  lazy=off \
sketchybar  --subscribe yabai_layout front_app_switched window_focus layout_change
sketchybar  --add item yabai_property left
sketchybar  --set yabai_property script="$PLUGIN_DIR/yabai_property.sh" \
  label.font="$FONT:Nerd Font Mono:12" \
  lazy=off \
  --subscribe yabai_property front_app_switched window_focus property_change

sketchybar -m --add item space_separator left                                         \
  --set space_separator  icon="|"                                         \
  icon.padding_left=15                             \
  label.padding_right=15                           \
  icon.font="$ICON_FONT:Light:15.0"
