#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_once_install-claude-code.sh"

@test "has valid shell syntax and structure" {
  local script
  script=$(cat "$SCRIPT_FILE")

  assert_script_structure "$script"
  assert_valid_shell "$script"
}

@test "skips install in CI without invoking curl" {
  local stub_dir="$TEST_TMPDIR/stub"
  mkdir -p "$stub_dir"
  cat >"$stub_dir/curl" <<'EOF'
#!/usr/bin/env bash
echo "curl called with: $*" >&2
exit 99
EOF
  chmod +x "$stub_dir/curl"

  run env CI=true PATH="$stub_dir:$PATH" bash "$SCRIPT_FILE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Running in CI, skipping Claude Code install"* ]]
}

@test "skips install when claude is already on PATH" {
  local stub_dir="$TEST_TMPDIR/stub"
  mkdir -p "$stub_dir"
  cat >"$stub_dir/claude" <<'EOF'
#!/usr/bin/env bash
[ "$1" = "--version" ] && echo "1.2.3 (Claude Code)"
EOF
  chmod +x "$stub_dir/claude"
  local curl_log="$TEST_TMPDIR/curl.log"
  cat >"$stub_dir/curl" <<EOF
#!/usr/bin/env bash
echo "\$*" >>"$curl_log"
exit 99
EOF
  chmod +x "$stub_dir/curl"

  # Explicitly clear CI/GITHUB_ACTIONS: real CI runners set these, and this
  # test exercises the already-installed branch that only matters off-CI.
  run env -u CI -u GITHUB_ACTIONS PATH="$stub_dir:$PATH" bash "$SCRIPT_FILE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Claude Code already installed: 1.2.3 (Claude Code)"* ]]
  [ ! -f "$curl_log" ]
}

@test "installs via curl | bash when claude is absent and not in CI" {
  local marker="$TEST_TMPDIR/installed.marker"

  # Fully isolated PATH: only the interpreter plus a curl stub that emits a
  # tiny script marking that it ran. No 'claude' stub, so command -v claude
  # fails and the install branch runs. env -i avoids leaking a real 'claude'
  # or 'curl' from the host machine's actual PATH.
  local clean="$TEST_TMPDIR/clean"
  mkdir -p "$clean"
  ln -s "$(command -v bash)" "$clean/bash"
  cat >"$clean/curl" <<EOF
#!/usr/bin/env bash
echo ': > "$marker"'
EOF
  chmod +x "$clean/curl"

  run env -i PATH="$clean" bash "$SCRIPT_FILE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing Claude Code..."* ]]
  [[ "$output" == *"Claude Code installation complete"* ]]
  [ -f "$marker" ]
}
