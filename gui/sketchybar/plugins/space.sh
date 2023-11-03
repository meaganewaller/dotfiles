#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

args=()
if [ "$NAME" != "space_template" ]; then
  args+=(--set $NAME label=$NAME \
    icon= \
    icon.font="Hack Nerd Font:Regular:14.5" \
    icon.color=$TRANSPARENT_WHITE
      icon.y_offset=0
    )
fi

if [ "$SELECTED" = "true" ]; then
  args+=(--set spaces_$DID.label label=${NAME#"spaces_$DID"})
  args+=(--set $NAME icon=  icon.color=$ACCENT_COLOR icon.font="Hack Nerd Font:Regular:13.0" icon.y_offset=0)
else
  args+=(--set $NAME)
fi

sketchybar -m --animate tanh 20 "${args[@]}"

# ICON_ARRAY=(🏠  💻  💬  📧  📅  📄  🎵  🛠️ 🧹)
# UNSELECTED_ICON_ARRAY=(🏚️ 💽 🚫 📪 📆 📂 🎧 🧰 🏁)
#
# if [ "$(yabai -m query --spaces --space "$SID" | jq '."has-focus"')" == "true" ]; then
#   sketchybar -m --set "$NAME" icon="${ICON_ARRAY[$SID-1]}"
# else
#   sketchybar -m --set "$NAME" icon="${UNSELECTED_ICON_ARRAY[$SID-1]}"
# fi
#
# mouse_clicked() {
#   yabai -m space --focus $SID 2>/dev/null
# }
#
# case "$SENDER" in
#   "mouse.clicked") mouse_clicked
#     ;;
#   *) update
#     ;;
# esac
