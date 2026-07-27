#!/usr/bin/env bash

command_available() { which "$1" >/dev/null 2>&1; }
fzf_available() { command_available fzf; }
brew_available() { command_available brew; }

load_brew_shellenv() {
  if test -x /opt/homebrew/bin/brew; then
    brew=/opt/homebrew/bin/brew
  elif test -x /usr/local/bin/brew; then
    brew=/usr/local/bin/brew
  fi
  if test -n "${brew}"; then
    eval "$($brew shellenv)"
  fi
}

op_ensure_signed_in() {
  command_available op || brew install 1password-cli
  op whoami >/dev/null 2>&1 || op signin
}

confirm() {
  local prompt="$1"
  if [ "${DOTFILES_YES:-}" = "1" ]; then
    return 0
  fi
  read -p "$prompt " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]]
}
