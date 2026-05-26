#!/usr/bin/env bash
# battery — pixel-block charge indicator.
#
# Icon set scales with percent so the bar reads at a glance; charging swaps
# to a lightning bolt regardless of level.

set -eu

raw=$(pmset -g batt)
percent=$(printf '%s\n' "$raw" | grep -Eo '[0-9]+%' | head -n1 | tr -d '%')
charging=$(printf '%s\n' "$raw" | grep -c 'AC Power' || true)

if [ -z "$percent" ]; then
  sketchybar --set "$NAME" icon="▢" label="??"
  exit 0
fi

if [ "$charging" -gt 0 ]; then
  icon="⚡"
elif [ "$percent" -ge 90 ]; then icon="█"
elif [ "$percent" -ge 70 ]; then icon="▇"
elif [ "$percent" -ge 50 ]; then icon="▅"
elif [ "$percent" -ge 30 ]; then icon="▃"
elif [ "$percent" -ge 10 ]; then icon="▂"
else                              icon="▁"
fi

sketchybar --set "$NAME" icon="$icon" label="${percent}%"
