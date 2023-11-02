#!/bin/bash

SPACE_ICONS=( 󰖟       )

sid=0
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))

  space=(
    associated_space=$sid
    icon.highlight_color="$ACTIVE_COLOR"
    icon.padding_left=20
    icon.padding_right=15
    icon="${SPACE_ICONS[i]}"
    label.drawing=off
    label.font="sketchybar-app-font:Regular:16.0"
    label.background.height=26
    label.background.drawing=on
    label.background.color=$SUBTLE
    label.background.corner_radius=8
    label.drawing=off
    label.highlight_color="$ACTIVE_COLOR"
    label.padding_right=20
    padding_left=2
    padding_right=2
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done

spaces_bracket=(
  background.color="$OVERLAY"
  background.border_color="$BAR_BORDER_COLOR"
  background.border_width=1
  background.drawing=on
)

separator=(
  associated_display=active
  click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color="$LOVE"
  icon.font="$DEFAULT_ICON_FONT"
  icon=􀆊
  label.drawing=off
  padding_left=15
  padding_right=15
)

sketchybar --add bracket spaces '/space\..*/'  \
           --set spaces "${spaces[@]}"         \
           --add item separator left           \
           --set separator "${separator[@]}"
