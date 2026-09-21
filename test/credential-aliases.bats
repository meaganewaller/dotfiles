#!/usr/bin/env bats

load test_helper

MANIFEST="home/dot_config/fnox/config.toml"

# The profiles the `secrets` task exports, per home/dot_config/mise/config.toml.tmpl.
# A credential placed in one of these would be written to ~/.secrets in the
# clear -- exactly what this design avoids.
EXPORTED_PROFILES="personal work"

@test "credential profiles are declared with op:// references" {
	run yq -p toml -o y '.profiles | keys | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"claude"* ]] || fail "no claude profile in $MANIFEST: $output"
	[[ "$output" == *"buildkite"* ]] || fail "no buildkite profile in $MANIFEST: $output"
}

@test "credential profiles are NOT the profiles the secrets task exports" {
	# Load-bearing for security, not style. If a credential profile were renamed
	# to one the secrets task exports, its secret would silently land on disk in
	# ~/.secrets, losing the per-invocation property this design exists for.
	run yq -p toml -o y '.profiles | keys | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	while IFS= read -r profile; do
		[ -n "$profile" ] || continue
		for exported in $EXPORTED_PROFILES; do
			[ "$profile" != "$exported" ] ||
				fail "credential profile '$profile' is exported by the secrets task; its secrets would land in ~/.secrets"
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
