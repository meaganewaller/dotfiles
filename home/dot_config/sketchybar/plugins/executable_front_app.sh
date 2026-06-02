#!/usr/bin/env bash
# front_app — show the frontmost application's icon (app font glyph) and name.
#
# icon_map.sh is managed by chezmoi externals (home/.chezmoiexternals/sketchybar.toml)
# and sets $ICON for a given app name.

set -eu

# shellcheck source=/dev/null
source "$HOME/.config/sketchybar/icon_map.sh"

APP="${FRONT_APP:-}"
if [ -z "$APP" ]; then
  APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null) || true
fi

[ -z "$APP" ] && exit 0

icon_map "$APP"

sketchybar --set "$NAME" \
           icon.font="sketchybar-app-font:Regular:16.0" \
           icon="$ICON" \
           label="$APP"
