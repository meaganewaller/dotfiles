#!/bin/bash

REMINDERS_COUNT=$(osascript -l JavaScript -e "Application('Reminders').lists.byName('📥 Inbox').reminders.whose({completed: false}).name().length")

if [[ $REMINDERS_COUNT -gt 0 ]]; then
  sketchybar -m --set reminders icon="󰢌" \
                --set reminders icon.font.size=18 \
                --set reminders label="$REMINDERS_COUNT"
else
  sketchybar -m --set reminders icon="" \
                --set reminders label=""
fi