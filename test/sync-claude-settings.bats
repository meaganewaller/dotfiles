#!/usr/bin/env bats
#
# bin/sync-claude-settings is now only the AWS Bedrock model overlay -- the rest
# of the settings surface is data (see test/claude-settings-template.bats).

load test_helper

TEMPLATE_FILE="home/.chezmoiscripts/run_onchange_after_sync-claude-settings.sh.tmpl"
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

# Seed an account with a settings.json shaped like the modify_ template's output.
seed_account() {
	local account="$1" extra="${2-}"
	[[ -z "$extra" ]] && extra='{}'
	mkdir -p "$TEST_HOME_DIR/.claude-$account"
	jq -n --argjson extra "$extra" '{
    model: "opus[1m]",
    effortLevel: "xhigh",
    env: {CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"},
    permissions: {defaultMode: "auto", allow: ["Bash(ls:*)"]}
  } * $extra' >"$TEST_HOME_DIR/.claude-$account/settings.json"
}

run_sync() {
	env HOME="$TEST_HOME_DIR" bash "$SYNC_SCRIPT"
}

# Stage the sync script beside stub `chezmoi` (reporting use_bedrock=true) and
# `resolve-bedrock-models`, so the Bedrock path runs without an AWS call. The
# script resolves the resolver relative to its own directory, hence the copy.
# Pass "fail" to make model resolution exit non-zero.
stage_bedrock_stubs() {
	local mode="${1:-ok}"
	local bin="$TEST_TMPDIR/stub-bin"
	mkdir -p "$bin"

	cp "$SYNC_SCRIPT" "$bin/sync-claude-settings"

	if [[ "$mode" == "fail" ]]; then
		cat >"$bin/resolve-bedrock-models" <<'EOF'
#!/bin/sh
exit 1
EOF
	else
		cat >"$bin/resolve-bedrock-models" <<'EOF'
#!/bin/sh
printf '{"haiku":"anthropic.haiku-x","sonnet":"anthropic.sonnet-x","opus":"anthropic.opus-x"}\n'
EOF
	fi

	cat >"$bin/chezmoi" <<'EOF'
#!/bin/sh
printf '{"claude":{"use_bedrock":true}}\n'
EOF
	chmod +x "$bin"/*

	printf '%s\n' "$bin"
}

run_sync_with_bedrock() {
	local bin
	bin=$(stage_bedrock_stubs "${1:-ok}")
	env HOME="$TEST_HOME_DIR" PATH="$bin:$PATH" bash "$bin/sync-claude-settings"
}

@test "template renders to valid shell" {
	local config
	config=$(template_config false)

	run chezmoi execute-template --config "$config" --file "$TEMPLATE_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	assert_script_structure "$output"
	assert_valid_shell "$output"
}

@test "template invokes bin/sync-claude-settings" {
	local config
	config=$(template_config false)

	run chezmoi execute-template --config "$config" --file "$TEMPLATE_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"bin/sync-claude-settings"* ]] || fail "output was: $output"
}

@test "template output is identical for work_profile=true and work_profile=false" {
	local work_config personal_config

	work_config=$(template_config true)
	personal_config=$(template_config false)

	chezmoi execute-template --config "$work_config" --file "$TEMPLATE_FILE" >"$TEST_TMPDIR/work.sh"
	chezmoi execute-template --config "$personal_config" --file "$TEMPLATE_FILE" >"$TEST_TMPDIR/personal.sh"

	run diff "$TEST_TMPDIR/work.sh" "$TEST_TMPDIR/personal.sh"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "runs as an after-script so its model wins over the rendered default" {
	# Ordering is load-bearing: the modify_ template writes .model during the file
	# pass, so a plain run_onchange_ could be overwritten by it.
	[ -f "$TEMPLATE_FILE" ] || fail "assertion did not hold"
	[[ "$TEMPLATE_FILE" == *"/run_onchange_after_"* ]] || fail "assertion did not hold"
}

@test "skips accounts that have no settings.json yet" {
	mkdir -p "$TEST_HOME_DIR/.claude-personal"

	run run_sync
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"skipping"* ]] || fail "output was: $output"
	[ ! -f "$TEST_HOME_DIR/.claude-personal/settings.json" ] || fail "assertion did not hold"
}

@test "does not own the static settings surface" {
	# Those keys are the template's job; this script must leave them untouched.
	run grep -nE 'set_permissions|set_feature_flags|set_status_line|set_hooks|set_default_model|permissions\.allow' "$SYNC_SCRIPT"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
}

@test "leaves declared settings alone when bedrock is off" {
	seed_account personal

	run run_sync
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local settings="$TEST_HOME_DIR/.claude-personal/settings.json"
	run jq -e '.model == "opus[1m]"' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.effortLevel == "xhigh"' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.permissions.allow == ["Bash(ls:*)"]' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "removes stale bedrock env vars when bedrock is off" {
	seed_account personal '{"env": {"ANTHROPIC_MODEL": "old", "ANTHROPIC_DEFAULT_OPUS_MODEL": "old"}}'

	run run_sync
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local settings="$TEST_HOME_DIR/.claude-personal/settings.json"
	run jq -e '.env | has("ANTHROPIC_MODEL")' "$settings"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run jq -e '.env | has("ANTHROPIC_DEFAULT_OPUS_MODEL")' "$settings"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"

	# Unrelated env vars survive the cleanup.
	run jq -e '.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS == "1"' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "merges resolved bedrock models when bedrock is on" {
	seed_account personal

	run run_sync_with_bedrock
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local settings="$TEST_HOME_DIR/.claude-personal/settings.json"
	# Opus and Sonnet gain the [1m] extended-context suffix; Haiku does not.
	run jq -e '.env.ANTHROPIC_DEFAULT_OPUS_MODEL == "anthropic.opus-x[1m]"' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.env.ANTHROPIC_DEFAULT_SONNET_MODEL == "anthropic.sonnet-x[1m]"' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.env.ANTHROPIC_DEFAULT_HAIKU_MODEL == "anthropic.haiku-x"' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# The overlay wins over the model the template declared.
	run jq -e '.model == "anthropic.opus-x[1m]"' "$settings"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "processes every detected account" {
	seed_account personal '{"env": {"ANTHROPIC_MODEL": "old"}}'
	seed_account work '{"env": {"ANTHROPIC_MODEL": "old"}}'

	run run_sync
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local account
	for account in personal work; do
		run jq -e '.env | has("ANTHROPIC_MODEL")' "$TEST_HOME_DIR/.claude-$account/settings.json"
		[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	done
}

@test "does not touch settings.local.json" {
	seed_account personal
	cat >"$TEST_HOME_DIR/.claude-personal/settings.local.json" <<'EOF'
{"localOverride": "machine-specific", "secret": "do-not-touch"}
EOF
	local before_hash
	before_hash=$(shasum "$TEST_HOME_DIR/.claude-personal/settings.local.json" | awk '{print $1}')

	run run_sync
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local after_hash
	after_hash=$(shasum "$TEST_HOME_DIR/.claude-personal/settings.local.json" | awk '{print $1}')
	[ "$before_hash" = "$after_hash" ] || fail "assertion did not hold"
}

@test "is idempotent across consecutive runs" {
	seed_account personal '{"env": {"ANTHROPIC_MODEL": "old"}}'

	run run_sync
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	local first_hash
	first_hash=$(jq -S . "$TEST_HOME_DIR/.claude-personal/settings.json" | shasum | awk '{print $1}')

	run run_sync
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	local second_hash
	second_hash=$(jq -S . "$TEST_HOME_DIR/.claude-personal/settings.json" | shasum | awk '{print $1}')

	[ "$first_hash" = "$second_hash" ] || fail "assertion did not hold"
}

@test "leaves settings.json intact when model resolution fails" {
	seed_account personal
	local before
	before=$(jq -S . "$TEST_HOME_DIR/.claude-personal/settings.json")

	run run_sync_with_bedrock fail
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	[ "$before" = "$(jq -S . "$TEST_HOME_DIR/.claude-personal/settings.json")" ] || fail "assertion did not hold"
	[ ! -f "$TEST_HOME_DIR/.claude-personal/settings.json.tmp" ] || fail "assertion did not hold"
}
