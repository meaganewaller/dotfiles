#!/bin/bash

terminal=(
  icon=":terminal:"
  icon.color=$WHITE
  icon.font="sketchybar-app-font:Regular:15.0"
  icon.padding_right=8
  icon.y_offset=0
  padding_right=10
  padding_left=8
  click_script='open -a "kitty"'
)

left_bracket=(
  background.color=$PRIMARY_1
  background.corner_radius=6
  background.border_width=2
  background.border_color=$PRIMARY_1
  background.height=24
)

sketchybar --add item terminal left \
           --set terminal "${terminal[@]}"

sketchybar --add bracket left_bracket spaces_bracket terminal \
           --set left_bracket "${left_bracket[@]}"
