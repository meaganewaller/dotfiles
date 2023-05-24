#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/vars.sh"
source "$HOME/.config/sketchybar/helper/helper.sh"

SPACE_ICONS=(" " " " " " " " " " " " " " "ﭵ" "" "" "" "" "")

space_details=(
  icon.font="$ICON_FONT:Retina:13.0"
  icon.padding_left=22
  icon.padding_right=22
  icon.highlight_color="$ROSE"
  background.padding_left=-8
  background.padding_right=-8
  background.corner_radius=9
  background.color="$OVERLAY"
  background.drawing=on
  background.height=26
  label.padding_right=33
  label.background.height=26
  label.background.drawing=on
  label.background.corner_radius=9
  label.drawing=off
  script="$PLUGIN_DIR/space.sh"
  click_script="$SPACE_CLICK_SCRIPT"
)

sid=0
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))

  sketchybar 	--add space space.$sid left 			\
              --set       space.$sid associated_space=$sid 			\
                                     icon="${SPACE_ICONS[i]}" 										\
                                     "${space_details[@]}" 															\
              --subscribe space.$sid mouse.clicked
  done

  spaces_bracket=(
  background.color="$SURFACE"
  background.border_color="$SURFACE"
  background.border_width=2
  background.drawing=on
)

sketchybar --add bracket spaces '/space\..*/' \
  --set spaces "${spaces_bracket[@]}"

separator_left=(
  icon=
  icon.font="$ICON_FONT:Regular:13.0"
  background.padding_left=26
  background.padding_right=15
  label.drawing=off
  associated_display=active
  click_script='yabai -m space --create sketchybar --trigger space_change'
  icon.color="$FOAM"
)

sketchybar 	--add item separator_left left 			\
  --set separator_left "${separator_left[@]}"
