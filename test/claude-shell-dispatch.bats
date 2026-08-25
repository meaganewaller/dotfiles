#!/usr/bin/env bats
#
# The Claude Code account guard: `claude-personal` / `claude-work` set
# CLAUDE_CONFIG_DIR, and a bare `claude` refuses to run. Three shells implement
# it -- zsh and bash share ~/.config/shell/claude.sh, fish has its own twin --
# so every behavioral assertion here runs against all three.

load test_helper

REPO_ROOT() { cd "${BATS_TEST_DIRNAME}/.." && pwd; }

# Render both dispatch files and drop a fake `claude` on PATH that echoes back
# the config dir and args it was invoked with.
render_dispatch() {
	local repo
	repo="$(REPO_ROOT)"

	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }
EOF

	chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/home/dot_config/shell/claude.sh.tmpl" >"$TEST_TMPDIR/claude.sh" ||
		fail "could not render claude.sh.tmpl"
	chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/home/dot_config/fish/conf.d/10-claude.fish.tmpl" >"$TEST_TMPDIR/claude.fish" ||
		fail "could not render 10-claude.fish.tmpl"

	mkdir -p "$TEST_TMPDIR/bin"
	cat >"$TEST_TMPDIR/bin/claude" <<'EOF'
#!/bin/sh
printf 'DIR=%s ARGS=%s\n' "${CLAUDE_CONFIG_DIR:-<unset>}" "$*"
EOF
	chmod +x "$TEST_TMPDIR/bin/claude"
}

# Sets DISPATCH_SHELLS to the installed subset of zsh/bash/fish.
#
# run_in used to `skip` when a shell was missing, which aborts the *whole* test
# on the first one -- so a runner image without zsh silently stopped testing
# bash and fish too, while still reporting "ok ... # skip". Filtering up front
# means a missing shell costs coverage for that shell only.
set_dispatch_shells() {
	DISPATCH_SHELLS=()
	local candidate
	for candidate in zsh bash fish; do
		command -v "$candidate" >/dev/null 2>&1 && DISPATCH_SHELLS+=("$candidate")
	done
	# bash is the floor. Without it every loop below would iterate zero times
	# and the tests would pass vacuously, which is worse than failing.
	[[ " ${DISPATCH_SHELLS[*]} " == *" bash "* ]] ||
		fail "no dispatch shell installed (need at least bash)"
}

# run_in <zsh|bash|fish> <snippet> -- snippet runs with the dispatch file
# sourced, $HOME pointed at the test home, and only the fake claude on PATH.
run_in() {
	local shell="$1" snippet="$2"
	local shell_bin
	shell_bin="$(command -v "$shell")" ||
		fail "$shell vanished between detection and use"

	case "$shell" in
	zsh) run env HOME="$TEST_HOME_DIR" PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		"$shell_bin" --no-rcs -c "source '$TEST_TMPDIR/claude.sh'; $snippet" ;;
	bash) run env HOME="$TEST_HOME_DIR" PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		"$shell_bin" --norc -c "source '$TEST_TMPDIR/claude.sh'; $snippet" ;;
	fish) run env HOME="$TEST_HOME_DIR" PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		"$shell_bin" --no-config -c "source '$TEST_TMPDIR/claude.fish'; $snippet" ;;
	esac
}

@test "rendered POSIX dispatch is valid in both zsh and bash" {
	render_dispatch

	# bash first, and unguarded: it is the one shell every runner has, so it is
	# asserted before any skip can short-circuit the rest of the test.
	run bash -n "$TEST_TMPDIR/claude.sh"
	[ "$status" -eq 0 ] || fail "bash rejected claude.sh: $output"

	# zsh is not universal any more -- the ubuntu-24.04 runner image dropped it,
	# which turned this into a hard CI failure. Treat its absence as reduced
	# coverage: the Docker job and the macOS cold-start leg both still have zsh.
	command -v zsh >/dev/null 2>&1 || skip "zsh not installed"
	run zsh -n "$TEST_TMPDIR/claude.sh"
	[ "$status" -eq 0 ] || fail "zsh rejected claude.sh: $output"
}

