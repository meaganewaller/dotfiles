#!/usr/bin/env bash

MUSIC_EVENT="com.apple.Music.playerInfo"

sketchybar --add event music_changed $MUSIC_EVENT \
  --add item music center \
  label.padding_right=10 \
  icon.font.size=20 \
  --set music script="$PLUGIN_DIR/music.sh" \
  click_script="$PLUGIN_DIR/music_click" \
  --subscribe music music_changed
