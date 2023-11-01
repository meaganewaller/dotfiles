#!/bin/bash

SPACE_ICONS=( 󰖟       )

sid=0
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))

  space=(
    associated_space=$sid
    background.border_color="$BAR_BORDER_COLOR"
    background.color="$OVERLAY"
    background.drawing=off
    icon.font.family="$ICON_FONT"
    icon.font.size=18
    icon.highlight_color="$ACTIVE_COLOR"
    icon.padding_left=5
    icon.padding_right=5
    icon="${SPACE_ICONS[i]}"
    label.color="$ACTIVE_COLOR"
    label.drawing=off
    label.font="$DEFAULT_LABEL_FONT"
    label.highlight_color="$ACTIVE_COLOR"
    label.padding_right=20
    label.y_offset=-1
    padding_left=2
    padding_right=2
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done

spaces=(
  background.border_color="$BAR_BORDER_COLOR"
  background.border_width=1
)

separator=(
  icon=􀆊
  icon.font="$DEFAULT_ICON_FONT"
  padding_left=8
  padding_right=0
  label.drawing=off
  associated_display=active
  click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color="$LOVE"
)

sketchybar --add bracket spaces '/space\..*/'  \
           --set spaces "${spaces[@]}"         \
           --add item separator left           \
           --set separator "${separator[@]}"
