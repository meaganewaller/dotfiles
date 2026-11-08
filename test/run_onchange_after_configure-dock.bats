#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_onchange_after_configure-dock.sh.tmpl"

# The CI-skip guard is a home/.chezmoitemplates partial, which chezmoi
# resolves against the real --source flag, so render with --source home.
render() {
	local os="$1" work_profile="${2:-false}"
	cat >"$TEST_TMPDIR/$os-$work_profile.toml" <<EOF
[data]
    chezmoi = { os = "$os", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    work_profile = $work_profile
EOF
	chezmoi --source home execute-template --config "$TEST_TMPDIR/$os-$work_profile.toml" --file "$SCRIPT_FILE"
}

# Run the rendered darwin script with defaults and killall stubbed to log calls.
run_rendered() {
	local work_profile="${1:-false}"
	render darwin "$work_profile" >"$TEST_TMPDIR/dock.sh" || fail "render failed"
	mkdir -p "$TEST_TMPDIR/bin"
	printf '#!/usr/bin/env bash\necho "defaults $*" >>"%s/calls"\n' "$TEST_TMPDIR" >"$TEST_TMPDIR/bin/defaults"
	printf '#!/usr/bin/env bash\necho "killall $*" >>"%s/calls"\n' "$TEST_TMPDIR" >"$TEST_TMPDIR/bin/killall"
	chmod +x "$TEST_TMPDIR/bin/defaults" "$TEST_TMPDIR/bin/killall"
	: >"$TEST_TMPDIR/calls"
	run env -u CI -u GITHUB_ACTIONS PATH="$TEST_TMPDIR/bin:$PATH" bash "$TEST_TMPDIR/dock.sh"
}

@test "does not render on non-darwin systems" {
	run render linux
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" = "" ] || fail "output was: $output"
}

@test "renders a valid shell script on darwin" {
	run render darwin
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	assert_script_structure "$output"
	assert_valid_shell "$output"
}

@test "personal and work profiles get their own app lists" {
	run render darwin false
	[[ "$output" == *"/Applications/Ghostty.app"* ]] || fail "output was: $output"
	[[ "$output" != *"/Applications/Slack.app"* ]] || fail "personal got Slack: $output"

	run render darwin true
	[[ "$output" == *"/Applications/Slack.app"* ]] || fail "output was: $output"
}

@test "skips on CI without touching the Dock" {
	render darwin >"$TEST_TMPDIR/dock.sh"
	mkdir -p "$TEST_TMPDIR/bin"
	printf '#!/usr/bin/env bash\necho "defaults $*" >>"%s/calls"\n' "$TEST_TMPDIR" >"$TEST_TMPDIR/bin/defaults"
	chmod +x "$TEST_TMPDIR/bin/defaults"
	CI=1 PATH="$TEST_TMPDIR/bin:$PATH" run bash "$TEST_TMPDIR/dock.sh"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ ! -s "$TEST_TMPDIR/calls" ] || fail "defaults ran on CI: $(cat "$TEST_TMPDIR/calls")"
}

@test "adds only apps that are installed" {
	run_rendered false
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	local app
	for app in "/Applications/Google Chrome.app" "/Applications/Fantastical.app" \
		"/Applications/Ghostty.app" "/Applications/Cursor.app" \
		"/Applications/Obsidian.app" "/System/Applications/Music.app"; do
		if [[ -d "$app" ]]; then
			grep -qF "<string>$app</string>" "$TEST_TMPDIR/calls" || fail "installed $app not added: $(cat "$TEST_TMPDIR/calls")"
		else
			! grep -qF "<string>$app</string>" "$TEST_TMPDIR/calls" || fail "missing $app was added"
		fi
	done
}

@test "keeps the Dock's stacks (persistent-others)" {
	run_rendered false
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	! grep -q 'persistent-others' "$TEST_TMPDIR/calls" || fail "touched stacks: $(cat "$TEST_TMPDIR/calls")"
}

@test "the old every-apply Dock script is gone" {
	[ ! -e "home/.chezmoiscripts/run_after_config_docker-darwin.sh.tmpl" ] || fail "old run_after script still present"
}
