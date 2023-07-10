#!/usr/bin/env sh

# Desc:   Run rofi-main menu with built-in modi.

# SPDX-License-Identifier: ISC

SYSTEM_LANG="$LANG"
export LANG='POSIX'
exec >/dev/null 2>&1

LANG="$SYSTEM_LANG" \
exec rofi -theme-str '@import "main.rasi"' \
          -no-lazy-grab \
          -show drun

exit ${?}
