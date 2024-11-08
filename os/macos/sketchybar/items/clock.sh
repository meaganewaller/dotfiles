#!/bin/bash

sketchybar --add item clock right \
    --set clock            \
    script="$PLUGIN_DIR/clock.sh" \
    update_freq=10  \
    lazy=true \
    background.padding_right=4
