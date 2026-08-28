#!/usr/bin/env bats

load test_helper

SCRIPT="home/dot_local/bin/executable_claude-fork"
TMUX_CONF="home/dot_config/tmux/tmux.conf"

make_stubs() {
	mkdir -p "$TEST_TMPDIR/bin"

	cat >"$TEST_TMPDIR/bin/tmux" <<'EOF'
#!/usr/bin/env bash
set -o errexit
set -o nounset

log_file="${MOCK_TMUX_LOG:-/dev/null}"
cmd="${1:-}"

case "$cmd" in
	display-message)
		if [[ "${2:-}" == "-p" ]]; then
			fmt="${*: -1}"
			case "$fmt" in
			"#{pane_pid}") printf '%s\n' "${MOCK_TMUX_PANE_PID:-5000}" ;;
			"#{pane_current_path}") printf '%s\n' "${MOCK_TMUX_PANE_PATH:-$PWD}" ;;
			*) printf '\n' ;;
			esac
		else
			echo "DISPLAY:$*" >>"$log_file"
		fi
		;;
	split-window)
		echo "SPLIT:$*" >>"$log_file"
		;;
	*)
		echo "TMUX:$*" >>"$log_file"
		;;
esac
EOF

	cat >"$TEST_TMPDIR/bin/pgrep" <<'EOF'
#!/usr/bin/env bash
set -o nounset
if [[ "${1:-}" != "-P" ]]; then
	exit 1
fi
case "${2:-}" in
5000) printf '6000\n' ;;
6000) printf '7000\n' ;;
*) exit 1 ;;
esac
EOF

	cat >"$TEST_TMPDIR/bin/claude" <<'EOF'
#!/usr/bin/env sh
exit 0
EOF

	chmod +x "$TEST_TMPDIR/bin/tmux" "$TEST_TMPDIR/bin/pgrep" "$TEST_TMPDIR/bin/claude"
}

seed_fixture() {
	local account_dir="$TEST_HOME_DIR/.claude-personal"
	local project_cwd="$TEST_HOME_DIR/work"
	local project_slug="${project_cwd//\//-}"
	local project_dir="$account_dir/projects/$project_slug"

	mkdir -p "$account_dir/sessions" "$project_dir" "$project_cwd"

	local original="11111111-1111-1111-1111-111111111111"
	local chosen="22222222-2222-2222-2222-222222222222"
	local claimed="33333333-3333-3333-3333-333333333333"

	cat >"$account_dir/sessions/7000.json" <<EOF
{"pid":7000,"cwd":"$project_cwd","sessionId":"$original","startedAt":1000,"updatedAt":2000}
EOF

	# Different pid claims this one, so resolver must ignore it.
	cat >"$account_dir/sessions/8000.json" <<EOF
{"pid":8000,"cwd":"$project_cwd","sessionId":"$claimed","startedAt":900,"updatedAt":3000}
EOF

	printf 'orig\n' >"$project_dir/$original.jsonl"
	printf 'chosen\n' >"$project_dir/$chosen.jsonl"
	printf 'claimed\n' >"$project_dir/$claimed.jsonl"

	python3 - "$project_dir" "$original" "$chosen" "$claimed" <<'PY'
import os
import sys

project_dir = sys.argv[1]
original = sys.argv[2]
chosen = sys.argv[3]
claimed = sys.argv[4]

os.utime(os.path.join(project_dir, f"{original}.jsonl"), (2, 2))
os.utime(os.path.join(project_dir, f"{chosen}.jsonl"), (5, 5))
os.utime(os.path.join(project_dir, f"{claimed}.jsonl"), (6, 6))
PY
}

run_fork() {
	env \
		HOME="$TEST_HOME_DIR" \
		PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		TMUX=1 \
		MOCK_TMUX_LOG="$TEST_TMPDIR/tmux.log" \
		MOCK_TMUX_PANE_PID="5000" \
		MOCK_TMUX_PANE_PATH="$TEST_HOME_DIR/work" \
		bash "$SCRIPT" "$@"
}

@test "tmux binding routes prefix+v to claude-fork" {
	run grep -n '^bind v run-shell "~/.local/bin/claude-fork '\''#{pane_id}'\''"$' "$TMUX_CONF"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "shift+v keeps nvim popup binding" {
	run grep -n '^bind V display-popup -d "#{pane_current_path}" -w 100% -h 100% -E "nvim"$' "$TMUX_CONF"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "fork chooses newest unclaimed project session after the original" {
	make_stubs
	seed_fixture

	run run_fork %3
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local log
	log="$(cat "$TEST_TMPDIR/tmux.log")"
	[[ "$log" == *"--resume"*"22222222-2222-2222-2222-222222222222"*"--fork-session"* ]] || fail "log was: $log"
	[[ "$log" == *"CLAUDE_CONFIG_DIR="*".claude-personal"* ]] || fail "log was: $log"
}

@test "fails when no session metadata exists for pane processes" {
	make_stubs
	mkdir -p "$TEST_HOME_DIR/.claude-personal/sessions"

	run run_fork %3
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"no Claude session metadata found for pane %3"* ]] || fail "output was: $output"
}
