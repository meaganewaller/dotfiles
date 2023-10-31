#!/bin/bash

SPACE_NAMES=(main code chat mail gtd doc media tool scratch)
SPACE_IDS=$(yabai -m query --spaces | jq -r '.[].index')

for sid in ${SPACE_IDS[@]}
do
  EXIST_BARS=$(sketchybar --query bar | jq '.items' | jq -r '.[]')
  SPNAME=${SPACE_NAMES[$sid-1]}
  if [[ "${EXIST_BARS[@]}" =~ "$SPNAME" ]]
  then
    space_applist=$(/usr/local/bin/yabai -m query --windows --space $sid | jq -r '.[] ' | jq -r '.app | select( . !="System Settings" )' | awk '!a[$0]++'| paste -sd "|" -)
    if [[ $space_applist != "" ]]; then
      # sketchybar -m --set $SPNAME label="$space_applist"
    else
      # sketchybar -m --set $SPNAME label="-"
    fi
  fi
done
