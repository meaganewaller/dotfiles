#!/usr/bin/env sh

clock=(
  update_freq=20
  icon.drawing=off
  label.padding_right=20
  script="$PLUGIN_DIR/time.sh"
)

date=(
  update_freq=60
  position=right
  drawing=on
  label.color="$SEGMENT_BACKGROUND_COLOR"
  background.color="$IRIS"
  background.padding_right=5
  background.padding_left=5
  background.height=26
  script="$PLUGIN_DIR/date.sh"
)

sketchybar --add item calendar.time right \
  --set calendar.time "${clock[@]}" \
  --clone calendar.date label_template \
  --set calendar.date "${date[@]}" \
  --add bracket calendar \
            calendar.time \
            calendar.date \
  --set calendar.background.drawing=on
