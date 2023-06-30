#!/usr/bin/env sh

volume=(
  slider.background.drawing=off
  update_freq=3
  script="$PLUGIN_DIR/volume.sh"
)

sketchybar --add slider volume right 100 \
  --set volume "${volume[@]}" \
  --subscribe volume volume_change
