#!/usr/bin/env bats
#
# Covers the declarative settings surface: home/.chezmoidata/claude.yaml plus
# claude-permissions.yaml, rendered by home/.chezmoitemplates/claude-settings
# through each account's modify_private_settings.json.tmpl.

load test_helper

FAKE_HOME="/home/tester"

# A config that pins homeDir so rendered paths are assertable, and points
# sourceDir at the repo (.chezmoiroot redirects it to home/, same as real use).
# EXTRA_DATA, when set, is appended verbatim: chezmoi deep-merges config data
# over .chezmoidata, so a test can declare rules the real data doesn't have.
template_config() {
	cat >"$TEST_TMPDIR/render.toml" <<EOF
sourceDir = "$PWD"
[data]
    chezmoi = { os = "linux", homeDir = "$FAKE_HOME" }
${EXTRA_DATA-}
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

		run jq -e '.alwaysThinkingEnabled == true and .autoDreamEnabled == true' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS == "1"' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.statusLine.command | test("claude-code-statusline")' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.permissions.defaultMode == "auto"' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '.permissions.allow | length > 200' "$TEST_TMPDIR/out.json"
		[ "$status" -eq 0 ] || fail "status=$status output=$output"
		run jq -e '(.permissions.deny | index("Bash(sed -i:*)")) and (.permissions.ask | index("Bash(docker run:*)"))' "$TEST_TMPDIR/out.json"
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
	# permission patterns, so a literal "$HOME" here would never match. The
	# rule's own leading slash makes it `//<home>/...`, Claude Code's absolute form.
	run jq -e --arg home "$FAKE_HOME" '.permissions.allow | any(. == "Read(/\($home)/go/pkg/mod/**)")' "$TEST_TMPDIR/out.json"
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

	run jq -e '[.hooks.Notification[].hooks[0].command] | sort == [
		"'"$FAKE_HOME"'/.local/libexec/claude-notify",
		"bash '"$FAKE_HOME"'/.claude-personal/hooks/tmux-bell.sh"
	]' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Shared + personal PreToolUse hooks are all present.
	run jq -e '[.hooks.PreToolUse[].matcher] | sort == ["Bash", "Write|Edit|MultiEdit", "Write|Edit|MultiEdit"]' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '[.hooks.PreToolUse[].hooks[0].command]
		| any(. == "'"$FAKE_HOME"'/.local/libexec/block-sensitive-or-generated-writes")
		and any(. == "'"$FAKE_HOME"'/.local/libexec/check-secrets-before-write")
		and any(. == "'"$FAKE_HOME"'/.local/libexec/block-adhoc-installers")' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# No placeholders survive into the rendered file.
	run grep -q 'CLAUDE_DIR' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run grep -q '\$HOME' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
}

@test "accounts with no account-specific hooks still inherit shared hooks" {
	run_modify work >"$TEST_TMPDIR/out.json"

	run jq -e 'has("hooks")' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run jq -e '[.hooks.PreToolUse[].hooks[0].command] | sort == [
		"'"$FAKE_HOME"'/.local/libexec/block-sensitive-or-generated-writes",
		"'"$FAKE_HOME"'/.local/libexec/check-secrets-before-write"
	]' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
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

@test "undeclared env, hooks, and permissions are dropped, not accumulated" {
	# The template owns these three keys outright. A plain `current * desired`
	# would only replace arrays: an env var, a whole hook event, or a deny list
	# dropped from the data would survive in the file forever.
	local current='{
    "env": {"GONE_VAR": "1"},
    "permissions": {"defaultMode": "auto", "allow": ["Bash(rm -rf:*)"], "deny": ["Read(/gone)"], "ask": ["Bash(gone:*)"]},
    "hooks": {
      "PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "/gone.sh"}]}],
      "SessionEnd": [{"hooks": [{"type": "command", "command": "/gone-event.sh"}]}]
    }
  }'

	run_modify personal "$current" >"$TEST_TMPDIR/out.json"

	run jq -e '.permissions.allow | any(. == "Bash(rm -rf:*)")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run jq -e '(.permissions.deny // []) + (.permissions.ask // []) | any(. == "Read(/gone)" or . == "Bash(gone:*)")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run jq -e '[.hooks.PreToolUse[].hooks[0].command] | any(. == "/gone.sh")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run jq -e '.hooks | has("SessionEnd")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	run jq -e '.env | has("GONE_VAR")' "$TEST_TMPDIR/out.json"
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"

	# What is declared is still there.
	run jq -e '.env.MAX_THINKING_TOKENS == "128000" and (.hooks | has("PreToolUse"))' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "deny and ask lists layer, sort, dedupe, and \$HOME-expand like allow" {
	EXTRA_DATA='
[data.claudeData.shared.permissions]
    deny = ["Read(/$HOME/.ssh/**)", "Bash(sed -i:*)"]
    ask = ["Bash(git push:*)"]
[data.claudeData.work.permissions]
    deny = ["Bash(docker run:*)", "Bash(sed -i:*)"]'

	run_modify work >"$TEST_TMPDIR/out.json"

	run jq -e --arg home "$FAKE_HOME" '.permissions.deny == [
		"Bash(docker run:*)",
		"Bash(sed -i:*)",
		"Read(/\($home)/.ssh/**)"
	]' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$(jq -c .permissions.deny "$TEST_TMPDIR/out.json")"
	run jq -e '.permissions.ask == ["Bash(git push:*)"]' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	# The allow list is untouched by declaring deny/ask.
	run jq -e '.permissions.allow | length > 200' "$TEST_TMPDIR/out.json"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "deny and ask are omitted when nothing declares them" {
	# Config data replaces lists rather than appending, which blanks the shared ones.
	EXTRA_DATA='
[data.claudeData.shared.permissions]
    deny = []
    ask = []'

	run_modify personal >"$TEST_TMPDIR/out.json"
	run jq -e '.permissions | has("deny") or has("ask")' "$TEST_TMPDIR/out.json"
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

# The legacy `:*` suffix is a plain prefix match: any other `*` in the same rule
# is taken literally, so the rule never matches. Claude Code warns about each
# one on every session exit, in every account, since these lists are shared.
@test "no permission rule mixes a wildcard with the trailing :* prefix syntax" {
	command -v yq >/dev/null 2>&1 || skip "yq not installed"

	local data="$BATS_TEST_DIRNAME/../home/.chezmoidata" bad
	bad="$(yq -r '.claudeData | to_entries[] | (.value.permissions // {}) | ((.allow // []) + (.deny // []) + (.ask // []))[]' \
		"$data/claude-permissions.yaml" "$data/claude.yaml" |
		awk '/:\*\)$/ { s = $0; sub(/:\*\)$/, "", s); if (s ~ /\*/) print }')" ||
		fail "could not read the allow rules"
	[ -z "$bad" ] || fail "rules that can never match: $bad"
}
