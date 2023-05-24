#!/usr/bin/env bash

sleep 1

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/vars.sh"

APP_STATE=$(pgrep -x Music)
if [[ ! $APP_STATE ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ $PLAYER_STATE == "stopped" ]]; then
  sketchybar --set "$NAME" drawing=on
  exit 0
fi

TITLE=$(osascript -e 'tell application "Music" to get name of current track')
ARTIST=$(osascript -e 'tell application "Music" to get artist of current track')
ALBUM=$(osascript -e 'tell application "Music" to get album of current track')
LOVED=$(osascript -l JavaScript -e "Application('Music').currentTrack().loved()")

if [[ $LOVED == "true" ]]; then
  ICON=
else
  [[ $PLAYER_STATE == "paused" ]] && ICON= || ICON=
fi

sketchybar -m --set $NAME icon="$ICON"       \
  --set $NAME label="${ARTIST} - ${TITLE}"    \
  icon.font="$ICON_FONT:Bold:18.0" \
  label.font="Victor Mono:Italic:16.0" \
  label.color="$IRIS" \
  icon.color="$FOAM" \
  drawing=on



# TRACK=$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null)
# ARTIST=$(osascript -e 'tell application "Music" to album artist of current track as string' 2>/dev/null)
# LOVED=$(osascript -l JavaScript -e "Application('Music').currentTrack().loved()")
# # fall back to artist, if album artist is unavailable, or generic
# if [[ -z "$ARTIST" ]] || [[ "$ARTIST" = "Various Artists" ]]; then
#   ARTIST=$(osascript -e 'tell application "Music" to artist of current track as string' 2>/dev/null)
# fi
#
# if [[ $LOVED == "true" ]]; then
#   ICON=
# else
#   [[ $STATE == "paused" ]] && ICON= || ICON=
# fi
#
# if [[ "$STATE" = "playing" ]]; then
#   LABEL="$ARTIST - $TRACK"
# else
#   LABEL=""
# fi
#
# sketchybar --set "$NAME"  \
#   icon="$ICON" \
#   label="$LABEL" \
#   icon.font="$ICON_FONT:Nerd Font Mono:18.0" \
#   label.font="Victor Mono:Italic:16.0" \
#   label.color="$ROSE" \
#   icon.color="$LOVE" \
#   icon.drawing=on \
#   label.drawing=on \
# # else
# #   sketchybar --set "$NAME" label=""
# # fi
