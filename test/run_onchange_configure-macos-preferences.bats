#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_onchange_configure-macos-preferences.sh.tmpl"

# This script's CI-skip guard calls the shared home/.chezmoitemplates/
# ci-skip-guard partial, which chezmoi always resolves against the real
# -S/--source flag, not the .chezmoi.sourceDir *data* value set via --config.
darwin_config() {
	local work_profile="${1:-false}"
	cat >"$TEST_TMPDIR/darwin-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    work_profile = $work_profile
EOF
	printf '%s\n' "$TEST_TMPDIR/darwin-config.toml"
}

@test "does not render on non-darwin systems" {
	cat >"$TEST_TMPDIR/linux-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    work_profile = false
EOF

	run chezmoi --source home execute-template --config "$TEST_TMPDIR/linux-config.toml" --file "$SCRIPT_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" = "" ] || fail "output was: $output"
}

@test "renders a valid shell script on darwin" {
	local config
	config=$(darwin_config false)

	run chezmoi --source home execute-template --config "$config" --file "$SCRIPT_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	assert_script_structure "$output"
	assert_valid_shell "$output"
}

@test "rendered script contains all expected preference sections" {
	local config
	config=$(darwin_config false)

	run chezmoi --source home execute-template --config "$config" --file "$SCRIPT_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Each managed preference should be present
	[[ "$output" == *"AppleSymbolicHotKeys"* ]] || fail "output was: $output"
	[[ "$output" == *"com.raycast.macos"* ]] || fail "output was: $output"
	[[ "$output" == *"Monterey Graphic"* ]] || fail "output was: $output"
	[[ "$output" == *"KeyRepeat"* ]] || fail "output was: $output"
	[[ "$output" == *"AppleKeyboardUIMode"* ]] || fail "output was: $output"
	[[ "$output" == *"closeViewScrollWheelToggle"* ]] || fail "output was: $output"
	[[ "$output" == *"com.apple.dock"* ]] || fail "output was: $output"
	[[ "$output" == *"VisibleCC Bluetooth"* ]] || fail "output was: $output"
}

@test "rendered script has CI skip guard" {
	local config
	config=$(darwin_config false)

	run chezmoi --source home execute-template --config "$config" --file "$SCRIPT_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	# shellcheck disable=SC2016 # matching literal shell syntax in rendered output
	[[ "$output" == *'${CI:-}'* ]] || fail "output was: $output"
	# shellcheck disable=SC2016 # matching literal shell syntax in rendered output
	[[ "$output" == *'${GITHUB_ACTIONS:-}'* ]] || fail "output was: $output"
	[[ "$output" == *"Running in CI, skipping macOS preferences"* ]] || fail "output was: $output"
}

@test "rendered output is identical for work_profile=true and work_profile=false" {
	local work_config personal_config

	work_config=$(darwin_config true)
	personal_config=$(darwin_config false)

	chezmoi --source home execute-template --config "$work_config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/work.sh"
	chezmoi --source home execute-template --config "$personal_config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/personal.sh"

	run diff "$TEST_TMPDIR/work.sh" "$TEST_TMPDIR/personal.sh"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "re-rendering produces identical output (template idempotence)" {
	local config
	config=$(darwin_config false)

	chezmoi --source home execute-template --config "$config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/run1.sh"
	chezmoi --source home execute-template --config "$config" --file "$SCRIPT_FILE" >"$TEST_TMPDIR/run2.sh"

	run diff "$TEST_TMPDIR/run1.sh" "$TEST_TMPDIR/run2.sh"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "executing rendered script with CI=true exits cleanly without writing defaults" {
	local config rendered
	config=$(darwin_config false)
	rendered="$TEST_TMPDIR/configure-macos-preferences.sh"

	chezmoi --source home execute-template --config "$config" --file "$SCRIPT_FILE" >"$rendered"
	chmod +x "$rendered"

	# Stub defaults/plutil/osascript/killall: if the CI guard works,
	# none of these should be invoked. Each stub fails loudly if called.
	cat >"$TEST_TMPDIR/defaults" <<'EOF'
#!/usr/bin/env bash
echo "defaults called with: $*" >&2
exit 99
EOF
	cp "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/plutil"
	cp "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/osascript"
	cp "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/killall"
	chmod +x "$TEST_TMPDIR/defaults" "$TEST_TMPDIR/plutil" "$TEST_TMPDIR/osascript" "$TEST_TMPDIR/killall"

	run env CI=true PATH="$TEST_TMPDIR:$PATH" bash "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"Running in CI, skipping macOS preferences"* ]] || fail "output was: $output"
}
