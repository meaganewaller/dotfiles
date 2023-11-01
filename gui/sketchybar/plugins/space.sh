#!/bin/bash


# ICON_ARRAY=(🏠  💻  💬  📧  📅  📄  🎵  🛠️ 🧹)
# UNSELECTED_ICON_ARRAY=(🏚️ 💽 🚫 📪 📆 📂 🎧 🧰 🏁)
#
# if [ "$(yabai -m query --spaces --space "$SID" | jq '."has-focus"')" == "true" ]; then
#   sketchybar -m --set "$NAME" icon="${ICON_ARRAY[$SID-1]}"
# else
#   sketchybar -m --set "$NAME" icon="${UNSELECTED_ICON_ARRAY[$SID-1]}"
# fi

update() {
  source "$HOME/.config/sketchybar/colors.sh"
  COLOR=$IRIS
  if [ "$SELECTED" = "true" ]; then
    COLOR=$LOVE
  fi
  sketchybar --set $NAME icon.highlight=$SELECTED \
    label.highlight=$SELECTED \
    background.border_color=$COLOR
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    yabai -m space --destroy $SID
    sketchybar --trigger windows_on_spaces --trigger space_change
  else
    yabai -m space --focus $SID 2>/dev/null
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
    ;;
  *) update
    ;;
esac
