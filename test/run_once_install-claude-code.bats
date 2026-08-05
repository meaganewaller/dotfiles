#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_once_install-claude-code.sh.tmpl"

# Uses the shared home/.chezmoitemplates/ci-skip-guard partial, which is
# always resolved against the real -S/--source flag, same as `include`
# elsewhere in this repo's chezmoiscripts.
render() {
	cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF
	chezmoi --source home execute-template --config "$TEST_TMPDIR/config.toml" --file "$SCRIPT_FILE"
}

@test "has valid shell syntax and structure" {
	run render
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	assert_script_structure "$output"
	assert_valid_shell "$output"
}

@test "skips install in CI without invoking curl" {
	local rendered="$TEST_TMPDIR/claude-code.sh"
	render >"$rendered"

	local stub_dir="$TEST_TMPDIR/stub"
	mkdir -p "$stub_dir"
	cat >"$stub_dir/curl" <<'EOF'
#!/usr/bin/env bash
echo "curl called with: $*" >&2
exit 99
EOF
	chmod +x "$stub_dir/curl"

	run env CI=true PATH="$stub_dir:$PATH" bash "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"Running in CI, skipping Claude Code install"* ]] || fail "output was: $output"
}

@test "skips install when claude is already on PATH" {
	local rendered="$TEST_TMPDIR/claude-code.sh"
	render >"$rendered"

	local stub_dir="$TEST_TMPDIR/stub"
	mkdir -p "$stub_dir"
	cat >"$stub_dir/claude" <<'EOF'
#!/usr/bin/env bash
[ "$1" = "--version" ] && echo "1.2.3 (Claude Code)"
EOF
	chmod +x "$stub_dir/claude"
	local curl_log="$TEST_TMPDIR/curl.log"
	cat >"$stub_dir/curl" <<EOF
#!/usr/bin/env bash
echo "\$*" >>"$curl_log"
exit 99
EOF
	chmod +x "$stub_dir/curl"

	# Explicitly clear CI/GITHUB_ACTIONS: real CI runners set these, and this
	# test exercises the already-installed branch that only matters off-CI.
	run env -u CI -u GITHUB_ACTIONS PATH="$stub_dir:$PATH" bash "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"Claude Code already installed: 1.2.3 (Claude Code)"* ]] || fail "output was: $output"
	[ ! -f "$curl_log" ] || fail "assertion did not hold"
}

@test "installs via curl | bash when claude is absent and not in CI" {
	local rendered="$TEST_TMPDIR/claude-code.sh"
	render >"$rendered"

	local marker="$TEST_TMPDIR/installed.marker"

	# Fully isolated PATH: only the interpreter plus a curl stub that emits a
	# tiny script marking that it ran. No 'claude' stub, so command -v claude
	# fails and the install branch runs. env -i avoids leaking a real 'claude'
	# or 'curl' from the host machine's actual PATH.
	local clean="$TEST_TMPDIR/clean"
	mkdir -p "$clean"
	ln -s "$(command -v bash)" "$clean/bash"
	cat >"$clean/curl" <<EOF
#!/usr/bin/env bash
echo ': > "$marker"'
EOF
	chmod +x "$clean/curl"

	run env -i PATH="$clean" bash "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"Installing Claude Code..."* ]] || fail "output was: $output"
	[[ "$output" == *"Claude Code installation complete"* ]] || fail "output was: $output"
	[ -f "$marker" ] || fail "assertion did not hold"
}
