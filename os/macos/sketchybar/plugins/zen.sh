#!/bin/bash

zen_on() {
  sketchybar --set calendar icon.drawing=off \
             --set separator drawing=off \
             --set front_app drawing=off \
             --set brew drawing=off \
             --set github.bell drawing=off
             # --set volume_icon drawing=off \
             # --set music.anchor drawing=off \
             # --set spotify.play updates=off \
             # --set volume drawing=off \
}

zen_off() {
  sketchybar --set calendar icon.drawing=on \
             --set separator drawing=on \
             --set front_app drawing=on \
             --set brew drawing=on \
             --set github.bell drawing=on
}

if [ "$1" = "on" ]; then
  zen_on
elif [ "$1" = "off" ]; then
  zen_off
else
  if [ "$(sketchybar --query github.bell | jq -r ".geometry.drawing")" = "on" ]; then
    zen_on
  else
    zen_off
  fi
fi

