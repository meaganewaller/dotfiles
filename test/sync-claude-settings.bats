#!/usr/bin/env bats

load test_helper

TEMPLATE_FILE="home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl"
SYNC_SCRIPT="bin/sync-claude-settings"

template_config() {
  local work_profile="${1:-false}"
  cat >"$TEST_TMPDIR/sync-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR", workingTree = "$PWD" }
    work_profile = $work_profile
EOF
  printf '%s\n' "$TEST_TMPDIR/sync-config.toml"
}

run_sync() {
  env HOME="$TEST_HOME_DIR" bash "$SYNC_SCRIPT"
}

@test "template renders to valid shell" {
  local config
  config=$(template_config false)

  run chezmoi execute-template --config "$config" --file "$TEMPLATE_FILE"
  [ "$status" -eq 0 ]
  assert_script_structure "$output"
  assert_valid_shell "$output"
}

@test "template invokes bin/sync-claude-settings" {
  local config
  config=$(template_config false)

  run chezmoi execute-template --config "$config" --file "$TEMPLATE_FILE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"bin/sync-claude-settings"* ]]
}

@test "template output is identical for work_profile=true and work_profile=false" {
  local work_config personal_config

  work_config=$(template_config true)
  personal_config=$(template_config false)

  chezmoi execute-template --config "$work_config" --file "$TEMPLATE_FILE" >"$TEST_TMPDIR/work.sh"
  chezmoi execute-template --config "$personal_config" --file "$TEMPLATE_FILE" >"$TEST_TMPDIR/personal.sh"

  run diff "$TEST_TMPDIR/work.sh" "$TEST_TMPDIR/personal.sh"
  [ "$status" -eq 0 ]
}

@test "creates settings.json with required keys in a fresh HOME" {
  # Create a default account directory (multi-account setup)
  mkdir -p "$TEST_HOME_DIR/.claude-personal"

  run run_sync
  [ "$status" -eq 0 ]

  local settings="$TEST_HOME_DIR/.claude-personal/settings.json"
  [ -f "$settings" ]

  # Valid JSON
  run jq empty "$settings"
  [ "$status" -eq 0 ]

  # Required top-level keys set by the script
  run jq -e '.statusLine.command' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.permissions.allow | length > 0' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS == "1"' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.model' "$settings"
  [ "$status" -eq 0 ]

  # Hooks are now managed by individual account directories via chezmoi (not by sync script).
  # Previously deprecated hooks (check-secrets, guard-destructive, migration-reminder) are no longer registered.
  # Hooks that are deployed via chezmoi (like tmux-bell.sh) are preserved.
  # This test just verifies the script doesn't crash; actual hook presence is tested elsewhere.

  # Plugins / marketplaces are no longer written into settings.json (ADR 0008);
  # bin/sync-claude-extras owns them via the claude CLI.
  run jq -e 'has("extraKnownMarketplaces")' "$settings"
  [ "$status" -ne 0 ]
  run jq -e 'has("enabledPlugins")' "$settings"
  [ "$status" -ne 0 ]
}

@test "creates a backup before mutating settings" {
  # Create a default account directory (multi-account setup)
  mkdir -p "$TEST_HOME_DIR/.claude-personal"

  run run_sync
  [ "$status" -eq 0 ]

  [ -f "$TEST_HOME_DIR/.claude-personal/settings.json.bak" ]
}

@test "preserves unrelated user keys in existing settings.json" {
  mkdir -p "$TEST_HOME_DIR/.claude-personal"
  cat >"$TEST_HOME_DIR/.claude-personal/settings.json" <<'EOF'
{
  "theme": "dark",
  "customUserKey": {"a": 1, "b": [2, 3]}
}
EOF

  run run_sync
  [ "$status" -eq 0 ]

  local settings="$TEST_HOME_DIR/.claude-personal/settings.json"
  run jq -e '.theme == "dark"' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.customUserKey.a == 1' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.customUserKey.b == [2, 3]' "$settings"
  [ "$status" -eq 0 ]
}

@test "does not touch settings.local.json" {
  mkdir -p "$TEST_HOME_DIR/.claude-personal"
  cat >"$TEST_HOME_DIR/.claude-personal/settings.local.json" <<'EOF'
{"localOverride": "machine-specific", "secret": "do-not-touch"}
EOF
  local before_hash
  before_hash=$(shasum "$TEST_HOME_DIR/.claude-personal/settings.local.json" | awk '{print $1}')

  run run_sync
  [ "$status" -eq 0 ]

  local after_hash
  after_hash=$(shasum "$TEST_HOME_DIR/.claude-personal/settings.local.json" | awk '{print $1}')
  [ "$before_hash" = "$after_hash" ]
}

@test "is idempotent across consecutive runs" {
  # Create a default account directory (multi-account setup)
  mkdir -p "$TEST_HOME_DIR/.claude-personal"

  run run_sync
  [ "$status" -eq 0 ]

  # Capture stable subset (excluding fields the script might re-resolve)
  local first_hash
  first_hash=$(jq -S 'del(.env.ANTHROPIC_MODEL, .env.ANTHROPIC_DEFAULT_HAIKU_MODEL, .env.ANTHROPIC_DEFAULT_SONNET_MODEL, .env.ANTHROPIC_DEFAULT_OPUS_MODEL)' \
    "$TEST_HOME_DIR/.claude-personal/settings.json" | shasum | awk '{print $1}')

  run run_sync
  [ "$status" -eq 0 ]

  local second_hash
  second_hash=$(jq -S 'del(.env.ANTHROPIC_MODEL, .env.ANTHROPIC_DEFAULT_HAIKU_MODEL, .env.ANTHROPIC_DEFAULT_SONNET_MODEL, .env.ANTHROPIC_DEFAULT_OPUS_MODEL)' \
    "$TEST_HOME_DIR/.claude-personal/settings.json" | shasum | awk '{print $1}')

  [ "$first_hash" = "$second_hash" ]
}

@test "does not modify hooks (managed via chezmoi, not sync script)" {
  mkdir -p "$TEST_HOME_DIR/.claude-personal"
  cat >"$TEST_HOME_DIR/.claude-personal/settings.json" <<'EOF'
{
  "hooks": {
    "Notification": [
      { "matcher": ".*", "hooks": [ { "type": "command", "command": "~/.claude/hooks/tmux-bell.sh" } ] }
    ]
  }
}
EOF

  run run_sync
  [ "$status" -eq 0 ]
  local settings="$TEST_HOME_DIR/.claude-personal/settings.json"

  # Existing hooks are preserved (not modified by the sync script).
  run jq -e '.hooks.Notification[0].hooks[0].command | contains("tmux-bell.sh")' "$settings"
  [ "$status" -eq 0 ]

  # Re-running yields identical hooks (idempotent, no modifications).
  local first second
  first=$(jq -S '.hooks' "$settings")
  run run_sync
  [ "$status" -eq 0 ]
  second=$(jq -S '.hooks' "$settings")
  [ "$first" = "$second" ]
}
