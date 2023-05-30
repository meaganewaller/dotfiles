#!/usr/bin/env sh

separator=(
  icon.drawing=off
  label.drawing=off
  background.padding_left=0
  background.padding_right=0
  associated_space=2
)

topproc=(
  label.font="$LABEL_FONT:Regular:7"
  label=CPU
  icon.drawing=off
  width=0
  y_offset=6
  associated_space=2
  update_freq=5
  script="$PLUGIN_DIR/topproc.sh"
  updates=when_shown
)

percent=(
  label.font="$ICON_FONT:Bold:12.0"
  label=CPU
  y_offset=-4
  width=40
  icon.drawing=off
  update_freq=2
  associated_space=2
  updates=when_shown
)

user=(
  graph.color="0xff$COLOR_LOVE"
  update_freq=2
  width=0
  associated_space=2
  label.drawing=off
  icon.drawing=off
  background.height=23
  background.color=$TRANSPARENT
  background.border_color=$TRANSPARENT
  script="$PLUGIN_DIR/cpu.sh"
  updates=when_shown
)

sys=(
  associated_space=2
  graph.color="0xff$COLOR_IRIS"
  label.drawing=off
  icon.drawing=off
  background.height=23
  background.color=$TRANSPARENT
  background.border_color=$TRANSPARENT
  updates=when_shown
)

label=(
  associated_space=2
  label=cpu
  position=right
  drawing=on
  background.padding_right=0
)

sketchybar --add item cpu.separator right \
  --set cpu.separator "${separator[@]}" \
  --add item cpu.topproc right \
  --set cpu.topproc "${topproc[@]}" \
  --add item cpu.percent right \
  --set cpu.percent "${percent[@]}" \
  --add graph cpu.user right 100 \
  --set cpu.user "${user[@]}" \
  --add graph cpu.sys right 100 \
  --set cpu.sys "${sys[@]}" \
  --clone cpu.label label_template \
  --set cpu.label "${label[@]}" \
  --add bracket cpu \
  cpu.separator \
  cpu.topproc \
  cpu.percent \
  cpu.user \
  cpu.sys \
  cpu.label \
  --set cpu background.drawing=on
