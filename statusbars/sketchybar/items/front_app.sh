#!/usr/bin/env sh

sketchybar --add item front_app left \
  --set front_app \
  --set front_app script="sketchybar --set \$NAME label=\"\$INFO\"" \
  label.color="$GOLD" \
  --subscribe front_app front_app_switched
