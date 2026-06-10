#!/usr/bin/env bats

load test_helper

GUARD="home/dot_local/libexec/executable_block-adhoc-installers"

# Feed the guard a PreToolUse payload for the given Bash command on stdin.
# Prints the guard's stdout (a deny decision when blocked, nothing when allowed).
#
# Materialize the payload first and feed it via a here-string rather than a live
# `jq | guard` pipe: on the escape-hatch path the guard exits before reading
# stdin, which SIGPIPEs a piped writer and leaks a "Broken pipe" error onto
# stderr (captured by `run`). A here-string has no concurrent writer to kill.
run_guard() {
  local payload
  payload="$(jq -cn --arg c "$1" '{tool_input: {command: $c}}')"
  bash "$GUARD" <<<"$payload"
}

assert_blocked() {
  run run_guard "$1"
  [ "$status" -eq 0 ]
  if [ -z "$output" ]; then
    echo "expected BLOCK but command was allowed: $1" >&2
    return 1
  fi
  echo "$output" | jq -e '.hookSpecificOutput.permissionDecision == "deny"' >/dev/null
}

assert_allowed() {
  run run_guard "$1"
  [ "$status" -eq 0 ]
  if [ -n "$output" ]; then
    echo "expected ALLOW but command was blocked: $1 -> $output" >&2
    return 1
  fi
}

@test "blocks ad-hoc installers and runners" {
  local blocked=(
    "npx cowsay"
    "bunx create-vite"
    "uvx ruff check ."
    "pipx run black ."
    "pipx install black"
    "pip install requests"
    "pip3 install requests"
    "python -m pip install requests"
    "python3 -m pip install requests"
    "npm install -g typescript"
    "npm i -g typescript"
    "npm add --global typescript"
    "pnpm dlx create-vite"
    "pnpm add -g typescript"
    "yarn dlx create-vite"
    "yarn global add typescript"
    "uv tool install ruff"
    "uv tool run ruff"
    "uv pip install ruff"
    "gem install rubocop"
    "brew install jq"
    "cargo install ripgrep"
    "go install golang.org/x/tools/gopls@latest"
    "apt install cowsay"
    "apt-get install cowsay"
    "dnf install cowsay"
    "yum install cowsay"
  )
  for cmd in "${blocked[@]}"; do
    assert_blocked "$cmd"
  done
}

@test "allows mise and non-install / non-global commands" {
  local allowed=(
    "mise install"
    "mise use node@22"
    "brew reinstall jq"
    "brew list"
    "npm install"
    "npm ci"
    "npm run build"
    "pip --version"
    "cargo build"
    "cargo test"
    "go build ./..."
    "go test ./..."
    "yarn install"
    "pnpm install"
    "echo npx is just a word here"
    "ls -la"
    ""
  )
  for cmd in "${allowed[@]}"; do
    assert_allowed "$cmd"
  done
}

@test "strips leading sudo / env / FOO=bar wrappers before matching" {
  assert_blocked "sudo npx cowsay"
  assert_blocked "env npx cowsay"
  assert_blocked "FOO=bar npx cowsay"
  assert_blocked "sudo pip install requests"
}

@test "inspects every segment of a compound command" {
  assert_blocked "ls && npx cowsay"
  assert_blocked "cd /tmp; pip install requests"
  assert_blocked "true || gem install rubocop"
  assert_blocked "echo hi | npx cowsay"
  # All segments benign -> allowed.
  assert_allowed "cd /tmp && mise install && ls"
}

@test "honors the human escape hatch" {
  export CLAUDE_ALLOW_ADHOC_INSTALL=1
  run run_guard "npx cowsay"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "ignores tool calls with no command" {
  run bash -c 'printf "%s" "{}" | bash "'"$GUARD"'"'
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "deny reason points at the /install skill" {
  run run_guard "npx cowsay"
  [ "$status" -eq 0 ]
  echo "$output" | jq -e '.hookSpecificOutput.permissionDecisionReason | test("/install")' >/dev/null
}
