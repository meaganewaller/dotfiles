#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_onchange_install-nvim-plugins.sh.tmpl"

# The hash-comment `glob` call resolves against the real -S/--source flag,
# same as `include` elsewhere in this repo's chezmoiscripts.
render() {
  cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF
  chezmoi --source home execute-template --config "$TEST_TMPDIR/config.toml" --file "$SCRIPT_FILE"
}

@test "renders a valid shell script" {
  run render
  [ "$status" -eq 0 ]
  assert_script_structure "$output"
  assert_valid_shell "$output"
}

@test "re-rendering produces identical output (template idempotence)" {
  render >"$TEST_TMPDIR/run1.sh"
  render >"$TEST_TMPDIR/run2.sh"

  run diff "$TEST_TMPDIR/run1.sh" "$TEST_TMPDIR/run2.sh"
  [ "$status" -eq 0 ]
}

@test "rendered output embeds a sha256 hash comment" {
  run render
  [ "$status" -eq 0 ]
  [[ "$output" =~ Hash:\ [0-9a-f]{64} ]]
}

@test "skips cleanly in CI without invoking nvim" {
  local rendered="$TEST_TMPDIR/nvim-plugins.sh"
  render >"$rendered"

  local stub="$TEST_TMPDIR/stub"
  mkdir -p "$stub"
  cat >"$stub/nvim" <<'EOF'
#!/usr/bin/env bash
echo "nvim called with: $*" >&2
exit 99
EOF
  chmod +x "$stub/nvim"

  run env CI=true PATH="$stub:$PATH" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Running in CI, skipping Neovim plugin sync"* ]]
}

@test "skips cleanly when nvim is unavailable" {
  local rendered="$TEST_TMPDIR/nvim-plugins.sh"
  render >"$rendered"

  # Clean PATH with only the interpreter the script needs; no nvim anywhere.
  local clean="$TEST_TMPDIR/clean"
  mkdir -p "$clean"
  ln -s "$(command -v bash)" "$clean/bash"

  run env -i PATH="$clean" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Neovim not found, skipping plugin installation"* ]]
}

@test "syncs plugins via nvim --headless Lazy sync when nvim is present" {
  local rendered="$TEST_TMPDIR/nvim-plugins.sh"
  render >"$rendered"

  local stub="$TEST_TMPDIR/stub"
  mkdir -p "$stub"
  local nvim_log="$TEST_TMPDIR/nvim.log"
  cat >"$stub/nvim" <<EOF
#!/usr/bin/env bash
echo "\$*" >>"$nvim_log"
EOF
  chmod +x "$stub/nvim"

  run env -u CI -u GITHUB_ACTIONS PATH="$stub:$PATH" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Syncing Neovim plugins..."* ]]
  [ "$(cat "$nvim_log")" = '--headless +Lazy! sync +qa' ]
}

@test "propagates failure when the nvim sync fails" {
  local rendered="$TEST_TMPDIR/nvim-plugins.sh"
  render >"$rendered"

  local stub="$TEST_TMPDIR/stub"
  mkdir -p "$stub"
  cat >"$stub/nvim" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
  chmod +x "$stub/nvim"

  run env -u CI -u GITHUB_ACTIONS PATH="$stub:$PATH" bash "$rendered"
  [ "$status" -eq 1 ]
}

@test "prints verbose progress markers when DEBUG=1" {
  local rendered="$TEST_TMPDIR/nvim-plugins.sh"
  render >"$rendered"

  local stub="$TEST_TMPDIR/stub"
  mkdir -p "$stub"
  cat >"$stub/nvim" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
  chmod +x "$stub/nvim"

  run env -u CI -u GITHUB_ACTIONS DEBUG=1 PATH="$stub:$PATH" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Installing/updating Neovim plugins due to configuration changes"* ]]
  [[ "$output" == *"Neovim plugins synchronized successfully"* ]]
}
