#!/usr/bin/env bats
#
# Launch paths that start Claude Code outside an interactive shell, so the
# claude-<account> wrappers in ~/.config/shell/claude.sh never get a chance to
# set CLAUDE_CONFIG_DIR (ADR 0010). Each test runs the path end to end against
# a fake `claude` that reports the config dir it was started with.

load test_helper

REPO_ROOT() { cd "${BATS_TEST_DIRNAME}/.." && pwd; }

setup_stubs() {
	mkdir -p "$TEST_TMPDIR/bin"
	cat >"$TEST_TMPDIR/bin/claude" <<'EOF'
#!/bin/sh
printf 'DIR=%s PWD=%s ARGS=%s\n' "${CLAUDE_CONFIG_DIR:-<unset>}" "$PWD" "$*"
EOF
	chmod +x "$TEST_TMPDIR/bin/claude"

	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$(REPO_ROOT)"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }
EOF
}

# ── tmux prefix + e (dotfiles-uk6.2) ─────────────────────────────────────────

@test "tmux prefix e launches the @claude_account wrapper, not a bare claude" {
	setup_stubs
	local repo line cmd
	repo="$(REPO_ROOT)"

	# The deployed claude.sh, which the binding sources.
	mkdir -p "$TEST_HOME_DIR/.config/shell"
	chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/home/dot_config/shell/claude.sh.tmpl" \
		>"$TEST_HOME_DIR/.config/shell/claude.sh" || fail "could not render claude.sh.tmpl"

	# chezmoi reports the working tree; tmux new-window runs its command in
	# the -c directory through a shell, as tmux does with default-shell.
	mkdir -p "$TEST_TMPDIR/tree"
	printf '#!/bin/sh\necho "{\\"chezmoi\\":{\\"workingTree\\":\\"%s\\"}}"\n' "$TEST_TMPDIR/tree" \
		>"$TEST_TMPDIR/bin/chezmoi"
	cat >"$TEST_TMPDIR/bin/tmux" <<'EOF'
#!/bin/sh
[ "$1" = new-window ] || exit 0
shift
dir=.
while [ $# -gt 1 ]; do
	case "$1" in
	-c) dir="$2"; shift 2 ;;
	-n) shift 2 ;;
	*) shift ;;
	esac
done
cd "$dir" && exec sh -c "$1"
EOF
	chmod +x "$TEST_TMPDIR/bin/chezmoi" "$TEST_TMPDIR/bin/tmux"

	line="$(grep '^bind e run-shell ' "$repo/home/dot_config/tmux/tmux.conf")" ||
		fail "no 'bind e run-shell' in tmux.conf"
	# Strip the tmux quoting, then expand the format tmux would expand.
	cmd="${line#bind e run-shell \'}"
	cmd="${cmd%\'}"
	cmd="${cmd//'#{@claude_account}'/work}"

	local jq_dir zsh_dir
	jq_dir="$(dirname "$(command -v jq)")"
	zsh_dir="$(dirname "$(command -v zsh)")"
	run env -u CLAUDE_CONFIG_DIR HOME="$TEST_HOME_DIR" PATH="$TEST_TMPDIR/bin:$jq_dir:$zsh_dir:/usr/bin:/bin" sh -c "$cmd"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"DIR=$TEST_HOME_DIR/.claude-work "* ]] || fail "not launched as claude-work: $output"
	[[ "$output" == *"PWD=$TEST_TMPDIR/tree "* ]] || fail "not in the dotfiles tree: $output"
}

# ── credential aliases (dotfiles-uk6.3) ──────────────────────────────────────

# Render a credential-alias template with fnox and claude on PATH (lookPath
# gates each alias), and stub fnox to exec whatever follows `--`.
render_credentials() {
	local template="$1"
	setup_stubs
	cat >"$TEST_TMPDIR/bin/fnox" <<'EOF'
#!/bin/sh
while [ $# -gt 0 ] && [ "$1" != -- ]; do shift; done
shift
exec "$@"
EOF
	chmod +x "$TEST_TMPDIR/bin/fnox"
	PATH="$TEST_TMPDIR/bin:$PATH" chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$(REPO_ROOT)/$template" >"$TEST_TMPDIR/rendered" || fail "could not render $template"
	grep -E "^alias claude-api[ =]" "$TEST_TMPDIR/rendered" >"$TEST_TMPDIR/alias" ||
		fail "no claude-api alias rendered from $template"
}

@test "zsh claude-api runs claude against an account config dir" {
	render_credentials home/dot_zshrc.tmpl
	run env -u CLAUDE_CONFIG_DIR HOME="$TEST_HOME_DIR" PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		zsh -f -c "$(cat "$TEST_TMPDIR/alias")"$'\n'"eval claude-api hello"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"DIR=$TEST_HOME_DIR/.claude-personal "* ]] || fail "bare claude: $output"
	[[ "$output" == *"ARGS=hello"* ]] || fail "args lost: $output"
}

@test "fish claude-api runs claude against an account config dir" {
	command -v fish >/dev/null 2>&1 || skip "fish not installed"
	render_credentials home/dot_config/fish/conf.d/20-credentials.fish.tmpl
	run env -u CLAUDE_CONFIG_DIR HOME="$TEST_HOME_DIR" PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		"$(command -v fish)" --no-config -c "$(cat "$TEST_TMPDIR/alias"); claude-api hello"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"DIR=$TEST_HOME_DIR/.claude-personal "* ]] || fail "bare claude: $output"
	[[ "$output" == *"ARGS=hello"* ]] || fail "args lost: $output"
}

@test "every claude credential alias names an account that exists" {
	local repo accounts account
	repo="$(REPO_ROOT)"
	accounts="$(yq '.claudeData | keys | .[]' "$repo/home/.chezmoidata/claude.yaml")"
	run yq '.aliases.credentials[] | select(.tool == "claude") | .account // "<none>"' \
		"$repo/home/.chezmoidata/aliases.yaml"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "no claude credential alias to check"
	while IFS= read -r account; do
		[ "$account" != shared ] || fail "'shared' is not a launchable account"
		grep -qxF "$account" <<<"$accounts" || fail "credential alias account '$account' is not in claude.yaml"
	done <<<"$output"
}
