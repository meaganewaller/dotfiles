#!/usr/bin/env bats
#
# bin/remove-claude-account: the teardown half of the multi-account setup
# (ADR 0010). Each test runs against a fixture repo built from the *real*
# home/.chezmoidata/claude.yaml, so the awk block-remover is exercised against
# the file it actually has to edit rather than a simplified stand-in.

load test_helper

REPO_ROOT() { cd "${BATS_TEST_DIRNAME}/.." && pwd; }

REAL_DATA() { printf '%s\n' "$(REPO_ROOT)/home/.chezmoidata/claude.yaml"; }

# Build a throwaway dotfiles root plus a throwaway $HOME, and export the two
# variables the script reads. Every account named gets a source dir and a live
# ~/.claude-<account> with a bit of content, so archiving has something to move.
fixture() {
	FAKE_ROOT="$TEST_TMPDIR/root"
	FAKE_HOME="$TEST_TMPDIR/fakehome"
	ARCHIVE="$FAKE_HOME/.local/state/claude-archive"
	mkdir -p "$FAKE_ROOT/home/.chezmoidata" "$FAKE_HOME"
	cp "$(REAL_DATA)" "$FAKE_ROOT/home/.chezmoidata/claude.yaml"

	local account
	for account in "$@"; do
		mkdir -p "$FAKE_ROOT/home/private_dot_claude-$account"
		printf 'x\n' >"$FAKE_ROOT/home/private_dot_claude-$account/private_CLAUDE.md.tmpl"
		mkdir -p "$FAKE_HOME/.claude-$account/projects"
		printf 'session\n' >"$FAKE_HOME/.claude-$account/projects/a.jsonl"
	done
}

# Run the script under the fixture. stdin is closed, which also exercises the
# "refuse to run non-interactively without --yes" guard.
remove() {
	run env -u XDG_STATE_HOME HOME="$FAKE_HOME" DOTFILES_ROOT="$FAKE_ROOT" \
		"$(REPO_ROOT)/bin/remove-claude-account" "$@" </dev/null
}

DATA() { printf '%s\n' "$FAKE_ROOT/home/.chezmoidata/claude.yaml"; }

# ── the script itself ───────────────────────────────────────────────────────

@test "the script is executable and passes shellcheck" {
	[ -x "$(REPO_ROOT)/bin/remove-claude-account" ] || fail "bin/remove-claude-account is not executable"

	run bash -n "$(REPO_ROOT)/bin/remove-claude-account"
	[ "$status" -eq 0 ] || fail "bash rejected the script: $output"

	command -v shellcheck >/dev/null 2>&1 || skip "shellcheck not installed"
	run shellcheck "$(REPO_ROOT)/bin/remove-claude-account"
	[ "$status" -eq 0 ] || fail "shellcheck rejected the script: $output"
}

# ── guards ──────────────────────────────────────────────────────────────────

@test "refuses to remove 'shared'" {
	fixture work
	remove --yes shared
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	[[ "$output" == *"merge base"* ]] || fail "did not explain why: $output"
	run yq -e '.claudeData.shared' "$(DATA)"
	[ "$status" -eq 0 ] || fail "shared was removed anyway"
}

@test "rejects account names that are not plain slugs" {
	fixture work
	local bad
	for bad in "../evil" "a b" "UPPER" '$(id)'; do
		remove --yes "$bad"
		[ "$status" -ne 0 ] || fail "accepted '$bad'"
		[[ "$output" == *"invalid account name"* ]] || fail "wrong error for '$bad': $output"
	done
}

@test "refuses an account that does not exist anywhere" {
	fixture work
	remove --yes nosuchclient
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	[[ "$output" == *"nothing to remove"* ]] || fail "wrong error: $output"
}

@test "refuses to remove the last remaining account" {
	fixture personal
	# Strip everything but `personal` so it is genuinely the only one left.
	remove --yes work
	remove --yes gifthealth
	remove --yes personal
	[ "$status" -ne 0 ] || fail "removed the last account: $output"
	[[ "$output" == *"only account"* ]] || fail "wrong error: $output"
	run yq -e '.claudeData.personal' "$(DATA)"
	[ "$status" -eq 0 ] || fail "personal was removed anyway"
}

@test "refuses to run non-interactively without --yes" {
	fixture work
	remove work
	[ "$status" -ne 0 ] || fail "expected non-zero status, got $status"
	[[ "$output" == *"--yes"* ]] || fail "did not mention --yes: $output"
	run yq -e '.claudeData.work' "$(DATA)"
	[ "$status" -eq 0 ] || fail "work was removed without confirmation"
}

@test "--check changes nothing" {
	fixture work
	local before
	before=$(shasum "$(DATA)" | awk '{print $1}')

	remove --check work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"dry run"* ]] || fail "did not announce a dry run: $output"

	[ "$before" = "$(shasum "$(DATA)" | awk '{print $1}')" ] || fail "claude.yaml changed"
	[ -d "$FAKE_ROOT/home/private_dot_claude-work" ] || fail "source dir was removed"
	[ -d "$FAKE_HOME/.claude-work" ] || fail "live dir was removed"
}

# ── removal ─────────────────────────────────────────────────────────────────

@test "removes all three parts of an account" {
	fixture work
	remove --yes work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	run yq -e '.claudeData | has("work")' "$(DATA)"
	[ "$status" -ne 0 ] || fail "claudeData.work survived"
	[ ! -d "$FAKE_ROOT/home/private_dot_claude-work" ] || fail "source dir survived"
	[ ! -d "$FAKE_HOME/.claude-work" ] || fail "live dir survived"
}

