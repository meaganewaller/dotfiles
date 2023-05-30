#!/usr/bin/env bash

if [ -z "$4" ]; then
  NAME=$(echo item$RANDOM)
else
  NAME=$4
fi

if [ "$3" = "left" ]; then
  transition=(
    icon.font="$ICON_FONT:SemiBold:16.0"
    icon.padding_left=2
    icon.padding_right=-6
    icon=""
    icon.color=$1
    background.padding_left=0
    background.color=$2
  )
  sketchybar --add item $NAME right \
    --set $NAME "${transition[@]}"
else
  transition=(
    icon.font="$ICON_FONT:SemiBold:16.0"
    icon.padding_left=-6
    icon.padding_right=6
    icon=""
    icon.color=$1
    background.padding_left=0
    background.color=$2
  )
  sketchybar --add item $NAME left \
    --set $NAME "${transition[@]}"
fi
