#!/usr/bin/env bash

divider=(
	background.color="$SURFACE"
	background.border_color="$OVERLAY"
	background.border_width=2
	background.padding_left=5
	background.padding_right=10
)
sketchybar --add bracket status brew github.bell bluetooth.alias wifi.alias battery \
	--set status "${divider[@]}"
