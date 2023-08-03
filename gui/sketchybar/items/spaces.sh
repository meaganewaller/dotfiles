#!/usr/bin/env bash

sketchybar --add item space_mode left \
   --set space_mode      script="$PLUGIN_DIR/yabai_space.sh"            \
                                 icon.font="$FONT:Bold:16.0"                    \
                                 label.drawing=off                              \
                                 updates=on                                     \
           --add event           space_mode_change                              \
           --subscribe space_mode space_change space_mode_change                \
                                                                                \
           --clone space_label_template label_template                          \
           --add space          space_template left                             \
           --set space_template icon.highlight_color=0xff$COLOR_FOAM         \
                                label.drawing=off                               \
                                drawing=off                                     \
                                updates=on                                      \
                                associated_display=1                            \
                                label.font="$FONT:Black:13.0"                   \
                                icon.color=0xff$COLOR_IRIS                      \
                                icon.font="$FONT:Bold:17.0"                     \
                                script="$PLUGIN_DIR/space.sh"                   \
                                click_script="$SPACE_CLICK_SCRIPT"              \
                                                                                \
           --add item           yabai_spaces left                               \
           --set yabai_spaces   drawing=off                                     \
                                updates=on                                      \
                                script="$PLUGIN_DIR/yabai_spaces.sh"            \
           --add event          display_number_changed                          \
           --add event          space_number_changed                            \
           --subscribe yabai_spaces display_number_changed space_number_changed \
                                                                                \
           --clone space_separator sep_template                                 \
           --set space_separator drawing=on                                     \

# SPACE_ICONS=("" "󰖟" "" "" "" "" " " "" "")
# SPACE_NAMES=("productivity" "browser" "social" "email" "reference" "code" "media" "feed" "system" "vm")
#
# sid=0
# spaces=()
# for i in "${!SPACE_ICONS[@]}"
# do
#   sid=${SPACE_NAMES[i]}
#
#   space=(
#     associated_space="$sid"
#     icon="${SPACE_ICONS[i]}"
#     icon.padding_left=5
#     icon.padding_right=8
#     icon.font.size=9.0
#     padding_left=2
#     padding_right=2
#     label.padding_right=20
#     label.font.family="$LABEL_FONT"
#     label.font.style="Regular"
#     label.font.size=9.0
#     label.background.height=26
#     label.background.drawing=on
#     label.background.corner_radius=8
#     label.drawing=off
#     script="$PLUGIN_DIR/space.sh"
#   )
#
#   sketchybar --add space space.$sid left \
#              --set space.$sid "${space[@]}" \
#              --subscribe space.$sid mouse.entered mouse.exited \
#              --subscribe space.$sid mouse.clicked
# done
#
# spaces=(
#   background.drawing=on
#   background.border_width=2
# )
#
# sketchybar --add bracket spaces '/space\..*/' \
#            --set         spaces "${spaces[@]}"
