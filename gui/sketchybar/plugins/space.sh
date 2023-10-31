#!/bin/bash

ICON_ARRAY=(🏠  💻  💬  📧  📅  📄  🎵  🛠️ 🧹)
UNSELECTED_ICON_ARRAY=(🏚️ 💽 🚫 📪 📆 📂 🎧 🧰 🏁)

if [ "$(yabai -m query --spaces --space "$SID" | jq '."has-focus"')" == "true" ]; then
  sketchybar -m --set "$NAME" icon="${ICON_ARRAY[$SID-1]}"
else
  sketchybar -m --set "$NAME" icon="${UNSELECTED_ICON_ARRAY[$SID-1]}"
fi
