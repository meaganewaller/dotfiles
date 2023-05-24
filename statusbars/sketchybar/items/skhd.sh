#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

skhd=(
	icon.color="$GOLD"
	background.color="$SURFACE"
	background.border_color="$OVERLAY"
	background.border_width=2
	icon.padding_left=10
	icon.padding_right=5
	drawing=off
	icon="N"
)

sketchybar --add item skhd left \
	--set skhd "${skhd[@]}"
