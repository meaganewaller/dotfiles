#!/usr/bin/env bash

. ~/.config/sketchybar/colors.sh

function color() {
  alpha=${2:-255}
  color=$1

  printf -v alpha "%02x" "$alpha"
  echo "0x${alpha}${color}"
}

export BAR_COLOR=$(color ${COLOR_SURFACE} 200)
export BORDER_COLOR=0xff$COLOR_SURFACE
export ICON_COLOR=0xff$COLOR_TEXT
export LABEL_COLOR=$(color ${COLOR_SUBTLE})
export CONTRAST_COLOR=$ICON_COLOR
export SEGMENT_BACKGROUND_COLOR=$(color ${COLOR_OVERLAY} 150)
export SEGMENT_BACKGROUND_HIGHLIGHT_COLOR=$(color ${COLOR_OVERLAY})
export POPUP_BACKGROUND_COLOR=$(color ${COLOR_OVERLAY} 150)
export POPUP_BORDER_COLOR=0xff$COLOR_IRIS
export FRONT_APP_BACKGROUND_COLOR=$(color ${COLOR_FOAM} 100)

sketchybar --bar color=$BAR_COLOR \
  border_color=$BORDER_COLOR \
  shadow.color=$BAR_COLOR \
  --set '/.*/' icon.color=$ICON_COLOR \
               icon.highlight_color="$(color ${COLOR_ROSE})" \
               label.color=$LABEL_COLOR \
               popup.background.color="$POPUP_BACKGROUND_COLOR" \
               popup.background.border_color="$POPUP_BORDER_COLOR" \
               \
  --set label_template label.color=$CONTRAST_COLOR \
  --set /space\..*/ icon.highlight_color=$(color ${COLOR_ROSE}) \
  --set separator icon.color=$(color ${COLOR_IRIS} 150) \
  --set yabai icon.color=$(color ${COLOR_FOAM} 180)
  # --set music label.color=$(color ${COLOR_PINE} 180) \
  # --set /apple.*/ background.color=$TRANSPARENT \
  #                 label.background.color=$TRANSPARENT \
  #                 label.color=$(color ${COLOR_TEXT}) \
  # --set /apple.divider*/ background.color=$POPUP_BORDER_COLOR \
  # --set calendar.time label.color="$(color ${COLOR_IRIS})" \
  # --set calendar.date label.color="$BAR_COLOR"
  # --set front_app_bracket background.color=$FRONT_APP_BACKGROUND_COLOR \
  # background.color="$(color ${COLOR_IRIS})" \
  # --set status background.color="$(color ${COLOR_SURFACE} 150)" \
  # background.border_color="$(color ${COLOR_OVERLAY})" \
  # --set bluetooth.alias alias.color="$(color ${COLOR_FOAM})" \
  # --set wifi.alias alias.color="$(color ${COLOR_FOAM})" \
  # --set battery icon.color="$(color ${COLOR_FOAM})" \
  # --set mic icon.color="$(color ${COLOR_FOAM})" \
  # --set /github.*/ icon.color="$(color ${COLOR_IRIS} 200)" \
  # --set /github*/ icon.color="$(color ${COLOR_IRIS} 200)" \
  # --set meeting.alias alias.color="$(color ${COLOR_TEXT})" \
  # --set volume slider.background.color=$SEGMENT_BACKGROUND_COLOR \
  # slider.highlight_color="$(color ${COLOR_IRIS} 150)"