@test "the live directory is archived, not destroyed" {
	fixture work
	remove --yes work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local archived
	archived=$(find "$ARCHIVE" -maxdepth 1 -name 'work-*' -type d)
	[ -n "$archived" ] || fail "no archive directory under $ARCHIVE: $output"
	[ "$(cat "$archived/projects/a.jsonl")" = "session" ] || fail "session data did not survive archiving"
	[[ "$archived" =~ work-[0-9]{8}T[0-9]{6}Z$ ]] || fail "archive is not timestamped: $archived"
}

@test "the archive lands outside the ~/.claude-* account namespace" {
	# bin/sync-claude-extras and bin/sync-claude-settings both enumerate accounts
	# by globbing ~/.claude-*/. An archive at ~/.claude-archive/ would be detected
	# as an account named "archive" and have every shared marketplace installed
	# into it -- recreating the orphan this script exists to remove.
	fixture work
	remove --yes work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local stray
	stray=$(find "$FAKE_HOME" -maxdepth 1 -name '.claude-*' -type d)
	[ -z "$stray" ] || fail "archiving left a directory in the account namespace: $stray"
	[ -d "$ARCHIVE" ] || fail "nothing was archived to $ARCHIVE"
}

@test "--purge deletes the live directory instead of archiving it" {
	fixture work
	remove --yes --purge work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	[ ! -d "$FAKE_HOME/.claude-work" ] || fail "live dir survived --purge"
	[ ! -d "$ARCHIVE" ] || fail "--purge left an archive behind"
}

@test "warns that an archived account still carries its credentials" {
	fixture work
	printf '{"token":"x"}\n' >"$FAKE_HOME/.claude-work/.credentials.json"
	remove --yes work
	[[ "$output" == *"credentials"* ]] || fail "no credentials warning: $output"
}

@test "removes an account that was never applied to \$HOME" {
	fixture work
	rm -rf "$FAKE_HOME/.claude-work"
	remove --yes work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run yq -e '.claudeData | has("work")' "$(DATA)"
	[ "$status" -ne 0 ] || fail "claudeData.work survived"
}

@test "removes an orphaned live directory with no source behind it" {
	# The case the whole script exists for: ~/.claude-<x> left over after the
	# source was deleted by hand, still being reconciled by the sync scripts.
	fixture work
	mkdir -p "$FAKE_HOME/.claude-orphan"
	remove --yes orphan
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ ! -d "$FAKE_HOME/.claude-orphan" ] || fail "orphan survived"
}

# ── the YAML edit ───────────────────────────────────────────────────────────

@test "leaves the rest of claude.yaml byte-for-byte identical" {
	# The reason this is awk and not `yq -i 'del(...)'`: yq strips every blank
	# line in the document, so a one-block removal reads as a whole-file rewrite.
	fixture work
	remove --yes work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	run diff "$(REAL_DATA)" "$(DATA)"
	[ "$status" -ne 0 ] || fail "nothing was removed at all"

	# Exactly one contiguous hunk, and every changed line is a deletion.
	local hunks removed added
	hunks=$(printf '%s\n' "$output" | grep -c '^[0-9]')
	[ "$hunks" -eq 1 ] || fail "expected 1 hunk, got $hunks:"$'\n'"$output"
	removed=$(printf '%s\n' "$output" | grep -c '^<' || true)
	added=$(printf '%s\n' "$output" | grep -c '^>' || true)
	[ "$removed" -gt 0 ] || fail "no lines removed"
	[ "$added" -eq 0 ] || fail "the edit added $added lines:"$'\n'"$output"
}

@test "takes the account's banner comment with it and leaves neighbours alone" {
	fixture work
	remove --yes work

	run grep -q 'Work account' "$(DATA)"
	[ "$status" -ne 0 ] || fail "the work banner comment was orphaned"
	run grep -q 'testdouble-skills-internal' "$(DATA)"
	[ "$status" -ne 0 ] || fail "work's marketplace survived"

	# Its neighbours, and their banners, are untouched.
	run grep -q 'Personal account' "$(DATA)"
	[ "$status" -eq 0 ] || fail "personal's banner was eaten"
	run yq -e '.claudeData.personal.env.MAX_THINKING_TOKENS' "$(DATA)"
	[ "$status" -eq 0 ] || fail "personal's data was damaged"
	run yq -e '.claudeData.shared.settings.model' "$(DATA)"
	[ "$status" -eq 0 ] || fail "shared was damaged"
}

@test "removing the last block leaves no trailing blank line" {
	fixture gifthealth
	remove --yes gifthealth
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	[ -n "$(tail -c 1 "$(DATA)")" ] && fail "file does not end in a newline"
	[ -n "$(tail -n 1 "$(DATA)")" ] || fail "file ends in a blank line"
	assert_valid_yaml "$(DATA)"
}

@test "removing every account in turn keeps the file parseable each time" {
	fixture personal work gifthealth
	local account
	for account in gifthealth work; do
		remove --yes "$account"
		[ "$status" -eq 0 ] || fail "$account: status=$status output=$output"
		assert_valid_yaml "$(DATA)"
		run yq -e ".claudeData | has(\"$account\")" "$(DATA)"
		[ "$status" -ne 0 ] || fail "$account survived"
	done
	run yq -e '.claudeData.shared.settings.model' "$(DATA)"
	[ "$status" -eq 0 ] || fail "shared did not survive: $output"
}

@test "a same-named key outside claudeData is not touched" {
	fixture work
	cat >>"$(DATA)" <<'YAML'

otherTopLevel:
  work:
    keep: me
YAML
	remove --yes work
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	run yq -e '.otherTopLevel.work.keep' "$(DATA)"
	[ "$status" -eq 0 ] || fail "the edit reached outside claudeData: $output"
	run yq -e '.claudeData | has("work")' "$(DATA)"
	[ "$status" -ne 0 ] || fail "claudeData.work survived"
}
