#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$HOME/.config/sketchybar/colors.sh" # Loads all defined colors

# FIXME: Running an osascript on an application target opens that app
# This sleep is needed to try and ensure that theres enough time to
# quit the app before the next osascript command is called. I assume
# com.apple.iTunes.playerInfo fires off an event when the player quits
# so it imediately runs before the process is killed
sleep 1

APP_STATE=$(pgrep -x Music)
if [[ ! $APP_STATE ]]; then
  sketchybar -m --set "$NAME" drawing=off
  exit 0
fi

PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ $PLAYER_STATE = "stopped" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

TITLE=$(osascript -e 'tell application "Music" to get name of current track')
ARTIST=$(osascript -e 'tell application "Music" to get artist of current track')
# ALBUM=$(osascript -e 'tell application "Music" to get album of current track')
LOVED=$(osascript -l JavaScript -e "Application('Music').currentTrack().favorited()")

COLOR=$ICON_COLOR

if [[ "$LOVED" = 'true' ]]; then
  ICON="💘"
  FONT_SIZE=20
else
  [[ $PLAYER_STATE == "paused" ]] && ICON="􀊆" || ICON="􀊄"
  FONT_SIZE=16
fi

sketchybar -m --set "$NAME" icon="$ICON" \
  --set "$NAME" label="${ARTIST} - ${TITLE}" \
  icon.font.family="$FONT" \
  icon.font.size="$FONT_SIZE" \
  icon.color="$COLOR" \
  label.font="Victor Mono:Italic:16.0" \
  label.color="$LABEL_COLOR" \
  drawing=on
