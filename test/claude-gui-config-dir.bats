#!/usr/bin/env bats
#
# GUI apps (Claude Desktop, the VS Code/Cursor extensions) are launched by
# launchd and never read a shell rc, so without CLAUDE_CONFIG_DIR in the launchd
# session they write an unmanaged ~/.claude (ADR 0010). A LaunchAgent sets it at
# login and a run_onchange_ script sets it at apply time; both must name the
# same account dir.

load test_helper

PLIST="home/private_Library/LaunchAgents/com.meaganewaller.claude-config-dir.plist.tmpl"
SCRIPT="home/.chezmoiscripts/run_onchange_after_set-claude-gui-config-dir.sh.tmpl"

# The partial lives in home/.chezmoitemplates, which chezmoi resolves against
# the real --source flag, so render with --source home.
render() {
	local file="$1" os="${2:-darwin}" work_profile="${3:-false}"
	cat >"$TEST_TMPDIR/$os-$work_profile.toml" <<EOF
[data]
    chezmoi = { os = "$os", homeDir = "$TEST_HOME_DIR" }
    work_profile = $work_profile
EOF
	chezmoi --source home execute-template --config "$TEST_TMPDIR/$os-$work_profile.toml" --file "$file"
}

@test "the LaunchAgent sets CLAUDE_CONFIG_DIR to the profile's account" {
	run render "$PLIST" darwin false
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"<string>CLAUDE_CONFIG_DIR</string>"* ]] || fail "output=$output"
	[[ "$output" == *"<string>$TEST_HOME_DIR/.claude-personal</string>"* ]] || fail "personal: $output"

	run render "$PLIST" darwin true
	[[ "$output" == *"<string>$TEST_HOME_DIR/.claude-work</string>"* ]] || fail "work: $output"
}

@test "the LaunchAgent is a valid plist that runs at load" {
	command -v plutil >/dev/null 2>&1 || skip "plutil is macOS-only"
	render "$PLIST" >"$TEST_TMPDIR/agent.plist" || fail "render failed"
	run plutil -lint "$TEST_TMPDIR/agent.plist"
	[ "$status" -eq 0 ] || fail "output=$output"
	run plutil -extract RunAtLoad raw "$TEST_TMPDIR/agent.plist"
	[ "$output" = true ] || fail "RunAtLoad=$output"
	run plutil -extract ProgramArguments.0 raw "$TEST_TMPDIR/agent.plist"
	[ "$output" = /bin/launchctl ] || fail "program=$output"
}

@test "every account the GUI dir can name exists in claude.yaml" {
	local account
	for account in personal work; do
		grep -qE "^  $account:" home/.chezmoidata/claude.yaml || fail "no '$account' account in claude.yaml"
	done
}

@test "the apply script does not render on non-darwin systems" {
	run render "$SCRIPT" linux
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" = "" ] || fail "output was: $output"
}

@test "the apply script sets the same dir as the LaunchAgent" {
	render "$SCRIPT" darwin true >"$TEST_TMPDIR/set.sh" || fail "render failed"
	assert_script_structure "$(cat "$TEST_TMPDIR/set.sh")"
	assert_valid_shell "$(cat "$TEST_TMPDIR/set.sh")"
	mkdir -p "$TEST_TMPDIR/bin"
	printf '#!/usr/bin/env bash\necho "launchctl $*" >>"%s/calls"\n' "$TEST_TMPDIR" >"$TEST_TMPDIR/bin/launchctl"
	chmod +x "$TEST_TMPDIR/bin/launchctl"
	run env -u CI -u GITHUB_ACTIONS PATH="$TEST_TMPDIR/bin:$PATH" bash "$TEST_TMPDIR/set.sh"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$(cat "$TEST_TMPDIR/calls")" = "launchctl setenv CLAUDE_CONFIG_DIR $TEST_HOME_DIR/.claude-work" ] ||
		fail "calls: $(cat "$TEST_TMPDIR/calls")"
}

@test "the apply script skips on CI without touching launchd" {
	render "$SCRIPT" >"$TEST_TMPDIR/set.sh" || fail "render failed"
	mkdir -p "$TEST_TMPDIR/bin"
	printf '#!/usr/bin/env bash\necho "launchctl $*" >>"%s/calls"\n' "$TEST_TMPDIR" >"$TEST_TMPDIR/bin/launchctl"
	chmod +x "$TEST_TMPDIR/bin/launchctl"
	CI=1 PATH="$TEST_TMPDIR/bin:$PATH" run bash "$TEST_TMPDIR/set.sh"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ ! -s "$TEST_TMPDIR/calls" ] || fail "launchctl ran on CI: $(cat "$TEST_TMPDIR/calls")"
}
