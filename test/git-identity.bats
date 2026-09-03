#!/usr/bin/env bats

load test_helper

# Git identity routing.
#
# .chezmoidata/git.yaml declares which org directories belong to which identity
# (committed -- org names are public, and already appear in pr.yaml).
# ~/.config/chezmoi/chezmoi.toml carries each identity's email and optional
# signing key (prompted, machine-local, never committed -- this repo is public).
#
# An identity is active on a machine if and only if its email is non-empty.
# config.tmpl's includeIf, the identity_<key>.gitconfig overlay, and the
# allowed_signers trust line all read that same value, so they cannot disagree.

repo_root() {
	cd "${BATS_TEST_DIRNAME}/.." && pwd
}

# write_config <td_email> <td_key> <gh_email> <gh_key> [work_profile]
write_config() {
	local repo
	repo="$(repo_root)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
work_profile = ${5:-true}
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"

[data.git.identity_local.testdouble]
email = "$1"
signing_key = "$2"

[data.git.identity_local.gifthealth]
email = "$3"
signing_key = "$4"
EOF
}

render() {
	local repo
	repo="$(repo_root)"
	chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$repo/$1"
}

PERSONAL_KEY_RE='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQ99'

# ── home/.chezmoi.toml.tmpl ──────────────────────────────────────────────────
# Non-interactive (env var) path only. The promptStringOnce path needs a real
# TTY; CI and these tests both hit the `env` branch since stdin isn't a TTY.

@test ".chezmoi.toml.tmpl renders per-identity tables from the environment" {
	local repo
	repo="$(repo_root)"
	cp "$repo/home/.chezmoi.toml.tmpl" "$TEST_SOURCE_DIR/"

	run env GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
		WORK_PROFILE=true \
		GIT_GIFTHEALTH_EMAIL="work@example.com" \
		GIT_GIFTHEALTH_SIGNING_KEY="ssh-ed25519 AAAACLIENT" \
		chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
		--config "$TEST_TMPDIR/config-out.toml" </dev/null
	[ "$status" -eq 0 ] || fail "chezmoi init failed: $output"

	run cat "$TEST_TMPDIR/config-out.toml"
	[[ "$output" == *"[data.git.identity_local.gifthealth]"* ]] || fail "no gifthealth table: $output"
	[[ "$output" == *'email = "work@example.com"'* ]] || fail "client email missing: $output"
	[[ "$output" == *'signing_key = "ssh-ed25519 AAAACLIENT"'* ]] || fail "client key missing: $output"
}

@test ".chezmoi.toml.tmpl leaves an identity blank when its env vars are unset" {
	local repo
	repo="$(repo_root)"
	cp "$repo/home/.chezmoi.toml.tmpl" "$TEST_SOURCE_DIR/"

	run env GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
		chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
		--config "$TEST_TMPDIR/config-out.toml" </dev/null
	[ "$status" -eq 0 ] || fail "chezmoi init failed: $output"

	run cat "$TEST_TMPDIR/config-out.toml"
	[[ "$output" == *"work_profile = false"* ]] || fail "work_profile not false: $output"
	# Both identity tables must exist but be empty -- an absent table would make
	# every consuming template fall over on a fresh machine.
	[[ "$output" == *"[data.git.identity_local.testdouble]"* ]] || fail "no testdouble table: $output"
	[[ "$output" == *"[data.git.identity_local.gifthealth]"* ]] || fail "no gifthealth table: $output"
	local blanks
	blanks="$(printf '%s\n' "$output" | grep -c '^email = ""')"
	[ "$blanks" -eq 2 ] || fail "expected 2 blank identity emails, got $blanks: $output"
}

# ── home/dot_config/git/config.tmpl ──────────────────────────────────────────

