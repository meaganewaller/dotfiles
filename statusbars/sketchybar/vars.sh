#!/bin/bash

export ICON_FONT="FiraCode Nerd Font Mono"
export LABEL_FONT="BigBlueTermPlus Nerd Font"
export DEFAULT_ICON_FONT="$ICON_FONT:Regular:14.0"
export DEFAULT_LABEL_FONT="$LABEL_FONT:Regular:14.0"
export PADDINGS=3
export SEGMENT_SPACING=13
export SHADOW=on
export SPACE_CLICK_SCRIPT="yabai -m space --focus \$SID" # The script that is run for clicking on space components
export SEGMENT_HEIGHT=28 # The height of the segments
export SEGMENT_SPACING=13 # The spacing between the segments
export SEGMENT_BORDER_WIDTH=0 # Width of the borders for segments
export CORNER_RADIUS=4 # Roundness of the segments
export POPUP_BORDER_WIDTH=2
export POPUP_CORNER_RADIUS=4
export HAS_BATTERY=$(if [ "$(pmset -g batt | grep "Battery")" = "" ]; then echo "false"; else echo "true"; fi)

