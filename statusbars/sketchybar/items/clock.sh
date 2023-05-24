#!/bin/bash
#
sketchybar --add item clock right \
	--set clock update_freq=10 \
	label.color="$FOAM" \
	label.padding_left=5 \
	label.padding_right=5 \
	align=center \
	script="$PLUGIN_DIR/clock.sh" \
  label.font="$LABEL_FONT:Nerd Font Mono:10.5" \
	background.height=26 \
	background.corner_radius=11
