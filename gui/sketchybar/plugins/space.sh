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
  WIDTH="dynamic"
  if [ "$SELECTED" = "true" ]; then
    WIDTH="0"
  fi

  sketchybar --animate tanh 20 --set $NAME icon.highlight=$SELECTED label.width=$WIDTH
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    yabai -m space --destroy $SID
    sketchybar --trigger space_change --trigger windows_on_spaces
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
