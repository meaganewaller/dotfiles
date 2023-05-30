#!/usr/bin/env bash
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/vars.sh" # Loads all defined icons

PREV_COUNT=$(sketchybar --query brew | jq -r .popup.items | grep ".package*" -c)

render_bar_item() {
	case "$COUNT" in
	0)
		COUNT=􀆅
		;;
	esac

	sketchybar --set "$NAME" label="$COUNT"
}

add_outdated_header() {
	brew_header=(
		label="$(echo -e 'Outdated Brews')"
		label.font="$LABEL_FONT:Regular:14.0"
		label.align=left
		icon.drawing=off
		click_script="sketchybar --set $NAME popup.drawing=off"
	)
	sketchybar --set brew.details "${brew_header[@]}"
}

render_popup() {
	add_outdated_header

	COUNTER=0
	sketchybar --remove '/brew.package\.*/'

	if [[ -n "$OUTDATED" ]]; then
		while IFS= read -r package; do

			brew_package=(
				label="$package"
				label.align=right
				label.padding_left=20
				icon.drawing=off
				click_script="sketchybar --set $NAME popup.drawing=off"

			)
			item=brew.package."$COUNTER"

			sketchybar --add item "$item" popup."$NAME" \
				--set "$item" "${brew_package[@]}"

			COUNTER=$((COUNTER + 1))

		done <<<"$(echo -n "$OUTDATED" | grep '^')"
	fi
}

update() {
	brew update
	OUTDATED=$(brew outdated)
	COUNT=$(echo -n "$OUTDATED" | grep -c '^')

	render_bar_item
	render_popup

	if [ "$COUNT" -ne "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
		sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
	fi
}

popup() {
	if [[ "$PREV_COUNT" -gt 0 ]]; then
		sketchybar --set "$NAME" popup.drawing="$1"
	else
		sketchybar --set "$NAME" popup.drawing=off
	fi
}

case "$SENDER" in
"routine" | "forced")
	update
	;;
"mouse.entered")
	popup on
	;;
"mouse.exited" | "mouse.exited.global")
	popup off
	;;
"mouse.clicked")
	popup toggle
	;;
esac
