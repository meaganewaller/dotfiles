#!/bin/bash

yabai_status=(
  script="$PLUGIN_DIR/yabai_window.sh"
  icon.font="$ICON_FONT:SemiBold:16.0"
  label.drawing=off
  updates=on
)

yabai_stack=(
  script="$PLUGIN_DIR/yabai_stack.sh"
  icon.font="$ICON_FONT:SemiBold:16.0"
  updates=on
)

# skhd=(
#   icon.padding_left=$PADDINGS
#   icon.padding_left=$PADDINGS
#   label.width=20
#   label.padding_left=5
#   label.padding_right=5
#   label.font.size=15.0
#   script="$PLUGIN_DIR/skhd.sh"
# )
#
# wm_bracket=(
#   background.border_width=$SEGMENT_BORDER_WIDTH
#   background.corner_radius=$CORNER_RADIUS
#   background.height=$SEGMENT_HEIGHT
#   background.padding_left=20
#   background.padding_right=20
#   icon.padding_left=$PADDINGS
#   icon.padding_right=$PADDINGS
# )

sketchybar --add item window.yabai_status left \
           --set window.yabai_status "${yabai_status[@]}" \
           --add event window_mode_change \
           --subscribe window.yabai_status front_app_switched window_mode_change mouse.clicked \
           --add item window.yabai_stack left \
           --set window.yabai_stack "${yabai_stack[@]}" \
           --subscribe window.yabai_stack front_app_switched window_mode_change \
           --clone window.label label_template \
           --set window.label label=sys \
           drawing=on \
           script="$PLUGIN_DIR/window_title.sh" \
           --subscribe window.label front_app_switched \
           --add bracket window \
           window.yabai_stack \
           window.yabai_status \
           window.label \
           --set window background.drawing=on
#   background.color=0xffD08770 \
#   background.height=20 \
#   background.padding_left=5 \
#   icon.font="FuraCode Nerd Font:Regular:10.0"
#
# sketchybar -m --add item yabai_mode left \
#               --add event mode_change \
#               --set yabai_mode update_freq=3 \
#                                script="~/.config/sketchybar/plugins/yabai_mode.sh" \
#                                click_script="~/.config/sketchybar/plugins/yabai_mode_click.sh" \
#               --subscribe yabai_mode space_change mode_change
#
# sketchybar -m --add item yabai_float left \
#               --add event window_focus \
#               --add event float_change \
#               --set yabai_float script="~/.config/sketchybar/plugins/yabai_float.sh" \
#                     click_script="~/.config/sketchybar/plugins/yabai_float_click.sh" \
#                     lazy=off \
#               --subscribe yabai_float front_app_switched window_focus float_change \
#
#
#
# # sketchybar --add event skhd_mode_change \
# #            --add event window_focus \
# #            --add event windows_on_spaces \
# #            --add event window_mode_change \
# #            --add item  window.yabai_status left \
# #            --set       window.yabai_status "${yabai_status[@]}" \
# #            --add event window_mode_change \
# #            --subscribe window.yabai_status windows_on_spaces window_focus front_app_switched window_mode_change mouse.clicked \
# #            --add item  window.yabai_stack left \
# #            --set       window.yabai_stack "${yabai_stack[@]}" \
# #            --subscribe window.yabai_stack windows_on_spaces window_focus front_app_switched window_mode_change \
# #            --add item  window.skhd left \
# #            --set       window.skhd "${skhd[@]}" \
# #            --add bracket window \
# #                          window.yabai_stack \
# #                          window.yabai_status \
# #                          window.skhd \
# #           --set window "${wm_bracket[@]}" \
# #           --subscribe window.skhd skhd_mode_change \
