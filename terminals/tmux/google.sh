#!/usr/bin/env bash

function tmux-get-open-command() {
  local open_cmd

  case "$OSTYPE" in
  darwin*)
    open_cmd="open"
    ;;
  linux*)
    open_cmd="xdg-open"
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
  esac
  echo "$open_cmd"
}

OSTYPE="$(uname -s)"

pyScript='import sys,urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip(), safe=""))'

if [[ "$1" == "google" ]]; then
  case "$OSTYPE" in
  darwin*)
    out="$(pbpaste | python3 -c "$pyScript")"
    ;;
  linux*)
    out="$(xclip -o -sel clip | python3 -c "$pyScript")"
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
  esac
else
  case "$OSTYPE" in
  darwin*)
    out="$(pbpaste)"
    ;;
  linux*)
    out="$(xclip -o -sel clip)"
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
  esac

  out="$(printf -- "%s" "$out" | perl -pe 's@^\s+|\s+$@@g')"
fi

cmd="$(tmux-get-open-command)"

if [[ "$1" == open ]]; then
  dir="$(cat $HOME/.config/tmux/local/pane_pwd)"
  echo "Pane dir is '$dir'"
  echo "Direct open '$cmd' to '$out'"

  if ! ${cmd} "$out"; then
    if [[ -e "$dir/$out" ]]; then
      echo "failback open '$cmd' to '$dir/$out'"
      ${cmd} "$dir/$out"
    else
      echo "failback open '$cmd' to 'https://$out'"
      ${cmd} "https://$out"
    fi
  fi
elif [[ "$1" == google ]]; then
  echo "Google search '$cmd' to '$out'"
  ${cmd} "https://google.com/search?q=$out"
else
  echo "Unsupported subcommand '$1' to '$out'" >&2
fi
