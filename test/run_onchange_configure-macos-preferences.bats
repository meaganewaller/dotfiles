#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_onchange_configure-macos-preferences.sh.tmpl"

darwin_config() {
  local work_profile="${1:-false}"
  cat >"$TEST_TMPDIR/darwin-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    work_profile = $work_profile
EOF
  printf '%s\n' "$TEST_TMPDIR/darwin-config.toml"
}

@test "does not render on non-darwin systems" {
  cat >"$TEST_TMPDIR/linux-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    work_profile = false
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/linux-config.toml" --file "$SCRIPT_FILE"
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "renders a valid shell script on darwin" {
  local config
  config=$(darwin_config false)

  run chezmoi execute-template --config "$config" --file "$SCRIPT_FILE"
  [ "$status" -eq 0 ]
  assert_script_structure "$output"
  assert_valid_shell "$output"
}

@test "rendered script contains all expected preference sections" {
  local config
  config=$(darwin_config false)

  run chezmoi execute-template --config "$config" --file "$SCRIPT_FILE"
  [ "$status" -eq 0 ]

  # Each managed preference should be present
  [[ "$output" == *"AppleSymbolicHotKeys"* ]]
  [[ "$output" == *"com.raycast.macos"* ]]
  [[ "$output" == *"Monterey Graphic"* ]]
  [[ "$output" == *"KeyRepeat"* ]]
  [[ "$output" == *"AppleKeyboardUIMode"* ]]
  [[ "$output" == *"closeViewScrollWheelToggle"* ]]
  [[ "$output" == *"com.apple.dock"* ]]
  [[ "$output" == *"VisibleCC Bluetooth"* ]]
}

@test "rendered script has CI skip guard" {
  local config
  config=$(darwin_config false)

  run chezmoi execute-template --config "$config" --file "$SCRIPT_FILE"
  [ "$status" -eq 0 ]
  # shellcheck disable=SC2016 # matching literal shell syntax in rendered output
  [[ "$output" == *'${CI:-}'* ]]
  # shellcheck disable=SC2016 # matching literal shell syntax in rendered output
  [[ "$output" == *'${GITHUB_ACTIONS:-}'* ]]
  [[ "$output" == *"Running in CI, skipping macOS preferences"* ]]
}

@test "rendered output is identical for work_profile=true and work_profile=false" {
  local work_config personal_config

  work_config=$(darwin_config true)
  personal_config=$(darwin_config false)

  chezmoi execute-template --config "$work_config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/work.sh"
  chezmoi execute-template --config "$personal_config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/personal.sh"

  run diff "$TEST_TMPDIR/work.sh" "$TEST_TMPDIR/personal.sh"
  [ "$status" -eq 0 ]
}

@test "re-rendering produces identical output (template idempotence)" {
  local config
  config=$(darwin_config false)

  chezmoi execute-template --config "$config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/run1.sh"
  chezmoi execute-template --config "$config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/run2.sh"

  run diff "$TEST_TMPDIR/run1.sh" "$TEST_TMPDIR/run2.sh"
  [ "$status" -eq 0 ]
}

@test "executing rendered script with CI=true exits cleanly without writing defaults" {
  local config rendered
  config=$(darwin_config false)
  rendered="$TEST_TMPDIR/configure-macos-preferences.sh"

  chezmoi execute-template --config "$config" --file "$SCRIPT_FILE" >"$rendered"
  chmod +x "$rendered"

  # Stub defaults/plutil/osascript/killall: if the CI guard works,
  # none of these should be invoked. Each stub fails loudly if called.
  cat >"$TEST_TMPDIR/defaults" <<'EOF'
#!/usr/bin/env bash
echo "defaults called with: $*" >&2
exit 99
EOF
  cp "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/plutil"
  cp "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/osascript"
  cp "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/killall"
  chmod +x "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/plutil" "$TEST_TMPDIR/osascript" "$TEST_TMPDIR/killall"

  run env CI=true PATH="$TEST_TMPDIR:$PATH" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Running in CI, skipping macOS preferences"* ]]
}
