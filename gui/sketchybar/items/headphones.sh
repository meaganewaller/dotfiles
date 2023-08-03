#!/usr/bin/env bash
sketchybar --add event bluetooth_change "com.apple.bluetooth.status"
sketchybar --add item headphones right \
  --set headphones icon=" " \
drawing=off \
background.padding_right=1 \
background.padding_left=4 \
script="$PLUGIN_DIR/ble_headset.sh" \
--subscribe headphones bluetooth_change
