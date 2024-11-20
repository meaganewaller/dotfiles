# Yabai

[Yabai](https://github.com/koekeishiya/yabai) is a tiling window manager for macOS based on binary space partitioning.
I'm using [sketchybar](/docs/sketchybar/sketchybar.md) to display the current workspace and the focused window title.

## Configuration

```bash tangle:~/.dotfiles/os/macos/yabai/yabairc
#!/usr/bin/env sh
#  ┬ ┬┌─┐┌┐ ┌─┐┬
#  └┬┘├─┤├┴┐├─┤│
#   ┴ ┴ ┴└─┘┴ ┴┴
# Author: Meagan Waller
# Github: github.com/meaganwaller
# Dotfiles Repo: github.com/meaganewaller/dotfiles
# Last edited: November 20th, 2024

source "${HOME}"/.config/yabai/scripts/helper

# Signal Hooks
yabai -m signal --add event=window_destroyed active=yes action="yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse &> /dev/null || yabai -m window --focus \$(yabai -m query --windows --space | jq .[0].id) &> /dev/null"
yabai -m signal --add event=window_minimized active=yes action="if \$(yabai -m query --windows --window \$YABAI_WINDOW_ID | jq -r '.\"is-floating\"'); then yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse &> /dev/null || yabai -m window --focus \$(yabai -m query --windows --space | jq .[0].id) &> /dev/null; fi"
yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"

BAR_HEIGHT=$(sketchybar -m --query bar | jq -r '.height')
create_spaces 9

GENERAL=(
  external_bar          all:"${BAR_HEIGHT}":0
  split_type            auto
  split_ratio           0.5
  auto_balance          off
)


WINDOWS=(
  window_origin_display     focused
  window_placement          second_child
  window_zoom_persist       on
  window_topmost            off
  window_shadow             float
  window_opacity            off
  window_opacity_duration   0.25
  active_window_opacity     0.97
  normal_window_opacity     0.75
)

BORDERS=(
  window_border        on
  window_border_hidpi  off
  window_border_blur   off
  window_border_width  4
  window_border_radius 12
   # active_window_border_color 0xff7793d1
   # normal_window_border_color 0xff5e6798
   # insert_feedback_color      0xff7793d1
)

LAYOUT=(
  layout         bsp
  top_padding    20
  bottom_padding 20
  left_padding   20
  right_padding  20
  window_gap     10
)

MOUSE=(
 mouse_modifier      alt
 mouse_action1       move
 mouse_action2       resize
 mouse_drop_action   swap
 focus_follows_mouse autofocus
 mouse_follows_focus off
)

yabai -m config "${GENERAL[@]}"
yabai -m config "${WINDOWS[@]}"
yabai -m config "${BORDERS[@]}"
yabai -m config "${LAYOUT[@]}"
yabai -m config "${MOUSE[@]}"

LABELS=(
  main
  code
  chat
  mail
  gtd
  doc
  media
  tool
  scratch
)

for ((i=1; i <= "${#LABELS[@]}"; i++)); do
  yabai -m space "${i}" --label "${LABELS[(($i - 1))]}"
done

yabai -m config --space chat    layout stack window_opacity off
yabai -m config --space media   layout stack window_opacity off
yabai -m config --space scratch layout float
yabai -m config --space tool    layout float
yabai -m config --space mail    window_opacity off \
  left_padding 210 \
  right_padding 210

UNMANAGED=(
  Activity Monitor
  Alfred
  App Store
  Archive Utility
  Calculator
  Dictionary
  FaceTime
  Photo Booth
  Preferences
  Python
  ScanSnap
  Screen Sharing
  Screens
  Software Update
  Stats
  System Information
  System Preferences
  System Settings
  VLC
  Vimac
  iStat Menus
)

for ((i = 1; i <= "${#UNMANAGED[@]}"; i++)); do
 yabai -m rule --add label="unmanage_${UNMANAGED[(($i - 1))]}" app="^${UNMANAGED[(($i - 1))]}.*$" manage=off border=off
done

yabai -m rule --add label="ColorSlurp" app="^ColorSlurp$" sticky=true layer=above manage=off
yabai -m rule --add app="zoom.us" manage=off

# Exclude problematic apps from being managed:
yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off

CHAT=(
  Messages
  Slack
  Discord
  Messenger
  Telegram
  Signal
)

for ((i = 1; i <= "${#CHAT[@]}"; i++)); do
 yabai -m rule --add label="chat_${CHAT[(($i - 1))]}" app="^${CHAT[(($i - 1))]}.*$" space=chat
done


MAIL=(
  Mail
  Thunderbird
  Spark
  MailSpring
)
for ((i = 1; i <= "${#MAIL[@]}"; i++)); do
 yabai -m rule --add label="mail_${MAIL[(($i - 1))]}" app="^${MAIL[(($i - 1))]}.*$" space=mail
done

STICKY=(
  # 1Password
  System Preferences
  System Settings
)

for ((i = 1; i <= "${#STICKY[@]}"; i++)); do
 yabai -m rule --add label="sticky_${STICKY[(($i - 1))]}" app="^${STICKY[(($i - 1))]}.*$" sticky=on
done

CENTERED=(
  1Password
)

for ((i = 1; i <= "${#CENTERED[@]}"; i++)); do
 yabai -m rule --add label="centered_${CENTERD[(($i - 1))]}" app="^${CENTERED[(($i - 1))]}.*$" sticky=on grid=4:4:1:0:2:4
done


MEDIA=(
 Music
 Plex
 Spotify
 VLC
  mpv
)

for ((i = 1; i <= "${#MEDIA[@]}"; i++)); do
 yabai -m rule --add label="media_${MEDIA[(($i - 1))]}" app="^${MEDIA[(($i - 1))]}.*$" space=media
done

GTD=(
  Things
 Notes
 Reminders
 Calendar
 Fantastical
)

for ((i = 1; i <= "${#GTD[@]}"; i++)); do
 yabai -m rule --add label="gtd_${GTD[(($i - 1))]}" app="^${GTD[(($i - 1))]}.*$" space=gtd
done

DOC=(
  Notion
  Obsidian
)

for ((i = 1; i <= "${#DOC[@]}"; i++)); do
 yabai -m rule --add label="doc_${DOC[(($i - 1))]}" app="^${DOC[(($i - 1))]}.*$" space=doc
done

TOOL=(
  Beekeeper Studio Ultimate
  Postman
  Postico
)
for ((i = 1; i <= "${#TOOL[@]}"; i++)); do
 yabai -m rule --add label="tool_${TOOL[(($i - 1))]}" app="^${TOOL[(($i - 1))]}.*$" space=tool
done
```

## Helper Script

```bash tangle:~/.dotfiles/os/macos/yabai/scripts/helper
#!/usr/bin/env bash

toggle_layout() {
  LAYOUT=$(yabai -m query --spaces --space | jq .type)

    if [[ $LAYOUT =~ "bsp" ]]; then
      yabai -m space --layout stack
        elif [[ $LAYOUT =~ "stack" ]]; then
        yabai -m space --layout float
        elif [[ $LAYOUT =~ "float" ]]; then
        yabai -m space --layout bsp
        fi
}

opacity_up() {
 OPACITY=$(yabai -m query --windows --window | jq .opacity)
 if [[ "$OPACITY" -eq 1.0 ]]; then
  yabai -m window --opacity 0.1
 else
  OPACITY=$(echo "$OPACITY" + 0.1 | bc)
  yabai -m window --opacity "$OPACITY"
 fi
}

opacity_down() {
 OPACITY=$(yabai -m query --windows --window | jq .opacity)
 if [[ "$OPACITY" -eq 0.1 ]]; then
  yabai -m window --opacity 1.0
 else
  OPACITY=$(echo "$OPACITY" - 0.1 | bc)
  yabai -m window --opacity "$OPACITY"
 fi
}

close_window() {
 FULLSCREEN=$(yabai -m query --windows --window | jq '."is-native-fullscreen"')
 APP=$(yabai -m query --windows --window | jq -r '."app"')
 skhd -k "escape"
 if [[ $FULLSCREEN = "true" ]]; then
  # osascript -l JavaScript -e 'Application("System Events").keystroke("w",{using: ["command down", "shift down"]})'

  if [[ $APP = "Firefox" ]]; then
   hs -A -c "closeWindow()"
  fi
 else
  skhd -k "shift + cmd - w"
  # yabai -m window --close
 fi
}

toggle_border() {
 BORDER=$(yabai -m config window_border)
 if [[ $BORDER = "on" ]]; then
  yabai -m config window_border off
 elif [[ $BORDER = "off" ]]; then
  yabai -m config window_border on
 fi
 yabai -m config window_border
}

increase_gaps() {
 GAP=$(yabai -m config window_gap)
 yabai -m config window_gap $(echo "$GAP" + 1 | bc)
}

decrease_gaps() {
 GAP=$(yabai -m config window_gap)
 yabai -m config window_gap $(echo "$GAP" - 1 | bc)
}

increase_padding_top() {
 PADDING=$(yabai -m config top_padding)
 yabai -m config top_padding $(echo "$PADDING" + 1 | bc)
}

increase_padding_bottom() {
 PADDING=$(yabai -m config bottom_padding)
 yabai -m config bottom_padding $(echo "$PADDING" + 1 | bc)
}

increase_padding_left() {
 PADDING=$(yabai -m config left_padding)
 yabai -m config left_padding $(echo "$PADDING" + 1 | bc)
}

increase_padding_right() {
 PADDING=$(yabai -m config right_padding)
 yabai -m config right_padding $(echo "$PADDING" + 1 | bc)
}

increase_padding_all() {
 PADDING_TOP=$(yabai -m config top_padding)
 PADDING_BOTTOM=$(yabai -m config bottom_padding)
 PADDING_LEFT=$(yabai -m config left_padding)
 PADDING_RIGHT=$(yabai -m config right_padding)
 WINDOW_GAP=$(yabai -m config window_gap)

 yabai -m config top_padding $(echo "$PADDING"_TOP + 10 | bc)
 yabai -m config bottom_padding $(echo "$PADDING"_BOTTOM + 10 | bc)
 yabai -m config left_padding $(echo "$PADDING"_LEFT + 10 | bc)
 yabai -m config right_padding $(echo "$PADDING"_RIGHT + 10 | bc)
 yabai -m config window_gap $(echo "$window"_GAP + 10 | bc)
}

decrease_padding_top() {
 PADDING=$(yabai -m config top_padding)
 yabai -m config top_padding $(echo "$PADDING" - 1 | bc)
}

decrease_padding_bottom() {
 PADDING=$(yabai -m config bottom_padding)
 yabai -m config bottom_padding $(echo "$PADDING" - 1 | bc)
}

decrease_padding_left() {
 PADDING=$(yabai -m config left_padding)
 yabai -m config left_padding $(echo "$PADDING" - 1 | bc)
}

decrease_padding_right() {
 PADDING=$(yabai -m config right_padding)
 yabai -m config right_padding $(echo "$PADDING" - 1 | bc)
}

decrease_padding_all() {
 PADDING_TOP=$(yabai -m config top_padding)
 PADDING_BOTTOM=$(yabai -m config bottom_padding)
 PADDING_LEFT=$(yabai -m config left_padding)
 PADDING_RIGHT=$(yabai -m config right_padding)
 WINDOW_GAP=$(yabai -m config window_gap)

 yabai -m config top_padding $(echo "$PADDING"_TOP - 10 | bc)
 yabai -m config bottom_padding $(echo "$PADDING"_BOTTOM - 10 | bc)
 yabai -m config left_padding $(echo "$PADDING"_LEFT - 10 | bc)
 yabai -m config right_padding $(echo "$PADDING"_RIGHT - 10 | bc)
 yabai -m config window_gap $(echo "$window"_GAP - 10 | bc)
}

new_window() {
 APP_TO_OPEN="$1"
 CURRENT_APP=$(yabai -m query --windows --window | jq -r '.app')

 click_menu_bar() {
  osascript -e 'tell application "System Events"' \
   -e "tell application process \"$APP_TO_OPEN\"" \
   -e "tell menu 1 of menu bar item 3 of menu bar 1" \
   -e "click (first menu item whose value of attribute \"AXMenuItemCmdChar\" is \"N\" and value of attribute \"AXMenuItemCmdModifiers\" is $1)" \
   -e 'end tell' \
   -e 'end tell' \
   -e 'end tell'
 }

 RUNNING=$(osascript -e "tell application \"System Events\" to set Appli_Launch to exists (processes where name is \"$APP_TO_OPEN\")")

 if ! [[ $RUNNING = true ]]; then
  if [[ $APP_TO_OPEN = "kitty" ]]; then
   open -a kitty.app --args -1
  fi
  osascript -e "tell application \"$APP_TO_OPEN\" to launch"
  exit 0
 fi

 osascript -e "tell application \"$APP_TO_OPEN\" to activate"

 if [[ $2 = "stack" ]]; then
  yabai -m window --insert stack
 fi

 if [[ $APP_TO_OPEN = "Code" ]]; then
  click_menu_bar 1
 elif [[ $APP_TO_OPEN = "Firefox" ]]; then
  # HACK: Yabai fails to allow firefox window to open running from command line works though
  /Applications/Firefox.app/Contents/MacOS/firefox-bin --new-window
 else
  click_menu_bar 0
 fi
}

create_spaces() {
 CURRENT_SPACES=$(yabai -m query --spaces | jq -r '[.[]."is-native-fullscreen"| select(.==false) ]| length')
 CURRENT_SPACE=$(yabai -m query --spaces --space | jq -r ."index")
 NEEDED_SPACES=$1

 if [[ $1 == "a" ]]; then
  yabai -m space --create
  yabai -m space last --label $2
  if [ -n "$YABAI_WINDOW_ID" ]; then
   yabai -m window $YABAI_WINDOW_ID --space $2
  fi
  yabai -m space --focus $2
  # set_wallpaper "$HOME/.local/share/wallpapers/catppuccin/$(/bin/ls ~/.local/share/wallpapers/catppuccin | shuf -n 1)"
  return 0
 fi

 if [[ "$CURRENT_SPACES" -ge "$NEEDED_SPACES" ]]; then
  return
 fi
 SPACES_TO_CREATE=$(($NEEDED_SPACES - $CURRENT_SPACES))

 for i in $(seq $((1 + CURRENT_SPACES)) "$NEEDED_SPACES"); do
  echo $i
  yabai -m space --create
  yabai -m space --focus $i
  # set_wallpaper "$HOME/.local/share/wallpapers/catppuccin/$(/bin/ls ~/.local/share/wallpapers/catppuccin | shuf -n 1)"
 done
 yabai -m space $CURRENT_SPACE --focus

}

set_wallpaper() {
 osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$1"'"'
}

set_wallpapers() {
 if [[ $(command -v yabai) ]]; then
  LOCAL_WALLPAPERS="$(realpath "$HOME"/.local/share/wallpapers/catppuccin)"

  yabai -m space --focus 1

  i=0

  for file in "$LOCAL_WALLPAPERS"/*.png; do
   ((i = i + 1))
   echo "Setting wallpaper on space $i to $file..."
   # take action on each file. $f store current file name
   osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$file"'"'
   yabai -m space --focus next 2 &>/dev/null
   sleep 0.1
  done
 fi
}

get_pixel_color() {

 # Use hammer spoon to get mouse x,y coords
 X=$(hs -A -c "hs.mouse.absolutePosition()['x']")
 Y=$(hs -A -c "hs.mouse.absolutePosition()['y']")

 # Screenshot pixel at mouse coords save to $TMPDIR
 # HEX Dump and grab color
 # NOTE: This will require security and privacy permissions to capture the screen
 # Running against known hexs will not reproduce the same hex though will
 # produce the same color for all intents and purposes. Generally a single
 # Color R G or B will be 1 digit less than the actual.

 COLOR=$(
  screencapture -R $X,$Y,1,1 -t bmp $TMPDIR/pixel_color.bmp
  xxd -p -l 3 -s 54 $TMPDIR/pixel_color.bmp |
   sed 's/\(..\)\(..\)\(..\)/\3\2\1/'
 )

 # Copy Color to Clipboard
 echo "#$COLOR" | pbcopy

 # Use applescript to display a native OS notification
 # TODO: This could be improved with imagemagick and hammerspoon
 /usr/bin/osascript -e '
    on run argv
      display notification "#" & item 1 of argv
    end run
  ' $COLOR

 /opt/homebrew/bin/skhd -k 'escape'

}

cycle_windows() {
 reverse=""
 if [[ $1 != "--reverse" ]]; then
  reverse="| reverse"
 else
  reverse=""
 fi
 yabai -m query --windows --space | jq -re '
    map(select((."is-minimized" != true) and ."can-move" == true))
    | sort_by(.frame.x, .frame.y, ."stack-index", .id)
    '"$reverse"'
    | first as $first
    | map( $first.id, .id )
    | .[]' |
  tail -n +3 |
  xargs -n2 sh -c 'echo $1 $2; yabai -m window $1 --swap $2' sh
}

float_reset() {
 ids=($(yabai -m query --windows --space | jq -re '.[].id'))

 for window in $ids; do
  top=$(yabai -m query --windows --window "$window" | jq -re '."is-topmost"')
  floating=$(yabai -m query --windows --window "$window" | jq -re '."is-floating"')

  if $top; then
   if $floating; then
    continue
   fi
   yabai -m window "$window" --toggle topmost
  fi
 done
}

float_signal() {
 QUERY=$(yabai -m query --windows --window "$1" | jq -re '."is-topmost",."is-floating"')
 declare -a PROPERTIES
 PROPERTIES=("$QUERY")

 if ! ${PROPERTIES[0]} && ${PROPERTIES[1]}; then
  yabai -m window "$1" --toggle topmost
  echo 1 "${PROPERTIES[0]}" "${PROPERTIES[1]}"
 fi

 if ${PROPERTIES[0]} && ! ${PROPERTIES[1]}; then
  yabai -m window "$1" --toggle topmost
  echo 2 "${PROPERTIES[0]}" "${PROPERTIES[1]}"
 fi
}

set_layer() {
 QUERY=$(yabai -m query --windows --window "$1" | jq -re '."is-topmost",."is-floating"')
 declare -a PROPERTIES
 PROPERTIES=("$QUERY")

 if ! ${PROPERTIES[1]}; then
  yabai -m window "$YABAI_WINDOW_ID" --layer below
  return
 fi
 # yabai -m window $YABAI_WINDOW_ID --layer normal
}

auto_stack() {
 INSTANCES=$(yabai -m query --windows | jq "[.[] |select(.\"app\"==\"$1\")| .\"id\"]| length")
 if [[ $INSTANCES -eq 1 ]]; then
  return 0
 fi

 NEW_APP=$YABAI_WINDOW_ID
 APP=$(yabai -m query --windows | jq "[.[] |select(.\"app\"==\"$1\" )|select(.\"id\"!=\"$NEW_APP\")][1].\"id\"")
 yabai -m window "$APP" --stack "$NEW_APP"
}

kuake() {
 if [[ $(yabai -m query --windows | jq "[.[]|select(.\"title\"==\"KUAKE\").\"title\"]| length") -eq 0 ]]; then
  /Applications/kitty.app/Contents/MacOS/kitty -1 -T KUAKE -d ~ &
  disown
  KUAKE_ID=$(yabai -m query --windows | jq ".[]|select(.\"title\"==\"KUAKE\").\"id\"")
  return 0
 fi

 KUAKE_ID=$(yabai -m query --windows | jq ".[]|select(.\"title\"==\"KUAKE\").\"id\"")
 KUAKE_SPACE=$(yabai -m query --windows --window "$KUAKE_ID" | jq '."space"')
 CURRENT_SPACE=$(yabai -m query --spaces --space | jq '."index"')

 if [[ $KUAKE_SPACE -eq $CURRENT_SPACE ]]; then
  yabai -m window "$KUAKE_ID" --space scratch
  return 0
 fi

 yabai -m window "$KUAKE_ID" --opacity 0.1 --space "$CURRENT_SPACE" --focus "$KUAKE_ID" --opacity 0.0
}
```
