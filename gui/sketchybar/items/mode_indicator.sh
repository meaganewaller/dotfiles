#!/usr/bin/env sh
# shellcheck disable=all

source "$HOME/.config/sketchybar/icons.sh"

sketchybar   --add item               mode_indicator center             \
             --set mode_indicator     drawing=off                       \
                                      label.color="$MUTED"              \
                                      label.font="$FONT:14.0"      \
                                      background.padding_left=15        \
                                      background.padding_right=15
