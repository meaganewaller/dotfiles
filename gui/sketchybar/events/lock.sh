#!/usr/bin/env sh

sketchybar --add event lock "com.apple.screenIsLocked"
sketchybar --add event unlock "com.apple.screenIsUnlocked"
sketchybar --add item animator left
sketchybar --set animator drawing=off
sketchybar --set animator updates=on
sketchybar --set animator script="$PLUGIN_DIR/wake.sh"
sketchybar --subscribe animator lock unlock
