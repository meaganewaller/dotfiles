#!/usr/bin/env bash

mic=(
  update_freq=3
  script="bash $PLUGIN_DIR/mic.sh"
  click_script="bash $PLUGIN_DIR/mic_click.sh"
  icon.font.size=16.0
)

sketchybar --add item mic right \
  --set mic "${mic[@]}"
