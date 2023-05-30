#!/usr/bin/env bash

POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

git_bell=(
  associated_space=1
  update_freq=180
  icon.font="$ICON_FONT:Bold:15.0"
  icon="$BELL"
  label=$LOADING
  popup.align=right
  script="$PLUGIN_DIR/github.sh"
  click_script="$POPUP_CLICK_SCRIPT"
)

github_template=(
  drawing=off
  background.corner_radius=12
  background.padding_left=7
  background.padding_right=7
  icon.background.height=2
  icon.background.y_offset=-12
)

packages=(
  position=right
  update_freq=30
  script="$PLUGIN_DIR/package_monitor.sh"
  label=?
  icon="􀐛 "
  associated_space=1
  click_script="$POPUP_CLICK_SCRIPT"
  popup.align=right
  pop.height=20
)

package_template=(
  background.corner_radius=12
  background.padding_left=5
  background.padding_right=10
  click_script="sketchybar --set brew popup.drawing=off"
)

sketchybar --add event brew_upgrade                      \
           --add event git_push                          \
           --add item  github.bell right                 \
           --set github.bell "${git_bell[@]}"            \
           --subscribe github.bell mouse.entered         \
                                   mouse.exited          \
                                   mouse.exited.global   \
           --add item github.template popup.github.bell  \
           --set github.template "${github_template[@]}" \
           --add item packages.bell right                  \
           --set packages.bell "${packages[@]}"            \
           --subscribe packages.bell brew_upgrade          \
                                     mouse.entered         \
                                     mouse.exited          \
                                     mouse.exited.global   \
                                     mouse.clicked         \
            --add item packages.details popup.packages.bell \
            --set packages.details "${package_template[@]}" \
           --add bracket package_monitor              \
                         github.bell                  \
                         packages.bell                     \
           --set package_monitor background.drawing=on
