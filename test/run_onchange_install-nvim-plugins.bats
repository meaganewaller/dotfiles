#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_onchange_install-nvim-plugins.sh.tmpl"

# The hash comment's `glob`+`joinPath` calls read via .chezmoi.sourceDir (data,
# settable via --config), while its `include` call always reads via the real
# -S/--source flag. Point sourceDir at the same real repo so both resolve the
# same tree -- otherwise glob silently sees an empty directory and the plugin
# half of the hash goes missing without erroring (the exact class of bug this
# script had: a hash input silently contributing nothing).
render() {
  cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$PWD/home" }
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

# Regression coverage for the bug that prompted this rewrite: the old hash
# was `glob "dot_config/nvim/lua/plugins/*.lua" | join "" | sha256sum` --
# a relative pattern (glob needs an absolute one, so it silently matched
# nothing) over a directory that no longer exists post-vim.pack-migration
# anyway, and even if it had matched, glob returns file *paths*, not
# contents, so editing a plugin file without renaming it wouldn't have
# changed the hash. Build a small real fixture tree (not the repo itself,
# so it's safe to mutate) to prove the new hash reacts to both content
# edits and lockfile bumps.
copy_nvim_plugins_fixture() {
  mkdir -p "$TEST_SOURCE_DIR/dot_config/nvim/plugin"
  cat >"$TEST_SOURCE_DIR/dot_config/nvim/plugin/one.lua" <<'EOF'
vim.pack.add({ { src = "https://github.com/example/one" } })
EOF
  cat >"$TEST_SOURCE_DIR/dot_config/nvim/nvim-pack-lock.json" <<'EOF'
{"plugins":{"one":{"rev":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","src":"https://github.com/example/one"}}}
EOF
}

render_fixture() {
  cat >"$TEST_TMPDIR/fixture-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF
  chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/fixture-config.toml" --file "$SCRIPT_FILE"
}

extract_hash() {
  grep -oE '[0-9a-f]{64}' <<<"$1"
}

@test "hash changes when an existing plugin file's content changes" {
  copy_nvim_plugins_fixture
  local before after
  before=$(extract_hash "$(render_fixture)")

  cat >"$TEST_SOURCE_DIR/dot_config/nvim/plugin/one.lua" <<'EOF'
vim.pack.add({ { src = "https://github.com/example/one" }, { src = "https://github.com/example/two" } })
EOF
  after=$(extract_hash "$(render_fixture)")

  [ -n "$before" ]
  [ "$before" != "$after" ]
}

@test "hash changes when the lockfile's pinned revision changes" {
  copy_nvim_plugins_fixture
  local before after
  before=$(extract_hash "$(render_fixture)")

  cat >"$TEST_SOURCE_DIR/dot_config/nvim/nvim-pack-lock.json" <<'EOF'
{"plugins":{"one":{"rev":"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb","src":"https://github.com/example/one"}}}
EOF
  after=$(extract_hash "$(render_fixture)")

  [ -n "$before" ]
  [ "$before" != "$after" ]
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

@test "syncs plugins via vim.pack.update(force, target=lockfile) when nvim is present" {
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
  [ "$(cat "$nvim_log")" = "--headless -c lua vim.pack.update(nil, { force = true, target = 'lockfile' }) +qa" ]
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
