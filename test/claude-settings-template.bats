#!/usr/bin/env bats
#
# Covers the declarative settings surface: home/.chezmoidata/claude.yaml plus
# claude-permissions.yaml, rendered by home/.chezmoitemplates/claude-settings
# through each account's modify_private_settings.json.tmpl.

load test_helper

FAKE_HOME="/home/tester"

# A config that pins homeDir so rendered paths are assertable, and points
# sourceDir at the repo (.chezmoiroot redirects it to home/, same as real use).
template_config() {
	cat >"$TEST_TMPDIR/render.toml" <<EOF
sourceDir = "$PWD"
[data]
    chezmoi = { os = "linux", homeDir = "$FAKE_HOME" }
EOF
	printf '%s\n' "$TEST_TMPDIR/render.toml"
}

# Render an account's modify_ script to a runnable file, echoing its path.
render_modify() {
	local account="$1" config
	config=$(template_config)
	chezmoi execute-template --config "$config" \
		--file "home/private_dot_claude-$account/modify_private_settings.json.tmpl" \
		</dev/null >"$TEST_TMPDIR/modify-$account.sh"
	printf '%s\n' "$TEST_TMPDIR/modify-$account.sh"
}

# Every account in the data, one per line. Read from claude.yaml rather than
# hardcoded so adding an account (a new consulting client, say) is covered here
# without a test edit -- and so an account declared without a matching
# home/private_dot_claude-<account>/ source dir fails loudly instead of silently
# never being rendered.
all_accounts() {
	yq -r '.claudeData | keys | .[] | select(. != "shared")' home/.chezmoidata/claude.yaml
}

# Run an account's modify_ script over the JSON on stdin (default: empty input,
# which yields the declared settings verbatim).
run_modify() {
	local account="$1" input="${2-}" script
	script=$(render_modify "$account")
	printf '%s' "$input" | bash "$script"
}

@test "modify template renders to valid shell for every account" {
	local account script
	while read -r account; do
		script=$(render_modify "$account")
		run bash -n "$script"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run assert_script_structure "$(cat "$script")"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
	done < <(all_accounts)
}

@test "renders valid JSON on empty input" {
	local account
	while read -r account; do
		run_modify "$account" >"$TEST_TMPDIR/out.json"
		run jq empty "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
	done < <(all_accounts)
}

@test "shared settings reach every account" {
	local account
	while read -r account; do
		run_modify "$account" >"$TEST_TMPDIR/out.json"

		run jq -e '.effortLevel == "xhigh"' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.model == "opus[1m]"' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS == "1"' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.statusLine.command | test("claude-code-statusline")' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.permissions.defaultMode == "auto"' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.permissions.allow | length > 200' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
	done < <(all_accounts)
}

@test "account-specific settings stay on their own account" {
	run_modify personal >"$TEST_TMPDIR/personal.json"
	run_modify work >"$TEST_TMPDIR/work.json"

	# Declared under claudeData.personal only.
	run jq -e '.tui == "fullscreen"' "$TEST_TMPDIR/personal.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.env.MAX_THINKING_TOKENS == "128000"' "$TEST_TMPDIR/personal.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	run jq -e 'has("tui")' "$TEST_TMPDIR/work.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run jq -e '.env | has("MAX_THINKING_TOKENS")' "$TEST_TMPDIR/work.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
}

@test "permissions are sorted, deduped, and \$HOME-expanded" {
	run_modify personal >"$TEST_TMPDIR/out.json"

	# $HOME is expanded at render time -- Claude Code does not shell-expand
	# permission patterns, so a literal "$HOME" here would never match.
	run jq -e --arg home "$FAKE_HOME" '.permissions.allow | any(. == "Read(\($home)/go/pkg/mod/**)")' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.permissions.allow | any(test("\\$HOME"))' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"

	run jq -e '.permissions.allow == (.permissions.allow | sort)' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.permissions.allow == (.permissions.allow | unique)' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "hooks expand \$CLAUDE_DIR to the owning account directory" {
	run_modify personal >"$TEST_TMPDIR/out.json"

	run jq -e --arg dir "$FAKE_HOME/.claude-personal" \
		'.hooks.Notification[0].hooks[0].command == "bash \($dir)/hooks/tmux-bell.sh"' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Two PreToolUse matchers stay separate groups rather than collapsing.
	run jq -e '[.hooks.PreToolUse[].matcher] | sort == ["Bash", "Write|Edit|MultiEdit"]' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# No placeholder survives into the rendered file.
	run grep -q 'CLAUDE_DIR' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
}

@test "an account with no declared hooks emits no hooks key" {
	run_modify work >"$TEST_TMPDIR/out.json"

	run jq -e 'has("hooks")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
}

@test "plugins and marketplaces never leak into settings.json" {
	# ADR 0008: the claude CLI is the single writer for these keys.
	local account
	while read -r account; do
		run_modify "$account" >"$TEST_TMPDIR/out.json"
		run jq -e 'has("extraKnownMarketplaces")' "$TEST_TMPDIR/out.json"
		[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
		run jq -e 'has("enabledPlugins")' "$TEST_TMPDIR/out.json"
		[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
		run jq -e 'has("marketplaces")' "$TEST_TMPDIR/out.json"
		[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	done < <(all_accounts)
}

@test "merging preserves keys Claude Code owns and we do not declare" {
	local current='{
    "theme": "dark",
    "customUserKey": {"a": 1, "b": [2, 3]},
    "extraKnownMarketplaces": {"han": {"source": {"source": "github", "repo": "td/han"}}},
    "enabledPlugins": {"han@han": true}
  }'

	run_modify personal "$current" >"$TEST_TMPDIR/out.json"

	run jq -e '.theme == "dark"' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.customUserKey.a == 1 and .customUserKey.b == [2, 3]' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.extraKnownMarketplaces.han.source.repo == "td/han"' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '.enabledPlugins["han@han"] == true' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Declared keys still win over whatever was there before.
	run jq -e '.effortLevel == "xhigh"' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "undeclared permissions and hooks are dropped, not accumulated" {
	# jq's `*` recurses into objects but replaces arrays wholesale, which is what
	# makes removing an entry from the data actually remove it from the file.
	local current='{
    "permissions": {"defaultMode": "auto", "allow": ["Bash(rm -rf:*)"]},
    "hooks": {"PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "/gone.sh"}]}]}
  }'

	run_modify personal "$current" >"$TEST_TMPDIR/out.json"

	run jq -e '.permissions.allow | any(. == "Bash(rm -rf:*)")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run jq -e '[.hooks.PreToolUse[].hooks[0].command] | any(. == "/gone.sh")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
}

@test "is idempotent across consecutive runs" {
	local first second
	first=$(run_modify personal)
	second=$(printf '%s' "$first" | bash "$(render_modify personal)")

	[ "$(printf '%s' "$first" | jq -S .)" = "$(printf '%s' "$second" | jq -S .)" ] || fail "assertion did not hold"
}

@test "unparseable current settings are left alone rather than replaced" {
	local script
	script=$(render_modify personal)

	# stderr carries jq's parse error, which is a useful diagnostic; only stdout
	# becomes the new file contents.
	run bash -c "printf '%s' 'this is not json' | bash '$script' 2>/dev/null"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" = "this is not json" ] || fail "assertion did not hold"
}
