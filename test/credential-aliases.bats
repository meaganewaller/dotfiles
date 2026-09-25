#!/usr/bin/env bats

load test_helper

MANIFEST="home/dot_config/fnox/config.toml"

# Profile names a file export would plausibly select. Nothing exports today --
# the `secrets` task was retired in dotfiles-ogz, and the plaintext guard in
# test/shell-startup-secrets.bats fails if one comes back -- but a credential
# sharing a name with a reintroduced export would land on disk in the clear, so
# the two guards are kept independent.
EXPORTED_PROFILES="personal work"

@test "credential profiles are declared with op:// references" {
	run yq -p toml -o y '.profiles | keys | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"claude"* ]] || fail "no claude profile in $MANIFEST: $output"
	[[ "$output" == *"buildkite"* ]] || fail "no buildkite profile in $MANIFEST: $output"
}

@test "credential profiles are NOT names a file export would select" {
	# Load-bearing for security, not style. If a credential profile were renamed
	# to one a future export selects, its secret would silently land on disk,
	# losing the per-invocation property this design exists for.
	run yq -p toml -o y '.profiles | keys | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	while IFS= read -r profile; do
		[ -n "$profile" ] || continue
		for exported in $EXPORTED_PROFILES; do
			[ "$profile" != "$exported" ] ||
				fail "credential profile '$profile' shares a name with an exportable profile; its secrets could land on disk"
		done
	done <<<"$output"
}

@test "zshrc no longer shells out to op read for credentials" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_zshrc.tmpl"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *"op read"* ]] || fail "zshrc still contains an op read credential alias"
}
