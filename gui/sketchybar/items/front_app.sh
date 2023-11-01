#!/bin/bash

FRONT_APP_SCRIPT='sketchybar --set $NAME label="$INFO"'

yabai=(
  associated_display=active
  icon.color="$GOLD"
  icon.font="$DEFAULT_ICON_FONT"
  icon.width=30
  icon="$YABAI_GRID"
  label.drawing=off
  script="$PLUGIN_DIR/yabai.sh"
  updates=on
)

front_app=(
  associated_display=active
  icon.drawing=off
  padding_left=0
  label.color="$GOLD"
  label.font="$DEFAULT_LABEL_FONT"
  script="$FRONT_APP_SCRIPT"
)

sketchybar --add event window_focus            \
           --add event windows_on_spaces       \
           --add item yabai left               \
           --set yabai "${yabai[@]}"           \
           --subscribe yabai window_focus      \
                             windows_on_spaces \
                             mouse.clicked     \
                                               \
           --add item front_app left           \
           --set front_app "${front_app[@]}"   \
           --subscribe front_app front_app_switched
