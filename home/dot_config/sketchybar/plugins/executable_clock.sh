#!/usr/bin/env bash
# clock — "Tuesday May 26th 1:25PM"
#
# date(1) on BSD/macOS has no ordinal-suffix specifier, so we compute the
# suffix here and splice it into the label.

set -eu

day=$(date +%-d)
case "$day" in
  11|12|13)        suffix="th" ;;
  *1)              suffix="st" ;;
  *2)              suffix="nd" ;;
  *3)              suffix="rd" ;;
  *)               suffix="th" ;;
esac

label=$(date +"%A %B ${day}${suffix} %-I:%M%p")
sketchybar --set "$NAME" label="$label"
