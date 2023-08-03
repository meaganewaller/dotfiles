#!/usr/bin/env bash

dayOfMonth=$(date +%d)

# Choose postfix
case "$dayOfMonth" in
  1)
    postfix="st"
    ;;
  2)
    postfix="nd"
    ;;
  3)
    postfix="rd"
    ;;
  *)
    postfix="th"
    ;;
esac

# Generate date string
myDate=$(date +%A,\ %B\ %d$postfix)

sketchybar -m --set calendar.date label="$myDate"
