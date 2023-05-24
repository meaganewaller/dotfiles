source "$HOME/.config/sketchybar/colors.sh"

sketchybar \
  --bar \
  color="$BAR_COLOR" \
  border_color="$BAR_BORDER_COLOR" \
  --default \
  popup.background.border_color="$POPUP_BORDER_COLOR" \
  popup.background.color="$POPUP_BACKGROUND_COLOR" \
  icon.color="$FOAM" \
  label.color="$TEXT" \
  --set window_title \
  icon.color="$SUBTLE" \
  label.color="$SUBTLE" \
  --set battery \
  icon.color="$PINE" \
  label.color="$PINE" \
  --set wifi \
  icon.color="$FOAM" \
  --set time \
  icon.color="$GOLD" \
  label.color="$GOLD" \
  --set date \
  background.color="$GOLD" \
  --set cpu_label \
  label.color="$LOVE" \
  --set cpu_percent \
  label.color="$LOVE" \
  --set apple.logo \
  icon.color="$IRIS" \
  --set vpn \
  icon.color="$MUTED" \
  --set packages \
  label.color="$SUBTLE" \
  --set /space/ \
  icon.color="$MUTED" \
  icon.highlight_color="$IRIS" \
  --set music \
  icon.color="$LOVE" \
  label.color="$ROSE" \
  --set "Control Center,Battery" \
  alias.color="$GOLD" \
  --set "iStat Menus Status" \
  alias.color="$PINE" \
  --set clock \
  icon.color="$IRIS" \
  label.color="$IRIS"

yabai -m config active_window_border_color "$IRIS"
yabai -m config normal_window_border_color "$SUBTLE"
yabai -m config insert_feedback_color "$LOVE"
