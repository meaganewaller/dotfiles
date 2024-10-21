#!/usr/bin/env sh

update() {
  source "$HOME/.config/sketchybar/icons.sh"
  WINDOW=$(yabai -m query --windows --window)
  CURRENT=$(echo "$WINDOW" | jq '.["stack-index"]')
  args=()
  if [[ $CURRENT -gt 0 ]]; then
    LAST=$(yabai -m query --windows --window stack.last | jq '.["stack-index"]')
    args+=(--set $NAME icon=$YABAI_STACK label.drawing=on label=$(printf "[%s/%s]" "$CURRENT" "$LAST"))

  else
    args+=(--set $NAME label.drawing=off)
    case "$(echo "$WINDOW" | jq '.["is-floating"]')" in
      "false")
        if [ "$(echo "$WINDOW" | jq '.["has-fullscreen-zoom"]')" = "true" ]; then
          args+=(--set $NAME icon=$YABAI_FULLSCREEN_ZOOM)
        elif [ "$(echo "$WINDOW" | jq '.["has-parent-zoom"]')" = "true" ]; then
          args+=(--set $NAME icon=$YABAI_PARENT_ZOOM)
        else
          args+=(--set $NAME icon=$YABAI_GRID)
        fi
        ;;
      "true")
        args+=(--set $NAME icon=$YABAI_FLOAT)
        ;;
    esac
  fi

  sketchybar "${args[@]}"
}

mouse_clicked() {
  yabai -m window --toggle float
  update
}

mouse_entered() {
  sketchybar --set $NAME background.drawing=on
}

mouse_exited() {
  sketchybar --set $NAME background.drawing=off
}
case "$SENDER" in
  "mouse.entered") mouse_entered
  ;;
  "mouse.exited") mouse_exited
  ;;
  "mouse.clicked") mouse_clicked
  ;;
  "forced") exit 0
  ;;
  *) update
  ;;
esac
