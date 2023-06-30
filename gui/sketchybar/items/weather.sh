#!/usr/bin/env bash
sketchybar --add event weather_update

temp=(
  update_freq=900
  script="$PLUGIN_DIR/weather.sh"
)

sketchybar --add item weather right \
  --set weather "${temp[@]}" \
  --subscribe weather system_woke mouse.entered

# sketchybar --add item weather right \
#   --set weather script="$PLUGIN_DIR/weather.sh" \
#   --set weather click_script="$PLUGIN_DIR/weather_clicked.sh" \
#   --set weather label.color="$GOLD" update_freq=600
#
# sketchybar --add item weather.radar popup.weather \
#   --set weather.radar script="$PLUGIN_DIR/radar.sh" \
#   --set weather.radar label.color="$GOLD" update_freq=600
#
# sketchybar --add item weather.details popup.weather \
#   --set weather.details script="$PLUGIN_DIR/weather_details.sh" \
#   --set weather.details updates=when_shown
#   --set weather.details label.color="$GOLD" update_freq=600
