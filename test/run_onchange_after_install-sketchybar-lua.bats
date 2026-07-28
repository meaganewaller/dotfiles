#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_onchange_after_install-sketchybar-lua.sh.tmpl"

# The template's hash comment calls `include` on
# .chezmoiexternals/sketchybar-lua.toml.tmpl, which chezmoi resolves against
# its real source directory (the -S/--source flag), not the .chezmoi.sourceDir
# *data* value set via --config. So every render here must pass --source.
render() {
  local os="$1"
  cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    chezmoi = { os = "$os", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF
  chezmoi --source home execute-template --config "$TEST_TMPDIR/config.toml" --file "$SCRIPT_FILE"
}

@test "does not render on non-darwin systems" {
  run render linux
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "renders a valid shell script on darwin" {
  run render darwin
  [ "$status" -eq 0 ]
  assert_script_structure "$output"
  assert_valid_shell "$output"
}

@test "rendered script has a CI skip guard" {
  run render darwin
  [ "$status" -eq 0 ]
  # shellcheck disable=SC2016 # matching literal shell syntax in rendered output
  [[ "$output" == *'${CI:-}'* ]]
  # shellcheck disable=SC2016 # matching literal shell syntax in rendered output
  [[ "$output" == *'${GITHUB_ACTIONS:-}'* ]]
  [[ "$output" == *"Running in CI, skipping SbarLua build"* ]]
}

@test "skips cleanly in CI without invoking make" {
  local rendered="$TEST_TMPDIR/sketchybar-lua.sh"
  render darwin >"$rendered"

  local stub="$TEST_TMPDIR/stub"
  mkdir -p "$stub"
  cat >"$stub/make" <<'EOF'
#!/usr/bin/env bash
echo "make called with: $*" >&2
exit 99
EOF
  chmod +x "$stub/make"

  run env CI=true PATH="$stub:$PATH" HOME="$TEST_HOME_DIR" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Running in CI, skipping SbarLua build"* ]]
}

@test "skips cleanly when the external source hasn't been cloned yet" {
  local rendered="$TEST_TMPDIR/sketchybar-lua.sh"
  render darwin >"$rendered"

  # $TEST_HOME_DIR/.local/share/sketchybar_lua/src is intentionally absent,
  # simulating a chezmoi apply where the external hasn't materialized yet.
  run env -u CI -u GITHUB_ACTIONS HOME="$TEST_HOME_DIR" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"chezmoi external not applied yet"* ]]
}

@test "skips cleanly when make is unavailable" {
  local rendered="$TEST_TMPDIR/sketchybar-lua.sh"
  render darwin >"$rendered"

  mkdir -p "$TEST_HOME_DIR/.local/share/sketchybar_lua/src"

  # Clean PATH with only the interpreter the script needs; no make anywhere.
  local clean="$TEST_TMPDIR/clean"
  mkdir -p "$clean"
  ln -s "$(command -v bash)" "$clean/bash"

  run env -i PATH="$clean" HOME="$TEST_HOME_DIR" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"make not found"* ]]
}

@test "builds and installs the module when make succeeds" {
  local rendered="$TEST_TMPDIR/sketchybar-lua.sh"
  render darwin >"$rendered"

  local src="$TEST_HOME_DIR/.local/share/sketchybar_lua/src"
  local module="$TEST_HOME_DIR/.local/share/sketchybar_lua/sketchybar.so"
  mkdir -p "$src"

  local stub="$TEST_TMPDIR/stub"
  mkdir -p "$stub"
  cat >"$stub/make" <<EOF
#!/usr/bin/env bash
# Simulate 'make -C \$src clean' (no-op) then 'make -C \$src install', which
# the real Makefile uses to produce the .so at \$module.
for arg in "\$@"; do
  if [ "\$arg" = "install" ]; then
    : >"$module"
  fi
done
EOF
  chmod +x "$stub/make"

  run env -u CI -u GITHUB_ACTIONS PATH="$stub:$PATH" HOME="$TEST_HOME_DIR" bash "$rendered"
  [ "$status" -eq 0 ]
  [[ "$output" == *"SbarLua installed: $module"* ]]
}

@test "fails loudly when make succeeds but the module never appears" {
  local rendered="$TEST_TMPDIR/sketchybar-lua.sh"
  render darwin >"$rendered"

  mkdir -p "$TEST_HOME_DIR/.local/share/sketchybar_lua/src"

  local stub="$TEST_TMPDIR/stub"
  mkdir -p "$stub"
  cat >"$stub/make" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
  chmod +x "$stub/make"

  run env -u CI -u GITHUB_ACTIONS PATH="$stub:$PATH" HOME="$TEST_HOME_DIR" bash "$rendered"
  [ "$status" -eq 1 ]
  [[ "$output" == *"check the build output above"* ]]
}
