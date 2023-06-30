#!/usr/bin/env bash

SPACE_ICONS=("􀋃 " "􀡅 " "􀘲 " "􀈠 " "􀷾 " "􀦇 " "􀊄 " "􀤉 " "􀤑 " "􀀁" "􀀁" "􀀁" "􀀁" "􀀁")

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))

  space=(
    associated_space=$sid
    icon=${SPACE_ICONS[i]}
    icon.padding_left=5
    icon.padding_right=8
    icon.font.size=9.0
    padding_left=2
    padding_right=2
    label.padding_right=20
    label.font.family="$LABEL_FONT"
    label.font.style="Regular"
    label.font.size=9.0
    label.background.height=26
    label.background.drawing=on
    label.background.corner_radius=8
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done

spaces=(
  background.drawing=on
  background.border_width=2
)

sketchybar --add bracket spaces '/space\..*/' \
           --set         spaces "${spaces[@]}"
