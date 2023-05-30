#!/usr/bin/env sh

data=$(yabai -m query --windows --window)

window_title=$(echo $data | jq -r '.title')
app=$(echo $data | jq -r '.app')

[ "${#window_title}" -gt 40 ] && window_title="$(echo $window_title | head -c 40)…"

sketchybar --set $NAME icon="$app"
