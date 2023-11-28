#!/bin/bash

# shellcheck disable=SC1091
source "$HOME/.config/sketchybar/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')
COLOR=$WHITE


if [[ $CHARGING != "" ]]; then
  case ${PERCENTAGE} in
    9[0-9]|100) ICON="󰂅" COLOR=$GV_CHARGER_CONNECTED
    ;;
    [6-8][0-9]) ICON="󰢞" COLOR=$GV_CHARGER_CONNECTED
    ;;
    [3-5][0-9]) ICON="󰢝" COLOR=$GV_CHARGER_CONNECTED
    ;;
    [1-2][0-9]) ICON="󰂇" COLOR=$GV_CHARGER_CONNECTED
    ;;
    *) ICON="󰢜"; COLOR=$GV_CHARGER_CONNECTED
  esac
else
  case ${PERCENTAGE} in
    9[0-9]|100) ICON="󰁹" COLOR=$GREEN
      ;;
    [6-8][0-9]) ICON="󰂀" COLOR=$GV_BATTERY_MEDIUM
      ;;
    [3-5][0-9]) ICON="󰁾" COLOR=$GV_BATTERY_LOW
      ;;
    [1-2][0-9]) ICON="󰁼" COLOR=$GV_BATTERY_SUPERLOW
      ;;
    *) ICON="󰁺"; COLOR=$GV_BATTERY_SUPERLOW
  esac
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" label.color="$LABEL_COLOR" label.drawing=on icon.color="$COLOR"
