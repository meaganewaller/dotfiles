#!/usr/bin/env bash

PATH="$PATH:/usr/local/bin:/usr/bin"

cat "$HOME"/.config/kitty/keymaps.conf "$HOME"/.config/kitty/splits.conf |
egrep "^map" |
cut -c4- |
sort |
column -t -s'#' |
fzf --layout=reverse