@test "config.tmpl signs with the 1Password-backed personal key" {
	write_config "" "" "" ""
	run render home/dot_config/git/config.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"

	local key
	key="$(yq -r '.git.signing_key' "$(repo_root)/home/.chezmoidata/git.yaml")"
	[[ "$output" == *"signingkey = $key"* ]] || fail "signingkey not sourced from .chezmoidata/git.yaml"
	[[ "$output" == *"program = \"/Applications/1Password.app/Contents/MacOS/op-ssh-sign\""* ]] ||
		fail "op-ssh-sign not configured"
	[[ "$output" != *"id_ed25519"* ]] || fail "still references a retired on-disk key path"
}

@test "config.tmpl emits no includeIf when no identity is active" {
	write_config "" "" "" "" false
	run render home/dot_config/git/config.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" != *'includeIf "gitdir'* ]] || fail "identity includeIf leaked with no identity configured"
}

@test "config.tmpl emits one includeIf per directory of an active identity" {
	# testdouble owns two org dirs; both must route to the same overlay.
	write_config "work@example.com" "" "" ""
	run render home/dot_config/git/config.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"

	[[ "$output" == *'[includeIf "gitdir/i:~/src/github.com/testdouble/"]'* ]] ||
		fail "missing testdouble includeIf: $output"
	[[ "$output" == *'[includeIf "gitdir/i:~/src/github.com/testdoublelabs/"]'* ]] ||
		fail "missing testdoublelabs includeIf: $output"

	local n
	n="$(printf '%s\n' "$output" | grep -c 'path = ~/.config/git/identity_testdouble.gitconfig')"
	[ "$n" -eq 2 ] || fail "expected both dirs to point at one overlay, got $n"
}

@test "config.tmpl omits an identity whose email is blank on this machine" {
	write_config "" "" "client@example.com" ""
	run render home/dot_config/git/config.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"

	[[ "$output" == *'gitdir/i:~/src/github.com/gifthealth/'* ]] || fail "active identity missing"
	[[ "$output" != *"testdouble"* ]] || fail "inactive identity leaked into config: $output"
}

@test "every rendered includeIf is case-insensitive and slash-terminated" {
	# The two properties that make a gitdir pattern actually match, both of
	# which the previous single hardcoded pattern got wrong:
	#
	#   - Git appends "**" only to a pattern ending in "/". Without the slash a
	#     pattern matches a gitdir at exactly that path, so no repo *inside* the
	#     directory ever matches and the overlay is silently inert.
	#   - The checkout is ~/src/github.com/Gifthealth, the org is giftHEALTH,
	#     and the pattern is lowercase. Plain "gitdir:" compares case-sensitively
	#     even on a case-insensitive APFS volume.
	write_config "work@example.com" "" "client@example.com" ""
	run render home/dot_config/git/config.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"

	local lines bad
	lines="$(printf '%s\n' "$output" | grep '^\[includeIf')"
	[ -n "$lines" ] || fail "no includeIf blocks rendered at all"

	bad="$(printf '%s\n' "$lines" | grep -cv '^\[includeIf "gitdir/i:[^"]*/"\]$' || true)"
	[ "$bad" -eq 0 ] || fail "includeIf missing /i or trailing slash: $lines"
}

@test "config.tmpl rewrites only push URLs to SSH, never fetch URLs" {
	# A bare `insteadOf` rewrites fetches too, which breaks every unauthenticated
	# clone: CI has no SSH key, so chezmoi's git-repo externals fail with
	# "Permission denied (publickey)" on an https:// URL. Only pushes may be
	# rewritten.
	write_config "" "" "" ""
	run render home/dot_config/git/config.tmpl
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

@test "config.tmpl points git at the allowed_signers file it renders" {
	# Without gpg.ssh.allowedSignersFile, `git log --show-signature` errors and
	# %G? reports N even though commits are correctly signed.
	write_config "" "" "" ""
	run render home/dot_config/git/config.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *"allowedSignersFile = "* ]] || fail "gpg.ssh.allowedSignersFile is not configured"

	local declared
	declared="$(printf '%s\n' "$output" | sed -n 's/^[[:space:]]*allowedSignersFile = //p')"
	[ "$declared" = "~/.config/git/allowed_signers" ] ||
		fail "allowedSignersFile points at $declared, not the rendered trust map"
}

