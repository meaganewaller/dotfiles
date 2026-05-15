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
  run run_sync
  [ "$status" -eq 0 ]

  local settings="$TEST_HOME_DIR/.claude/settings.json"
  [ -f "$settings" ]

  # Valid JSON
  run jq empty "$settings"
  [ "$status" -eq 0 ]

  # Required top-level keys set by the script
  run jq -e '.statusLine.command' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.permissions.allow | length > 0' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.hooks.PreToolUse | length > 0' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.hooks.PostToolUse | length > 0' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS == "1"' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.model' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.extraKnownMarketplaces."pickled-claude-plugins"' "$settings"
  [ "$status" -eq 0 ]
}

@test "creates a backup before mutating settings" {
  run run_sync
  [ "$status" -eq 0 ]

  [ -f "$TEST_HOME_DIR/.claude/settings.json.bak" ]
}

@test "preserves unrelated user keys in existing settings.json" {
  mkdir -p "$TEST_HOME_DIR/.claude"
  cat >"$TEST_HOME_DIR/.claude/settings.json" <<'EOF'
{
  "theme": "dark",
  "customUserKey": {"a": 1, "b": [2, 3]}
}
EOF

  run run_sync
  [ "$status" -eq 0 ]

  local settings="$TEST_HOME_DIR/.claude/settings.json"
  run jq -e '.theme == "dark"' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.customUserKey.a == 1' "$settings"
  [ "$status" -eq 0 ]
  run jq -e '.customUserKey.b == [2, 3]' "$settings"
  [ "$status" -eq 0 ]
}

@test "does not touch settings.local.json" {
  mkdir -p "$TEST_HOME_DIR/.claude"
  cat >"$TEST_HOME_DIR/.claude/settings.local.json" <<'EOF'
{"localOverride": "machine-specific", "secret": "do-not-touch"}
EOF
  local before_hash
  before_hash=$(shasum "$TEST_HOME_DIR/.claude/settings.local.json" | awk '{print $1}')

  run run_sync
  [ "$status" -eq 0 ]

  local after_hash
  after_hash=$(shasum "$TEST_HOME_DIR/.claude/settings.local.json" | awk '{print $1}')
  [ "$before_hash" = "$after_hash" ]
}

@test "is idempotent across consecutive runs" {
  run run_sync
  [ "$status" -eq 0 ]

  # Capture stable subset (excluding fields the script might re-resolve)
  local first_hash
  first_hash=$(jq -S 'del(.env.ANTHROPIC_MODEL, .env.ANTHROPIC_DEFAULT_HAIKU_MODEL, .env.ANTHROPIC_DEFAULT_SONNET_MODEL, .env.ANTHROPIC_DEFAULT_OPUS_MODEL)' \
    "$TEST_HOME_DIR/.claude/settings.json" | shasum | awk '{print $1}')

  run run_sync
  [ "$status" -eq 0 ]

  local second_hash
  second_hash=$(jq -S 'del(.env.ANTHROPIC_MODEL, .env.ANTHROPIC_DEFAULT_HAIKU_MODEL, .env.ANTHROPIC_DEFAULT_SONNET_MODEL, .env.ANTHROPIC_DEFAULT_OPUS_MODEL)' \
    "$TEST_HOME_DIR/.claude/settings.json" | shasum | awk '{print $1}')

  [ "$first_hash" = "$second_hash" ]
}
