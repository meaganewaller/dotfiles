#!/usr/bin/env sh

update() {
	sketchybar --set volume slider.background.drawing="$1" \
		slider.percentage="$INFO" \
    slider.highlight_color=0xff8aadf4 \
		slider.background.height=10 \
		slider.background.corner_radius=3 \
    slider.background.color=0xff494d64
}

case "$SENDER" in
"routine" | "forced")
	update off
	;;
"volume" | "volume_change")
	update on
	;;
esac