# ── home/dot_config/git/identity_<key>.gitconfig.tmpl ────────────────────────

@test "an identity overlay sets its own email and its own signing key" {
	write_config "" "" "client@example.com" "ssh-ed25519 AAAACLIENT"
	run render home/dot_config/git/identity_gifthealth.gitconfig.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *"email = client@example.com"* ]] || fail "identity email not set: $output"
	[[ "$output" == *"signingkey = ssh-ed25519 AAAACLIENT"* ]] || fail "identity key not set: $output"
	[[ "$output" != *"id_ed25519"* ]] || fail "still references a retired on-disk key path"
}

@test "an identity with no key of its own falls back to the personal key" {
	write_config "work@example.com" "" "" ""
	run render home/dot_config/git/identity_testdouble.gitconfig.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" == *"email = work@example.com"* ]] || fail "identity email not set: $output"
	[[ "$output" == *"signingkey = $PERSONAL_KEY_RE"* ]] || fail "did not fall back to personal key: $output"
}

@test "an inactive identity overlay renders empty so chezmoi skips the file" {
	# A non-empty render would leave a stale overlay on machines that do not use
	# the identity. chezmoi omits a file whose template output is empty.
	write_config "" "" "client@example.com" ""
	run render home/dot_config/git/identity_testdouble.gitconfig.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[ -z "$output" ] || fail "inactive overlay rendered content: [$output]"
}

# ── home/dot_config/git/allowed_signers.tmpl ─────────────────────────────────

@test "allowed_signers trusts only the personal key when no identity is active" {
	write_config "" "" "" "" false
	run render home/dot_config/git/allowed_signers.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"

	local entries
	entries="$(printf '%s\n' "$output" | grep -vE '^[[:space:]]*(#|$)')"
	[ "$(printf '%s\n' "$entries" | wc -l | tr -d ' ')" -eq 1 ] ||
		fail "expected exactly one trust line: $entries"
	[[ "$entries" == personal@example.com* ]] || fail "personal trust line missing: $entries"
}

@test "allowed_signers trusts each active identity against its own key" {
	write_config "work@example.com" "" "client@example.com" "ssh-ed25519 AAAACLIENT"
	run render home/dot_config/git/allowed_signers.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"

	# The client signs with its own key ...
	[[ "$output" == *"client@example.com ssh-ed25519 AAAACLIENT"* ]] ||
		fail "client not trusted against its own key: $output"
	# ... while an identity naming no key falls back to the personal one.
	[[ "$output" == *"work@example.com $PERSONAL_KEY_RE"* ]] ||
		fail "keyless identity did not fall back to the personal key: $output"
}

