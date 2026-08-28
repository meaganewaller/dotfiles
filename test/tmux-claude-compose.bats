#!/usr/bin/env bats

load test_helper

SCRIPT="home/dot_local/bin/executable_tmux-claude-compose"
TMUX_CONF="home/dot_config/tmux/tmux.conf"

make_stub_commands() {
	mkdir -p "$TEST_TMPDIR/bin"

	cat >"$TEST_TMPDIR/bin/tmux" <<'EOF'
#!/usr/bin/env bash
set -o nounset

case "${1-}" in
show-option)
	# Simulate `tmux show-option -gqv @claude_account`
	printf '%s\n' "${MOCK_TMUX_CLAUDE_ACCOUNT:-}"
	;;
display-message)
	# Handles:
	# - tmux display-message -p '#{pane_id}'
	# - tmux display-message -p -t "%1" '#{pane_current_path}'
	if [[ "${*: -1}" == "#{pane_id}" ]]; then
		printf '%%1\n'
	else
		printf '%s\n' "${PWD}"
	fi
	;;
*)
	# No-op for this suite; deeper tmux plumbing is integration-tested manually.
	exit 0
	;;
esac
EOF

	cat >"$TEST_TMPDIR/bin/nvim" <<'EOF'
#!/usr/bin/env sh
exit 0
EOF

	cat >"$TEST_TMPDIR/bin/less" <<'EOF'
#!/usr/bin/env sh
exit 0
EOF

	chmod +x "$TEST_TMPDIR/bin/tmux" "$TEST_TMPDIR/bin/nvim" "$TEST_TMPDIR/bin/less"
}

run_compose() {
	env \
		HOME="$TEST_HOME_DIR" \
		PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		TMUX=1 \
		MOCK_TMUX_CLAUDE_ACCOUNT="${MOCK_TMUX_CLAUDE_ACCOUNT:-}" \
		CLAUDE_ACCOUNT="${CLAUDE_ACCOUNT:-}" \
		bash "$SCRIPT" "$@"
}

@test "prefix+g is bound to tmux-claude-compose" {
	run grep -n "^bind g run-shell '~/.local/bin/tmux-claude-compose'" "$TMUX_CONF"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "tmux config sets a default claude account for compose" {
	run grep -n '^set -g @claude_account personal$' "$TMUX_CONF"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "fails when multiple accounts exist and no default is configured" {
	make_stub_commands
	mkdir -p "$TEST_HOME_DIR/.claude-personal" "$TEST_HOME_DIR/.claude-work"

	run run_compose --context "$TEST_TMPDIR/missing-context.txt"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"multiple accounts detected"* ]] || fail "output was: $output"
	[[ "$output" == *"@claude_account"* ]] || fail "output was: $output"
}

@test "tmux @claude_account takes precedence over CLAUDE_ACCOUNT" {
	make_stub_commands
	mkdir -p "$TEST_HOME_DIR/.claude-personal" "$TEST_HOME_DIR/.claude-work"

	# Invalid tmux account should fail even when env has a valid account.
	export MOCK_TMUX_CLAUDE_ACCOUNT="does-not-exist"
	export CLAUDE_ACCOUNT="personal"

	run run_compose --context "$TEST_TMPDIR/missing-context.txt"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"unknown account 'does-not-exist'"* ]] || fail "output was: $output"
}

@test "CLAUDE_ACCOUNT is used when tmux @claude_account is unset" {
	make_stub_commands
	mkdir -p "$TEST_HOME_DIR/.claude-personal" "$TEST_HOME_DIR/.claude-work"

	export MOCK_TMUX_CLAUDE_ACCOUNT=""
	export CLAUDE_ACCOUNT="work"

	run run_compose --context "$TEST_TMPDIR/missing-context.txt"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	# Reaching the context-file error means account selection succeeded.
	[[ "$output" == *"context file not found"* ]] || fail "output was: $output"
}

@test "auto-selects the only discovered account" {
	make_stub_commands
	mkdir -p "$TEST_HOME_DIR/.claude-gifthealth"

	export MOCK_TMUX_CLAUDE_ACCOUNT=""
	export CLAUDE_ACCOUNT=""

	run run_compose --context "$TEST_TMPDIR/missing-context.txt"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"context file not found"* ]] || fail "output was: $output"
}
