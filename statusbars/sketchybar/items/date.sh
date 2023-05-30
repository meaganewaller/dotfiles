#!/bin/bash

date=(
  label.font.size=11.0
  update_freq=10
  script="$PLUGIN_DIR/date.sh"
)

sketchybar --add item date right \
  --set date "${date[@]}"

# source "$ITEM_DIR/calendar.sh"
# source "$ITEM_DIR/ical.sh"
