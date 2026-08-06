#!/usr/bin/env bats

load test_helper

# .chezmoi.toml.tmpl -- non-interactive (env var) path only. The
# promptStringOnce/promptBoolOnce prompt path needs a real TTY and isn't
# exercised here; CI and this test both hit the `env` branch since stdin
# isn't a TTY.

@test ".chezmoi.toml.tmpl renders work_profile and work_email when WORK_PROFILE=true" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cp "$REPO_ROOT/home/.chezmoi.toml.tmpl" "$TEST_SOURCE_DIR/"

	run env GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
		WORK_PROFILE=true GIT_WORK_USER_EMAIL="work@example.com" \
		chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
		--config "$TEST_TMPDIR/config-out.toml" </dev/null
	[ "$status" -eq 0 ] || fail "chezmoi init failed: $output"

	run cat "$TEST_TMPDIR/config-out.toml"
	[[ "$output" == *"work_profile = true"* ]] || fail "work_profile not true: $output"
	[[ "$output" == *'email = "personal@example.com"'* ]] || fail "personal email missing: $output"
	[[ "$output" == *'work_email = "work@example.com"'* ]] || fail "work email missing: $output"
}

@test ".chezmoi.toml.tmpl leaves work_email empty when WORK_PROFILE is unset" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cp "$REPO_ROOT/home/.chezmoi.toml.tmpl" "$TEST_SOURCE_DIR/"

	run env GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
		chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
		--config "$TEST_TMPDIR/config-out.toml" </dev/null
	[ "$status" -eq 0 ] || fail "chezmoi init failed: $output"

	run cat "$TEST_TMPDIR/config-out.toml"
	[[ "$output" == *"work_profile = false"* ]] || fail "work_profile not false: $output"
	[[ "$output" == *'work_email = ""'* ]] || fail "work_email not empty: $output"
}

# home/dot_config/git/config.tmpl

@test "config.tmpl signs with the 1Password-backed key and skips the workspace includeIf without a work profile" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"

	# Keys live in 1Password since 0b2feb5; the on-disk ~/.ssh/*.pub paths this
	# used to assert no longer exist.
	local key
	key="$(yq -r '.git.signing_key' "$REPO_ROOT/home/.chezmoidata/git.yaml")"
	[[ "$output" == *"signingkey = $key"* ]] || fail "signingkey not sourced from .chezmoidata/git.yaml"
	[[ "$output" == *"program = \"/Applications/1Password.app/Contents/MacOS/op-ssh-sign\""* ]] || fail "op-ssh-sign not configured"
	[[ "$output" != *"id_ed25519"* ]] || fail "still references a retired on-disk key path"
	[[ "$output" != *'includeIf "gitdir:'* ]] || fail "work includeIf leaked into a personal profile"
}

@test "config.tmpl adds the workspace includeIf on a work profile" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *'includeIf "gitdir:~/src/github.com/testdouble"'* ]] || fail "missing work includeIf"
	[[ "$output" == *"path = ~/.config/git/work.gitconfig"* ]] || fail "includeIf points at the wrong file"
}

# home/dot_config/git/work.gitconfig.tmpl

@test "work.gitconfig.tmpl overrides identity with the work email" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/work.gitconfig.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *"email = work@example.com"* ]] || fail "work email not overridden"
	# Signing key and IdentityFile assertions were dropped in 0b2feb5: keys moved
	# into 1Password, so this overlay now only overrides the identity email. The
	# signing key comes from .chezmoidata/git.yaml via config.tmpl, covered below.
	[[ "$output" != *"id_ed25519"* ]] || fail "still references a retired on-disk key path"
}

# home/dot_config/git/allowed_signers.tmpl

@test "allowed_signers.tmpl trusts only the personal key without a work profile" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *"personal@example.com ssh-ed25519"* ]] || fail "personal trust line missing"
	[[ "$output" != *"work@example.com"* ]] || fail "work identity leaked into a personal profile"
}

@test "allowed_signers.tmpl trusts both keys on a work profile" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *"personal@example.com ssh-ed25519"* ]] || fail "personal trust line missing"
	[[ "$output" == *"work@example.com ssh-ed25519"* ]] || fail "work trust line missing"
}