@test "every account in claudeData gets a wrapper, and shared does not" {
	render_dispatch

	# Accounts come from home/.chezmoidata/claude.yaml, so assert against that
	# file rather than a hardcoded list -- adding an account should not need a
	# test edit, but dropping the `shared` filter should fail here.
	local account
	while read -r account; do
		grep -q "claude-${account}()" "$TEST_TMPDIR/claude.sh" ||
			fail "no POSIX wrapper for account '${account}'"
		grep -q "function claude-${account}" "$TEST_TMPDIR/claude.fish" ||
			fail "no fish wrapper for account '${account}'"
	done < <(yq -r '.claudeData | keys | .[] | select(. != "shared")' \
		"$(REPO_ROOT)/home/.chezmoidata/claude.yaml")

	! grep -q "claude-shared" "$TEST_TMPDIR/claude.sh" || fail "'shared' leaked into the wrappers"
	! grep -q "claude-shared" "$TEST_TMPDIR/claude.fish" || fail "'shared' leaked into the fish wrappers"
}

@test "account wrappers set CLAUDE_CONFIG_DIR and add ~/src for session launches" {
	render_dispatch

	local shell
	set_dispatch_shells
	for shell in "${DISPATCH_SHELLS[@]}"; do
		run_in "$shell" "claude-personal"
		[ "$status" -eq 0 ] || fail "$shell: status=$status output=$output"
		[[ "$output" == *"DIR=$TEST_HOME_DIR/.claude-personal"* ]] ||
			fail "$shell did not set CLAUDE_CONFIG_DIR: $output"
		[[ "$output" == *"--add-dir $TEST_HOME_DIR/src"* ]] ||
			fail "$shell did not inject --add-dir: $output"

		run_in "$shell" "claude-work resume"
		[[ "$output" == *"DIR=$TEST_HOME_DIR/.claude-work"* ]] ||
			fail "$shell used the wrong account dir: $output"
	done
}

@test "management subcommands are passed through without --add-dir" {
	render_dispatch

	# --add-dir is variadic: injected here it would swallow `add x y` as more
	# directories and `mcp add` would never run.
	local shell
	set_dispatch_shells
	for shell in "${DISPATCH_SHELLS[@]}"; do
		run_in "$shell" "claude-personal mcp add name cmd"
		[ "$status" -eq 0 ] || fail "$shell: status=$status output=$output"
		[[ "$output" == *"ARGS=mcp add name cmd"* ]] ||
			fail "$shell mangled the subcommand: $output"
		[[ "$output" != *"--add-dir"* ]] || fail "$shell injected --add-dir into a subcommand: $output"
	done
}

@test "bare claude refuses to run and exits non-zero" {
	render_dispatch

	local shell
	set_dispatch_shells
	for shell in "${DISPATCH_SHELLS[@]}"; do
		run_in "$shell" "claude"
		[ "$status" -ne 0 ] || fail "$shell let a bare claude succeed: $output"
		[[ "$output" == *"claude-personal"* ]] ||
			fail "$shell did not name an account command: $output"
		[[ "$output" != *"DIR="* ]] || fail "$shell actually invoked claude: $output"
	done
}

@test "zshrc and bashrc both source the shared dispatch file" {
	local repo
	repo="$(REPO_ROOT)"
	mkdir -p "$TEST_HOME_DIR/.config"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

# Supplied by chezmoi.toml in real use, not .chezmoidata; the credential-alias
# block in dot_zshrc.tmpl dereferences it. Values are never read here.
[data.credentials]
claude_api = "op://Test/Claude/credential"
buildkite = "op://Test/Buildkite/credential"
EOF

	local rc
	for rc in dot_zshrc dot_bashrc; do
		run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" \
			--file "$repo/home/$rc.tmpl"
		[ "$status" -eq 0 ] || fail "$rc: status=$status output=$output"
		[[ "$output" == *"/shell/claude.sh"* ]] || fail "$rc does not source the dispatch file"
	done
}
