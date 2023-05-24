#!/usr/bin/env sh

WINDOW_SCRIPT='sketchybar --set $NAME label="$INFO"'

system_yabai=(
  script="$PLUGIN_DIR/yabai.sh"
  icon.font="$ICON_FONT:Bold:16.0"
  label.drawing=off
  icon.width=30
  icon="$YABAI_GRID"
  icon.color="$ROSE"
  associated_display=active
)

window=(
  script="$WINDOW_SCRIPT"
  icon.drawing=off
  background.padding_left=0
  label.color="$LABEL_COLOR"
  associated_display=active
)

sketchybar --add event window_focus \
  --add event windows_on_spaces \
  -add item system.yabai left \
  --set       system.yabai "${system_yabai[@]}"          \
  --subscribe system.yabai window_focus                  \
  windows_on_spaces             \
  mouse.clicked                 \
  \
  --add       item         window left                \
  --set       window    "${window[@]}"             \
  --subscribe window    front_app_switched



# sketchybar --add event window_focus
# sketchybar --add event windows_on_spaces
#
# sketchybar --add item system.yabai left \
#   --set system.yabai \
#   script="$PLUGIN_DIR/yabai.sh" \
#   icon.font="$ICON_FONT:Bold:16.0" \
#   label.drawing=off \
#   icon.with=30 \
#   icon="$YABAI_GRID" \
#   icon.color="$ROSE" \
#   associated_display=active \
#   --subscribe system.yabai window_focus windows_on_spaces mouse.clicked
#
# sketchybar --add item front_app left \
#     --set front_app script="$PLUGIN_DIR/front_app.sh" \
#     icon.drawing=off \
#     background.padding_left=0 \
#     label.color="$TEXT" \
#     label.font="$FONT:12.0" \
#     associated_display=active \
#     --subscribe front_app front_app_switched window_focus
