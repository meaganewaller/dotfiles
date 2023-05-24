#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item volume right \
	--set volume script="$PLUGIN_DIR/volume.sh" \
  update_freq=5 \
  icon.color=$IRIS \
  icon.padding_left=10 \
  label.color=$IRIS \
  label.padding_right=10 \
  background.color=$OVERLAY \
  background.height=26 \
  background.corner_radius=9 \
  background.padding_right=5 \
	--subscribe volume volume_change
