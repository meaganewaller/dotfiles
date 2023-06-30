#!/usr/bin/env bash

sketchybar --add alias "MeetingBar,Item-0" right \
           --set "MeetingBar,Item-0" label.font="$ICON_FONT:Regular:12.0" associated_display=2 \
           --rename "MeetingBar,Item-0" meeting.alias \
           --set meeting.alias icon.drawing=off \
                               background.padding_right=0 \
                               align=right \
                               # click_script="$PLUGIN_DIR/meeting_click.sh" \
                               # script="$PLUGIN_DIR/meeting.sh" \
                               update_freq=1 \
                               font="$ICON_FONT:Regular:12.0" \
                               alias.scale=0.75
