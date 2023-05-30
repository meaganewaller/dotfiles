#!/usr/bin/env bash

sketchybar --add alias "MeetingBar,Item-0" right \
           --set "MeetingBar,Item-0" label.font="$ICON_FONT:Regular:12.0" \
           --rename "MeetingBar,Item-0" meeting.alias \
           --set meeting.alias icon.drawing=off \
                               background.padding_right=0 \
                               align=right \
                               # click_script="$PLUGIN_DIR/meeting_click.sh" \
                               # script="$PLUGIN_DIR/meeting.sh" \
                               popup.height=30 \
                               update_freq=1 \
                               associated_display=1 \
                               font="$ICON_FONT:Regular:12.0" \
                               alias.scale=0.75
           # --subscribe meeting.alias mouse.entered \
           #                           mouse.exited \
           #                           mouse.exited.global \
           # --add item meeting.details popup.meeting.alias \
           # --set meeting.details background.corner_radius=12 \
           #                       background.padding_left=5 \
           #                       background.padding_right=10 \
           #                       click_script="sketchybar --set meeting.alias popup.drawing=off"