# The key we sign with and the key we trust must be the same, or git quietly
# stops verifying -- or "verifies" against the wrong key.
#
# This guard used to compare against home/private_dot_ssh/id_ed25519{,_personal}.pub.
# Commit 0b2feb5 moved the keys into 1Password and deleted those files, so the
# guard broke and stopped guarding -- and the drift it existed to catch promptly
# happened. Both templates now render from .chezmoidata/git.yaml, so they cannot
# diverge; this compares the rendered output of each to prove it, which also
# catches anyone re-hardcoding a literal into either file.

@test "the signing key and the trusted key are the same" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config.tmpl"
	[ "$status" -eq 0 ] || fail "config.tmpl render failed: $output"
	local signing_key
	signing_key="$(printf '%s\n' "$output" | sed -n 's/^[[:space:]]*signingkey = \(ssh-[^ ]* [^ ]*\).*/\1/p')"
	[ -n "$signing_key" ] || fail "no signingkey in rendered config.tmpl"

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
	[ "$status" -eq 0 ] || fail "allowed_signers.tmpl render failed: $output"
	[[ "$output" == *"personal@example.com $signing_key"* ]] ||
		fail "trusted key does not match signingkey ($signing_key)"
}

@test "config.tmpl points git at the allowed_signers file it renders" {
	# Without gpg.ssh.allowedSignersFile, `git log --show-signature` errors and
	# %G? reports N even though commits are correctly signed.
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *"allowedSignersFile = "* ]] || fail "gpg.ssh.allowedSignersFile is not configured"

	# It must name the path allowed_signers.tmpl actually deploys to.
	local declared
	declared="$(printf '%s\n' "$output" | sed -n 's/^[[:space:]]*allowedSignersFile = //p')"
	[ "$declared" = "~/.config/git/allowed_signers" ] ||
		fail "allowedSignersFile points at $declared, not the rendered trust map"
}

@test "allowed_signers.tmpl emits well-formed ed25519 trust lines" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"

	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"

	# Every non-comment, non-blank line must be "<email> ssh-ed25519 <base64>".
	local bad
	bad="$(printf '%s\n' "$output" | grep -vE '^[[:space:]]*(#|$)' | grep -vcE '^[^ ]+@[^ ]+ ssh-ed25519 [A-Za-z0-9+/=]+$' || true)"
	[ "$bad" -eq 0 ] || fail "malformed trust lines: $output"

	# Each key must actually parse as an SSH public key.
	local line key
	while IFS= read -r line; do
		[[ "$line" =~ ^[[:space:]]*(#|$) ]] && continue
		key="$(printf '%s' "$line" | cut -d' ' -f2-3)"
		printf '%s\n' "$key" >"$TEST_TMPDIR/k.pub"
		run ssh-keygen -lf "$TEST_TMPDIR/k.pub"
		[ "$status" -eq 0 ] || fail "not a valid ssh public key: $key"
	done < <(printf '%s\n' "$output")
}

@test "config.tmpl rewrites only push URLs to SSH, never fetch URLs" {
	# A bare `insteadOf` rewrites fetches too, which breaks every unauthenticated
	# clone: CI has no SSH key, so chezmoi's git-repo externals fail with
	# "Permission denied (publickey)" on an https:// URL. Only pushes may be
	# rewritten.
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config.tmpl"
	[ "$status" -eq 0 ] || fail "render failed: $output"

	# Strip comments before matching so the explanatory prose above the block
	# (which names the rejected directive) cannot make this pass or fail.
	local directives
	directives="$(printf '%s\n' "$output" | grep -vE '^[[:space:]]*#')"

	printf '%s\n' "$directives" | grep -qE '^[[:space:]]*pushInsteadOf[[:space:]]*=' ||
		fail "no pushInsteadOf directive; pushes will not use SSH"

	if printf '%s\n' "$directives" | grep -qE '^[[:space:]]*insteadOf[[:space:]]*='; then
		fail "bare insteadOf rewrites fetch URLs and breaks anonymous clones in CI"
	fi
}
