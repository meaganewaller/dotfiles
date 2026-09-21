#!/usr/bin/env bats

load test_helper

TEMPLATE="home/dot_config/mise/config.toml.tmpl"

# Render the mise config template into $TEST_TMPDIR/mise.toml and echo the path.
render_mise_config() {
	cp "$BATS_TEST_DIRNAME/../$TEMPLATE" "$TEST_SOURCE_DIR/config.toml.tmpl"

	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
    work_profile = false
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF

	chezmoi --source "$TEST_SOURCE_DIR" execute-template \
		--config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$TEST_SOURCE_DIR/config.toml.tmpl" >"$TEST_TMPDIR/mise.toml" ||
		fail "template did not render"

	echo "$TEST_TMPDIR/mise.toml"
}

@test "rendered mise config is valid TOML and defines a secrets task" {
	local rendered
	rendered="$(render_mise_config)"

	run yq -p toml -o y '.tasks.secrets.description' "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "secrets task has no description"
	[ "$output" != "null" ] || fail "no [tasks.secrets] in rendered config"
}

@test "secrets task body is valid shell" {
	local rendered body
	rendered="$(render_mise_config)"
	body="$(yq -p toml -o y '.tasks.secrets.run' "$rendered")"
	[ -n "$body" ] && [ "$body" != "null" ] || fail "secrets task has an empty run body"

	assert_valid_shell "$(printf '#!/usr/bin/env bash\n%s\n' "$body")"
}

@test "secrets task pins the manifest so project configs cannot leak in" {
	local rendered body
	rendered="$(render_mise_config)"
	body="$(yq -p toml -o y '.tasks.secrets.run' "$rendered")"

	# fnox merges every ancestor fnox.toml. Without --config, running this task
	# from inside a project would fold that project's secrets into ~/.secrets.
	[[ "$body" == *"--config"* ]] || fail "export does not pin a config path: $body"
	[[ "$body" == *".config/fnox/config.toml"* ]] || fail "export does not point at the global manifest: $body"
}

@test "secrets task writes atomically, privately, and validated" {
	local rendered body
	rendered="$(render_mise_config)"
	body="$(yq -p toml -o y '.tasks.secrets.run' "$rendered")"

	[[ "$body" == *"umask 077"* ]] || fail "no umask 077: $body"
	[[ "$body" == *"trap "* ]] || fail "no trap to clean up the temp file: $body"
	[[ "$body" == *"bash -n"* ]] || fail "no syntax validation before replace: $body"
	[[ "$body" == *"mv -f"* ]] || fail "no atomic replace: $body"

	# The temp file must be a sibling of the target. $TMPDIR is a different APFS
	# volume from /Users on macOS, which would silently downgrade mv from an
	# atomic rename to copy-then-unlink.
	[[ "$body" == *'mktemp "$HOME/.secrets.'* ]] || fail "temp file is not a sibling of the target: $body"
	[[ "$body" != *'mktemp "${TMPDIR'* ]] || fail "temp file is in TMPDIR, breaking atomic replace: $body"

	# fnox defaults to --if-missing warn, which exits 0 on an unresolvable
	# secret (locked 1Password, deleted vault item) and produces a syntactically
	# valid, comments-only file with zero secrets -- every other guard here keys
	# off a non-zero exit or a syntax error, so none of them would fire.
	[[ "$body" == *"--if-missing error"* ]] || fail "export does not fail on an unresolvable secret: $body"

	# render_mise_config renders with work_profile = false, so the rendered
	# body must resolve to the personal profile -- this also proves the
	# template conditional actually rendered rather than being emitted as a
	# literal Go-template expression.
	[[ "$body" == *"--profile personal"* ]] || fail "export does not pin the personal profile: $body"
}
