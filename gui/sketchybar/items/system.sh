#!/usr/bin/env sh

battery=(
  update_freq=10
  script="$PLUGIN_DIR/battery.sh"
)

battery_deets=(
  background.corner_radius=12
  background.padding_left=5
  background.padding_right=10
  icon.background.height=2
  icon.background.y_offset=-12
)

bluetooth=(
  icon=""
  icon.drawing=on
  label="?"
	label.drawing=on
  script="$PLUGIN_DIR/bluetooth.sh"
  update_freq=10
  click_script="$PLUGIN_DIR/bluetooth_click.sh"
)

bluetooth_deets=(
  background.corner_radius=12
  background.padding_left=5
  background.padding_right=10
  click_script="sketchybar --set bluetooth.alias popup.drawing=off"
)

sketchybar \
  --add alias "Control Center,Bluetooth" right \
  --rename    "Control Center,Bluetooth" bluetooth.alias \
  --set       bluetooth.alias "${bluetooth[@]}" \
  --subscribe bluetooth.alias mouse.entered \
                              mouse.exited \
                              mouse.exited.global \
                              --add item bluetooth.details popup.bluetooth.alias \
                              --set bluetooth.details "${bluetooth_deets[@]}" \
  --add item bluetooth right --set bluetooth "${bluetooth[@]}" \
  --add item battery right --set battery "${battery[@]}" \
  --subscribe battery mouse.entered mouse.exited mouse.exited.global \
  --add item battery.details popup.battery \
  --set battery.details "${battery_deets[@]}" \

# sketchybar --add       item headphones    right                                                     \
#            --add       event              bluetooth_change "com.apple.bluetooth.status"             \
#            --set       headphones         icon=""                                                   \
#                                           drawing=off                                               \
#                                           background.padding_right=1                                \
#                                           background.padding_left=4                                 \
#                                           script="$PLUGIN_DIR/ble_headset.sh"                       \
#            --subscribe headphones         bluetooth_change                                          \
#                                                                                                     \
#            --add       item               system.mic right                                          \
#            --set       system.mic         update_freq=100                                           \
#                                           label.drawing=off                                         \
#                                           script="$PLUGIN_DIR/mic.sh"                               \
#                                           click_script="$PLUGIN_DIR/mic_click.sh"                   \
#                                                                                                     \
#            --add       item               system.caffeinate right                                   \
#            --set       system.caffeinate  update_freq=100                                           \
#                                           icon=$LOADING                                             \
#                                           label.drawing=off                                         \
#                                           script="$PLUGIN_DIR/caffeinate.sh"                        \
#            --subscribe system.caffeinate  mouse.clicked                                             \
#                                                                                                     \
#            --add       bracket            system                                                    \
#                                           system.mic                                                \
#                                           system.caffeinate                                         \
#                                                                                                     \
#            --set       system             background.drawing=on
