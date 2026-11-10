#!/usr/bin/env bats
#
# Claude Code ignores a settings key it doesn't know, silently: personal's
# `autoUpdaterChannel: "stable"` (for autoUpdatesChannel) left it on the latest
# channel with no warning (dotfiles-kdq). Every key under claudeData.*.settings
# must be one Claude Code reads. Adding a setting means adding it here too --
# check it in the settings schema (schemastore claude-code-settings.json) or,
# for keys newer than the schema, in the claude binary.

load test_helper

KNOWN_KEYS="
alwaysThinkingEnabled
attribution
autoDreamEnabled
autoUpdatesChannel
awaySummaryEnabled
copyOnSelect
effortLevel
includeCoAuthoredBy
model
prStatusFooterEnabled
showClearContextOnPlanAccept
skipAutoPermissionPrompt
skipDangerousModePermissionPrompt
statusLine
tui
"

@test "every account's settings keys are ones Claude Code reads" {
	run yq '.claudeData | to_entries | .[] | .key as $account | (.value.settings // {}) | keys | .[] | $account + " " + .' \
		home/.chezmoidata/claude.yaml
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "no settings keys found; the yq path is stale"

	local account key unknown=""
	while read -r account key; do
		grep -qxF "$key" <<<"$KNOWN_KEYS" || unknown+=" $account.$key"
	done <<<"$output"
	[ -z "$unknown" ] || fail "unknown settings keys (typo, or add to KNOWN_KEYS):$unknown"
}
