#!/usr/bin/env bash

SPACE_NAMES=(main code chat mail gtd doc media tool scratch)
check_bar() {
  LEN=$(sketchybar --query bar | jq -r '.items' | jq -r "map(select(.==\"$1\")) | length")
  echo $LEN
}

len=$(yabai -m query --spaces --display 1 | jq '[.[]] | length')
i=1
while [ "${i}" -le "$len" ]; do
  SPNAME=${SPACE_NAMES[$i-1]}
  if [[ $(check_bar $SPNAME) -eq 0 ]]
  then
    sketchybar --add space $SPNAME left \
      --set $SPNAME associated_display=1 \
      associated_space=$i \
      script="~/.config/sketchybar/plugins/space.sh" \
      click_script="yabai -m space --focus $i" \
      --subscribe $SPNAME space_change display_change
  fi
  i=$((i + 1))
done

MORE_DISPLAYS=$(yabai -m query --displays |  jq '.[1:]' | jq '.[].index')
for did in ${MORE_DISPLAYS[@]}
do
  # SPACE 7+: OTHER ICON
  SPACE_IDS=$(yabai -m query --displays --display $did | jq '.spaces' |jq -r '.[]')
  for sid in ${SPACE_IDS[@]}
  do
    SPNAME=${SPACE_NAMES[$sid-1]}
    if [ $(check_bar $SPNAME) -eq 0 ]
    then
      sketchybar --add space $SPNAME left \
        --set $SPNAME associated_display=$did \
        associated_space=$sid \
        script="~/.config/sketchybar/plugins/space.sh" \
        click_script="yabai -m space --focus $sid" \
        --subscribe $SPNAME space_change display_change
    fi
  done
done
