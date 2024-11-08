#!/usr/bin/env sh

sketchybar --add    item      discord right \
    --set    discord   background.image=/Users/meagan/.config/sketchybar/assets/discord-logo.png \
    background.image.scale=0.0.15 \
    background.drawing=on \
    background.padding_right=5 \
    background.padding_left=-2

sketchybar --add   alias "Control Center,WiFi" right \
    --set  "Control Center,WiFi" update_freq=1 \
    icon.drawing=off \
    label.drawing=off \
    background.padding_left=-12 \
    background.padding_right=-8


sketchybar --add alias "SystemUIServer,TMMenuExtra" right \
    --set "SystemUIServer,TMMenuExtra" update_freq=1 \
    icon.drawing=off \
    label.drawing=off \
    background.padding_left=-12 \
    background.padding_right=-8

sketchybar --add alias "Control Center,Sound" right \
    --set "Control Center,Sound" update_freq=1 \
    label.font="$FONT:Regular:18.0" \
    background.padding_right=-14 \
    background.padding_left=-10

sketchybar --add item obs right \
    --set obs background.image=/Users/meagan/.config/sketchybar/assets/obs-logo.png \
    background.image.scale=0.028 \
    background.drawing=on