@test "an inactive identity contributes no trust line" {
	write_config "" "" "client@example.com" ""
	run render home/dot_config/git/allowed_signers.tmpl
	[ "$status" -eq 0 ] || fail "render failed: $output"
	[[ "$output" != *"work@example.com"* ]] || fail "inactive identity leaked into trust map: $output"
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

@test "the personal signing key and the personal trusted key are the same" {
	write_config "" "" "" "" false
	run render home/dot_config/git/config.tmpl
	[ "$status" -eq 0 ] || fail "config.tmpl render failed: $output"
	local signing_key
	signing_key="$(printf '%s\n' "$output" | sed -n 's/^[[:space:]]*signingkey = \(ssh-[^ ]* [^ ]*\).*/\1/p')"
	[ -n "$signing_key" ] || fail "no signingkey in rendered config.tmpl"

	run render home/dot_config/git/allowed_signers.tmpl
	[ "$status" -eq 0 ] || fail "allowed_signers.tmpl render failed: $output"
	[[ "$output" == *"personal@example.com $signing_key"* ]] ||
		fail "trusted key does not match signingkey ($signing_key)"
}

@test "allowed_signers emits well-formed ed25519 trust lines" {
	write_config "work@example.com" "" "client@example.com" \
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEooQ8+spl1BpDJYvS5ILS7d7Am6l37hpHayMP8GLxLA"
	run render home/dot_config/git/allowed_signers.tmpl
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

# ── cross-file drift guard ───────────────────────────────────────────────────

@test "every declared identity has prompts and an overlay template" {
	# An identity lives in three places: the routing table in .chezmoidata, the
	# two prompts in .chezmoi.toml.tmpl, and its overlay template. The prompts
	# cannot be generated from the routing table -- .chezmoidata is not in scope
	# while .chezmoi.toml.tmpl renders, since chezmoi executes it to produce the
	# config that determines sourceDir. This asserts the three stay in agreement
	# so a half-added client fails here instead of silently authoring commits
	# under the personal identity.
	local repo key
	repo="$(repo_root)"

	while IFS= read -r key; do
		[ -n "$key" ] || continue
		[ -f "$repo/home/dot_config/git/identity_$key.gitconfig.tmpl" ] ||
			fail "identity '$key' has no overlay template identity_$key.gitconfig.tmpl"
		grep -q "git.identity_local.$key.email" "$repo/home/.chezmoi.toml.tmpl" ||
			fail "identity '$key' has no email prompt in .chezmoi.toml.tmpl"
		grep -q "\[data.git.identity_local.$key\]" "$repo/home/.chezmoi.toml.tmpl" ||
			fail "identity '$key' has no [data.git.identity_local.$key] table in .chezmoi.toml.tmpl"
	done < <(yq -r '.git.identities[].key' "$repo/home/.chezmoidata/git.yaml")
}

@test "every overlay template corresponds to a declared identity" {
	local repo declared f key
	repo="$(repo_root)"
	declared="$(yq -r '.git.identities[].key' "$repo/home/.chezmoidata/git.yaml")"

	for f in "$repo"/home/dot_config/git/identity_*.gitconfig.tmpl; do
		[ -e "$f" ] || continue
		key="$(basename "$f")"
		key="${key#identity_}"
		key="${key%.gitconfig.tmpl}"
		printf '%s\n' "$declared" | grep -qx "$key" ||
			fail "overlay identity_$key.gitconfig.tmpl has no entry in .chezmoidata/git.yaml"
	done
}

@test "identity directories carry no trailing slash in the data file" {
	# config.tmpl appends the slash that makes a gitdir pattern match recursively.
	# A slash stored here too would render "dir//" and match nothing.
	local repo bad
	repo="$(repo_root)"
	bad="$(yq -r '.git.identities[].dirs[]' "$repo/home/.chezmoidata/git.yaml" | grep -c '/$' || true)"
	[ "$bad" -eq 0 ] || fail "$bad identity dir(s) end in a slash; config.tmpl appends it"
}

# ── backward compatibility ───────────────────────────────────────────────────

@test "templates render on a machine whose config predates identity routing" {
	# chezmoi renders with missingkey=error. An identity declared in git.yaml
	# with no [data.git.identity_local.<key>] table at all -- the state of every
	# machine configured before identity routing existed, which still carries
	# the old git.work_email -- must not break `chezmoi apply`. The templates
	# merge defaults in rather than indexing blindly, so this degrades to the
	# personal identity until the machine re-runs `chezmoi init`.
	local repo f
	repo="$(repo_root)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "legacy@example.com"
EOF

	for f in home/dot_config/git/config.tmpl \
		home/dot_config/git/allowed_signers.tmpl \
		home/dot_config/git/identity_testdouble.gitconfig.tmpl \
		home/dot_config/git/identity_gifthealth.gitconfig.tmpl; do
		run render "$f"
		[ "$status" -eq 0 ] || fail "$f failed on a pre-identity config: $output"
	done

	# It must degrade to personal-only, never silently route to a client.
	run render home/dot_config/git/config.tmpl
	[[ "$output" != *'includeIf "gitdir'* ]] || fail "includeIf rendered with no identity tables: $output"
}
