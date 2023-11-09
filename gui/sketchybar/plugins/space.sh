#!/usr/bin/env bash

ICON_ARRAY=(🏠  💻  💬  📧  📅  📄  🎵  🛠️ 🧹)
UNSELECTED_ICON_ARRAY=(🏚️ 💽 🚫 📪 📆 📂 🎧 🧰 🏁)

update() {
  if [ "$SELECTED" = "true" ]; then
    sketchybar -m --set "$NAME" icon="${ICON_ARRAY[$SID-1]}" \
      background.border_color="$YABAI_SPACE_BACKGROUND_BORDER_COLOR_ACTIVE" \
      label.highlight="$SELECTED"
  else
    sketchybar -m --set "$NAME" icon="${UNSELECTED_ICON_ARRAY[$SID-1]}" \
      label.highlight="$SELECTED" \
      background.border_color="$YABAI_SPACE_BACKGROUND_BORDER_COLOR"
  fi
}

set_space_label() {
  sketchybar --set "$NAME" icon="$@"
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    yabai -m space --destroy "$SID" && sketchybar --trigger windows_on_spaces
  else
    if [ "$MODIFIER" = "shift" ]; then
      SPACE_LABEL="$(osascript -e "return (text returned of (display dialog \"Give a name to space $NAME:\" default answer \"\" with icon note buttons {\"Cancel\", \"Continue\"} default button \"Continue\"))")"
      if [ $? -eq 0 ]; then
        if [ "$SPACE_LABEL" = "" ]; then
          set_space_label "${NAME:6}"
        else
          set_space_label "${NAME:6} ($SPACE_LABEL)"
        fi
      fi
    else
      yabai -m space --focus "$SID" 2>/dev/null
    fi
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
