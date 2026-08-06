#!/usr/bin/env bats

load test_helper

@test "dot_zshrc.tmpl renders with chezmoi" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	mkdir -p "$TEST_HOME_DIR/.config"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

# Supplied by chezmoi.toml in real use, not .chezmoidata; the credential-alias
# block dereferences it. Values are never read here -- only interpolated.
[data.credentials]
claude_api = "op://Test/Claude/credential"
buildkite = "op://Test/Buildkite/credential"
EOF

	run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_zshrc.tmpl"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"_dotfiles_is_agent_shell"* ]] || fail "output was: $output"
}

@test "agent minimal path leaves cat unaliased to bat when full profile would alias" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	mkdir -p "$TEST_HOME_DIR/.config/zsh/functions"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

# Supplied by chezmoi.toml in real use, not .chezmoidata; the credential-alias
# block dereferences it. Values are never read here -- only interpolated.
[data.credentials]
claude_api = "op://Test/Claude/credential"
buildkite = "op://Test/Buildkite/credential"
EOF

	chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_zshrc.tmpl" >"$TEST_TMPDIR/rendered.zshrc"

	# Skip if rendered profile never defines cat→bat (no bat on template machine)
	if ! grep -q "alias cat='bat'" "$TEST_TMPDIR/rendered.zshrc"; then
		skip "template did not emit bat cat alias (bat not present at render time)"
	fi

	# `whence -v`, not `whence`: plain `whence cat` prints the expansion ("bat")
	# for an alias and a path for a command, and never emits the word "alias" --
	# so asserting on it passed whether or not the alias existed.
	run env HOME="$TEST_HOME_DIR" XDG_CONFIG_HOME="$TEST_HOME_DIR/.config" DOTFILES_AGENT_SHELL=1 \
		zsh --no-rcs -c "source '$TEST_TMPDIR/rendered.zshrc'; whence -v cat"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *"alias"* ]] || fail "agent shell aliased cat: $output"
}

@test "the full profile does alias cat, so the agent check above is meaningful" {
	# Guards the negative test above: if cat were never aliased in any profile,
	# that test would pass vacuously. DOTFILES_AGENT_SHELL=0 forces the full path
	# even though the suite itself runs under Claude Code (CLAUDECODE=1).
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	mkdir -p "$TEST_HOME_DIR/.config/zsh/functions"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$REPO_ROOT"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.credentials]
claude_api = "op://Test/Claude/credential"
buildkite = "op://Test/Buildkite/credential"
EOF

	chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_zshrc.tmpl" >"$TEST_TMPDIR/rendered.zshrc"

	if ! grep -q "alias cat='bat'" "$TEST_TMPDIR/rendered.zshrc"; then
		skip "template did not emit bat cat alias (bat not present at render time)"
	fi

	run env HOME="$TEST_HOME_DIR" XDG_CONFIG_HOME="$TEST_HOME_DIR/.config" DOTFILES_AGENT_SHELL=0 \
		zsh --no-rcs -c "source '$TEST_TMPDIR/rendered.zshrc'; whence -v cat"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"alias"* ]] || fail "full profile did not alias cat: $output"
}
