#!/usr/bin/env bash

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/stdlib.sh"

subcommand=$1
if [ -z "$subcommand" ]; then
  usage
  exit 1
fi

gh_path=$(which gh 2>/dev/null)

function check() {
  checking_header "for 'gh' on your PATH"

  if [[ -z "$gh_path" ]]; then
    problem "Couldn't find gh on the PATH"
    exit 1
  else
    ok "found at: ${gh_path}"
  fi
}

function fix() {
  fixing_header "missing 'gh' on your PATH"

  if [[ -z "$gh_path" ]]; then
    fixing "Installing github command line tool (gh) with homebrew"
    brew install gh
  else
    ok "gh already installed, found at: ${gh_path}"
  fi
}

case "$subcommand" in
fix) fix ;;
check) check ;;
*)
  echo "Don't know how to '$subcommand'"
  exit 1
  ;;
esac
