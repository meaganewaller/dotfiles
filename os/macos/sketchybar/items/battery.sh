PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)

# if percentage is not empty
if [ -n "$PERCENTAGE" ]; then
    sketchybar --add item battery right \
        --set battery update_freq=3 \
        icon.drawing=off \
        script="$PLUGIN_DIR/power.sh" \
        background.padding_left=0

    sketchybar --add item power_logo right \
        --set power_logo icon= \
        label.drawing=off \
        update_freq=90
fi
