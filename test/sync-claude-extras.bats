#!/usr/bin/env bats

load test_helper

SCRIPT="bin/sync-claude-extras"

# Stub the `claude` and `chezmoi` CLIs the reconciler shells out to. The claude
# stub logs every invocation to $CLAUDE_LOG so tests can assert which mutating
# commands ran (none, under --check). chezmoi data returns a fixed declared set
# with one already-present and one missing item per type, plus an undeclared
# plugin to exercise drift detection.
make_stubs() {
  STUBDIR="$TEST_TMPDIR/stub"
  CLAUDE_LOG="$TEST_TMPDIR/claude.log"
  mkdir -p "$STUBDIR"
  : >"$CLAUDE_LOG"

  cat >"$STUBDIR/claude" <<EOF
#!/usr/bin/env bash
echo "\$*" >> "$CLAUDE_LOG"
case "\$*" in
  "plugin marketplace list --json") echo '[{"name":"mp-existing"},{"name":"claude-plugins-official"},{"name":"mp-orphan"}]' ;;
  "plugin list --json") echo '[{"id":"p-existing@mp-existing","scope":"user"},{"id":"p-orphan@mp-existing","scope":"user"}]' ;;
  *) echo '[]' ;;
esac
EOF
  chmod +x "$STUBDIR/claude"

  cat >"$STUBDIR/chezmoi" <<'EOF'
#!/usr/bin/env bash
if [ "$1" = data ]; then
  cat <<'JSON'
{
  "claudeData": {
    "marketplaces": [
      { "name": "mp-existing", "repo": "owner/existing" },
      { "name": "mp-new",      "repo": "owner/new" }
    ],
    "plugins": [
      "p-existing@mp-existing",
      "p-new@mp-existing"
    ],
    "mcpServers": []
  }
}
JSON
fi
EOF
  chmod +x "$STUBDIR/chezmoi"
}

run_extras() {
  run env PATH="$STUBDIR:$PATH" HOME="$TEST_HOME_DIR" GITHUB_TOKEN=stub-token \
    CLAUDE_LOG="$CLAUDE_LOG" bash "$SCRIPT" "$@"
}

@test "claude.yaml is valid YAML with the structure the reconciler expects" {
  assert_valid_yaml home/.chezmoidata/claude.yaml

  # Convert to JSON once, then assert shape with jq (unambiguous semantics).
  local json
  json=$(yq -o=json '.' home/.chezmoidata/claude.yaml)

  # marketplaces: non-empty list of {name, repo}
  echo "$json" | jq -e '.claudeData.marketplaces | length > 0'
  echo "$json" | jq -e '.claudeData.marketplaces | all(has("name") and has("repo"))'
  # plugins: non-empty list of strings (<id>@<marketplace>)
  echo "$json" | jq -e '.claudeData.plugins | length > 0'
  echo "$json" | jq -e '.claudeData.plugins | all(type == "string")'
  # mcpServers: present (may be empty)
  echo "$json" | jq -e '.claudeData | has("mcpServers")'
}

@test "--check reports ok / add / drift without mutating anything" {
  make_stubs
  run_extras --check
  [ "$status" -eq 0 ]

  # Present items are ok; missing items are would-adds.
  [[ "$output" == *"ok: mp-existing"* ]]
  [[ "$output" == *"add mp-new"* ]]
  [[ "$output" == *"ok: p-existing@mp-existing"* ]]
  [[ "$output" == *"install p-new@mp-existing"* ]]

  # An installed-but-undeclared plugin is reported as drift, not removed.
  [[ "$output" == *"drift: plugin p-orphan@mp-existing"* ]]

  # A built-in marketplace is never flagged as drift (not ours to manage)...
  [[ "$output" != *"drift: marketplace claude-plugins-official"* ]]
  # ...but a non-built-in undeclared marketplace still is.
  [[ "$output" == *"drift: marketplace mp-orphan"* ]]

  # Dry run: only read-only `list` calls hit the claude CLI — no add/install/remove.
  run grep -E 'install|add|remove|uninstall' "$CLAUDE_LOG"
  [ "$status" -ne 0 ]
}

@test "a real run installs only the missing items" {
  make_stubs
  run_extras
  [ "$status" -eq 0 ]

  # Missing items were created via the claude CLI.
  grep -qF 'plugin marketplace add owner/new' "$CLAUDE_LOG"
  grep -qF 'plugin install p-new@mp-existing --scope user' "$CLAUDE_LOG"

  # Already-present items were not re-added.
  run grep -F 'plugin marketplace add owner/existing' "$CLAUDE_LOG"
  [ "$status" -ne 0 ]
  run grep -F 'plugin install p-existing@mp-existing' "$CLAUDE_LOG"
  [ "$status" -ne 0 ]
}

@test "skips cleanly when the claude CLI is absent" {
  # Clean PATH with the interpreter the script needs, but no claude.
  local clean="$TEST_TMPDIR/clean"
  mkdir -p "$clean"
  local c
  for c in bash jq grep; do ln -s "$(command -v "$c")" "$clean/$c"; done

  run env -i PATH="$clean" HOME="$TEST_HOME_DIR" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"claude not found"* ]]
}

@test "--prune removes undeclared user-scope items" {
  make_stubs
  run_extras --prune
  [ "$status" -eq 0 ]

  # The undeclared plugin is uninstalled; declared ones are not.
  grep -qF 'plugin uninstall p-orphan@mp-existing' "$CLAUDE_LOG"
  run grep -F 'uninstall p-existing@mp-existing' "$CLAUDE_LOG"
  [ "$status" -ne 0 ]

  # The undeclared non-built-in marketplace is removed; the built-in is not.
  grep -qF 'plugin marketplace remove mp-orphan' "$CLAUDE_LOG"
  run grep -F 'marketplace remove claude-plugins-official' "$CLAUDE_LOG"
  [ "$status" -ne 0 ]
}

@test "rejects unknown arguments" {
  make_stubs
  run_extras --bogus
  [ "$status" -eq 2 ]
}
