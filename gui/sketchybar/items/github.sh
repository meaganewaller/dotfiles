#!/usr/bin/env sh

POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

github_bell=(
  update_freq=180
  icon=$BELL
  icon.font="$ICON_FONT:Bold:15.0"
  label=$LOADING
  popup.align=right
  script="$PLUGIN_DIR/github.sh"
  click_script="$POPUP_CLICK_SCRIPT"
  associated_display=1
)

github_template=(
  drawing=off
  background.corner_radius=12
  padding_left=7
  padding_right=7
  icon.background.height=2
  icon.background.y_offset=-12
  associated_display=1
)

sketchybar --add item github.bell right                 \
           --set github.bell "${github_bell[@]}"        \
           --subscribe github.bell  mouse.entered       \
                                    mouse.exited        \
                                    mouse.exited.global \
           --add item github.template popup.github.bell \
           --set github.template "${github_template[@]}"
