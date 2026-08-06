#!/usr/bin/env bats

load test_helper

@test "Library is excluded on non-darwin platforms" {
	local ignore_file="home/.chezmoiignore"

	cp "$ignore_file" "$TEST_SOURCE_DIR/.chezmoiignore"

	# Test on linux - should exclude Library/** (destination path; see commit 71c661e)
	cat >"$TEST_TMPDIR/linux-config.toml" <<EOF
[data]
    work_profile = false
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/linux-config.toml" --file "$TEST_SOURCE_DIR/.chezmoiignore"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"Library/**"* ]] || fail "output was: $output"
}

@test "Library is not excluded on darwin" {
	local ignore_file="home/.chezmoiignore"

	cp "$ignore_file" "$TEST_SOURCE_DIR/.chezmoiignore"

	cat >"$TEST_TMPDIR/darwin-config.toml" <<EOF
[data]
    work_profile = false
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/darwin-config.toml" --file "$TEST_SOURCE_DIR/.chezmoiignore"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *"Library/**"* ]] || fail "output was: $output"
}

@test "config-work is excluded without a work profile" {
	local ignore_file="home/.chezmoiignore"

	cp "$ignore_file" "$TEST_SOURCE_DIR/.chezmoiignore"

	cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    work_profile = false
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/config.toml" --file "$TEST_SOURCE_DIR/.chezmoiignore"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *".config/git/config-work"* ]] || fail "output was: $output"
}

@test "config-work is not excluded on a work profile" {
	local ignore_file="home/.chezmoiignore"

	cp "$ignore_file" "$TEST_SOURCE_DIR/.chezmoiignore"

	cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    work_profile = true
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/config.toml" --file "$TEST_SOURCE_DIR/.chezmoiignore"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *".config/git/config-work"* ]] || fail "output was: $output"
}

@test "github_keys is excluded when no git username is configured" {
	# gitHubKeys with an empty username hits the authenticated-user endpoint
	# (/user/keys), which 403s under a workflow GITHUB_TOKEN and fails the apply.
	local ignore_file="home/.chezmoiignore"

	cp "$ignore_file" "$TEST_SOURCE_DIR/.chezmoiignore"

	cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    work_profile = false
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    git = { username = "" }
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/config.toml" --file "$TEST_SOURCE_DIR/.chezmoiignore"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Match the entry line exactly. A substring match would also hit the
	# explanatory comment above the block and pass no matter what renders.
	printf '%s\n' "$output" | grep -qE '^\.ssh/github_keys[[:space:]]*$' ||
		fail "github_keys not excluded; output was: $output"
}

@test "github_keys is kept when a git username is configured" {
	local ignore_file="home/.chezmoiignore"

	cp "$ignore_file" "$TEST_SOURCE_DIR/.chezmoiignore"

	cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    work_profile = false
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    git = { username = "meaganewaller" }
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/config.toml" --file "$TEST_SOURCE_DIR/.chezmoiignore"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	if printf '%s\n' "$output" | grep -qE '^\.ssh/github_keys[[:space:]]*$'; then
		fail "github_keys excluded despite a username being set; output was: $output"
	fi
}
