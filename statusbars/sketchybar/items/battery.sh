#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketcybar/icons.sh"
source "$HOME/.config/sketchybar/vars.sh"

battery_details=(
  background.corner_radius=12
  background.padding_left=5
  background.padding_right=10
  icon.background.height=2
  icon.background.y_offset=-12
)

sketchybar --add item battery right \
  --set battery update_freq=1 \
  script="$PLUGIN_DIR/battery.sh" \
  --subscribe   battery           mouse.entered                  \
  mouse.exited                   \
  mouse.exited.global            \
  \
  --add         item              battery.details popup.battery  \
  --set         battery.details   "${battery_details[@]}"
