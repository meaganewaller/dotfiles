#!/usr/bin/env bats

load test_helper

MANIFEST="home/dot_config/fnox/config.toml"

# The profiles mise selects, per `_.fnox-env` in home/dot_config/mise/config.toml.tmpl.
# A credential placed in one of these would be exported into every shell's
# environment and written to ~/.secrets -- exactly what this design avoids.
MISE_SELECTED_PROFILES="personal work"

@test "credential profiles are declared with op:// references" {
	run yq -p toml -o y '.profiles | keys | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"claude"* ]] || fail "no claude profile in $MANIFEST: $output"
	[[ "$output" == *"buildkite"* ]] || fail "no buildkite profile in $MANIFEST: $output"
}

@test "credential profiles are NOT the profiles mise selects" {
	# Load-bearing for security, not style. If a credential profile were renamed
	# to one mise selects, its secret would silently land in every shell env and
	# in ~/.secrets, losing the per-invocation property this design exists for.
	run yq -p toml -o y '.profiles | keys | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	while IFS= read -r profile; do
		[ -n "$profile" ] || continue
		for selected in $MISE_SELECTED_PROFILES; do
			[ "$profile" != "$selected" ] ||
				fail "credential profile '$profile' is selected by mise; its secrets would leak into every shell env"
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
