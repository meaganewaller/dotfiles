#!/bin/sh

DESIRED_SPACES_PER_DISPLAY=4
CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"

echo "current spaces: $CURRENT_SPACES"

DELTA=0
while read -r line
do
  LAST_SPACE="$(echo "${line##* }")"
  LAST_SPACE=$(($LAST_SPACE+$DELTA))
  EXISTING_SPACE_COUNT="$(echo "$line" | wc -w)"
  MISSING_SPACES=$(($DESIRED_SPACES_PER_DISPLAY - $EXISTING_SPACE_COUNT))
  if [ "$MISSING_SPACES" -gt 0 ]; then
    echo "missing spaces: $MISSING_SPACES"
    for i in $(seq 1 $MISSING_SPACES)
    do
      yabai -m space --create "$LAST_SPACE"
      echo "last space: $LAST_SPACE"
      LAST_SPACE=$(($LAST_SPACE+1))
    done
  elif [ "$MISSING_SPACES" -lt 0 ]; then
    echo "missing spaces: $MISSING_SPACES"
    for i in $(seq 1 $((-$MISSING_SPACES)))
    do
      echo "last space: $LAST_SPACE"
      yabai -m space --destroy "$LAST_SPACE"
      LAST_SPACE=$(($LAST_SPACE-1))
    done
  fi
  DELTA=$(($DELTA+$MISSING_SPACES))
  echo "delta: $DELTA"
done <<< "$CURRENT_SPACES"

echo "create_spaces.sh finished"

sketchybar --trigger space_change --trigger windows_on_spaces
