#!/bin/bash

sketchybar --add item date right \
  --set date \
  label.font="$LABEL_FONT:Nerd Font Mono:11.0" \
  update_freq=1 \
  script="$PLUGIN_DIR/date.sh"

# source "$ITEM_DIR/calendar.sh"
# source "$ITEM_DIR/ical.sh"
