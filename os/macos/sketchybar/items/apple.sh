#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"

sketchybar --add item apple.logo left              \
           --set apple.logo icon="$APPLE"          \
                 icon.font="$ICON_FONT"            \
                 icon.padding_left=10              \
                 label.drawing=off                 \
                 background.padding_left=5         \
                 background.padding_right=5        \
                 icon.padding_right=5              \
                 label.font="$TEXT_FONT"           \
                 popup.background.border_width=2   \
                 popup.background.corner_radius=3  \
                 click_script="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add item apple.preferences popup.apple.logo \
           --set apple.preferences icon="$PREFERENCES"   \
                                   label="Preferences"   \
                                   click_script="open -a 'System Preferences';
                                                 sketchybar --set apple.logo popup.drawing=off" \
           --add item apple.activity popup.apple.logo    \
           --set apple.activity icon="$ACTIVITY"         \
                                label.padding_left=3     \
                                label.padding_right=3    \
                                label="Activity"         \
                                click_script="open -a 'Activity Monitor';
                                              sketchybar --set apple.logo popup.drawing=off" \
           --add item apple.lock popup.apple.logo        \
           --set apple.lock icon=? \
                            label="About this Mac"       \
                            click_script="open -a 'System information';
                                          sketchybar --set apple.logo popup.drawing=off"
