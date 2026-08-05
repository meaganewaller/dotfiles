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
