#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

function color() {
  alpha=${2:-255}
  color="$1"

  case $1 in
    base) color=$COLOR_BASE ;;
    surface) color=$COLOR_SURFACE ;;
    overlay) color=$COLOR_OVERLAY ;;
    muted) color=$COLOR_MUTED ;;
    subtle) color=$COLOR_SUBTLE ;;
    text) color=$COLOR_TEXT ;;
    love) color=$COLOR_LOVE ;;
    gold) color=$COLOR_GOLD ;;
    rose) color=$COLOR_ROSE ;;
    pine) color=$COLOR_PINE ;;
    foam) color=$COLOR_FOAM ;;
    iris) color=$COLOR_IRIS ;;
    highlight_low) color=$COLOR_HIGHLIGHT_LOW ;;
    highlight_med) color=$COLOR_HIGHLIGHT_MED ;;
    highlight_high) color=$COLOR_HIGHLIGHT_HIGH ;;
    *) color=$TEXT ;;
  esac
  printf -v alpha "%02x" "$alpha"
  echo "0x${alpha}${color}"
}

bar_config=(
  color=$(color surface 180)
  border_color=$(color surface)
)

default_config=(
  icon.color=$(color iris 50)
  label.color=$(color iris)
)

sketchybar \
  --bar "${bar_config[@]}" \
  --default "${default_config[@]}" \
  --set /space/ \
  icon.color=$(color highlight_high 200) \
  icon.highlight_color=$(color love) \
  --set window_title \
  icon.color=$(color overlay) \
  label.color=$(color overlay)

  # --set skhd  icon.color="$(color iris 50)" \
  #             label.color="$(color iris 50)" \
  # --set yabai icon.color="$(color gold)" \
  # --set wm_bracket background.color="$(color overlay 100)" \
  #                  background.border_color="$(color overlay)" \
  #                  icon.color="$(color iris)" \
  #                  label.color="$(color text)" \
  # --set apple.logo popup.background.color="$(color surface 100)" \
  #                  popup.background.border_color="$(color iris)" \
  # --set apple.divider background.color="$(color text)" \
  # --set apple.divider2 background.color="$(color text)" \
  # --set /apple/    icon.color="$(color iris)" \
  #                  label.color="$(color text)" \
  # --set /space/    icon.color="$(color rose 100)" \
  #                  icon.highlight_color="$(color rose 20)" \
  # --set spaces     background.color="$(color overlay 100)" \
  #                  background.border_color="$(color surface)" \
  # --set separator_left icon.color="$(color foam)" \
  # --set window label.color="$(color text)" \
  # --set music  label.color="$(color text 50)" \
  #              icon.color="$(color love)" \
  # --set clock  label.color="$(color pine)" \
  # --set date   label.color="$(color pine)" \
  # --set gh     label.color="$(color pine)" \
  #              icon.color="$(color pine)" \
  # --set github.bell icon.color="$(color pine)" \
  #                   label.highlight_color="$(color pine)" \
  # --set github.notification icon.color="$(color pine)" \
  #                           label.highlight_color="$(color pine)" \
  # --set github.bell icon.color="$(color pine)" \
  #                   label.highlight_color="$(color pine)" \
  # --set github.notification popup.background.color="$(color surface 100)" \
  #                           popup.background.border_color="$(color iris)"



yabai -m config active_window_border_color $IRIS
yabai -m config normal_window_border_color $HIGHLIGHT_LOW
yabai -m config insert_feedback_color $LOVE
