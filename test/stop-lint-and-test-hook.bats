#!/usr/bin/env bats

# Tests for .claude/hooks/stop-lint-and-test.sh
# Runs the hook against a throwaway git repository with `hk` and `bats`
# stubbed, so each test can see which checks ran and on which files.

load test_helper

setup() {
	TEST_TMPDIR=$(mktemp -d)
	HOOK_SCRIPT="$BATS_TEST_DIRNAME/../.claude/hooks/stop-lint-and-test.sh"

	export CLAUDE_PROJECT_DIR="$TEST_TMPDIR/repo"
	git init -q "$CLAUDE_PROJECT_DIR"
	git -C "$CLAUDE_PROJECT_DIR" config user.email test@example.com
	git -C "$CLAUDE_PROJECT_DIR" config user.name test
	git -C "$CLAUDE_PROJECT_DIR" config commit.gpgsign false
	mkdir -p "$CLAUDE_PROJECT_DIR/docs" "$CLAUDE_PROJECT_DIR/home"
	printf 'a\n' >"$CLAUDE_PROJECT_DIR/mise.lock"
	printf 'a\n' >"$CLAUDE_PROJECT_DIR/docs/guide.md"
	printf 'a\n' >"$CLAUDE_PROJECT_DIR/home/dot_zshrc"
	git -C "$CLAUDE_PROJECT_DIR" add -A
	git -C "$CLAUDE_PROJECT_DIR" commit -qm init

	# The hook prepends mise's shims dir; point it somewhere empty so the
	# stubs below win over any real hk or bats on this machine.
	export MISE_DATA_DIR="$TEST_TMPDIR/mise"

	CALLS="$TEST_TMPDIR/calls"
	export CALLS
	STUB_BIN="$TEST_TMPDIR/bin"
	mkdir -p "$STUB_BIN"
	cat >"$STUB_BIN/hk" <<'STUB'
#!/usr/bin/env bash
echo "hk $*" >>"$CALLS"
STUB
	cat >"$STUB_BIN/bats" <<'STUB'
#!/usr/bin/env bash
echo "bats $*" >>"$CALLS"
[[ -z "${BATS_STUB_FAIL:-}" ]] || { echo "not ok 1 stubbed failure"; exit 1; }
STUB
	chmod +x "$STUB_BIN/hk" "$STUB_BIN/bats"
	export PATH="$STUB_BIN:$PATH"
}

teardown() {
	rm -rf "$TEST_TMPDIR"
}

session_start() {
	run bash "$HOOK_SCRIPT" <<<'{"hook_event_name":"SessionStart","session_id":"s1"}'
	[ "$status" -eq 0 ] || fail "SessionStart status=$status output=$output"
}

stop() {
	: >"$CALLS"
	run bash "$HOOK_SCRIPT" <<<"{\"hook_event_name\":\"Stop\",\"session_id\":\"s1\",\"stop_hook_active\":${1:-false}}"
}

edit() {
	printf '%s\n' "${2:-b}" >>"$CLAUDE_PROJECT_DIR/$1"
}

@test "a clean tree runs no checks" {
	session_start
	stop
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ ! -s "$CALLS" ] || fail "expected no checks, got: $(cat "$CALLS")"
}

@test "without a SessionStart snapshot every dirty file is checked" {
	edit home/dot_zshrc
	stop
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	grep -qx 'hk fix home/dot_zshrc' "$CALLS" || fail "calls: $(cat "$CALLS")"
	grep -qx 'bats test/' "$CALLS" || fail "calls: $(cat "$CALLS")"
}

@test "files already dirty at SessionStart do not trigger checks" {
	edit home/dot_zshrc
	session_start
	stop
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ ! -s "$CALLS" ] || fail "expected no checks, got: $(cat "$CALLS")"
}

@test "a file dirty at SessionStart and edited again is checked" {
	edit home/dot_zshrc
	session_start
	edit home/dot_zshrc c
	stop
	grep -qx 'hk fix home/dot_zshrc' "$CALLS" || fail "calls: $(cat "$CALLS")"
	grep -qx 'bats test/' "$CALLS" || fail "calls: $(cat "$CALLS")"
}

@test "only files changed during the session are linted" {
	edit mise.lock
	session_start
	edit home/dot_zshrc
	stop
	grep -qx 'hk fix home/dot_zshrc' "$CALLS" || fail "calls: $(cat "$CALLS")"
}

@test "docs, beads, and lockfile changes are linted but skip the test suite" {
	session_start
	edit docs/guide.md
	edit mise.lock
	stop
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	grep -qx 'hk fix docs/guide.md mise.lock' "$CALLS" || fail "calls: $(cat "$CALLS")"
	! grep -q '^bats' "$CALLS" || fail "expected no bats run, got: $(cat "$CALLS")"
}

@test "a passing check is not repeated on the next stop" {
	session_start
	edit home/dot_zshrc
	stop
	grep -qx 'bats test/' "$CALLS" || fail "first stop calls: $(cat "$CALLS")"
	stop
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ ! -s "$CALLS" ] || fail "expected no checks, got: $(cat "$CALLS")"
}

@test "a failing check blocks and runs again on the next stop" {
	session_start
	edit home/dot_zshrc
	BATS_STUB_FAIL=1 stop
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	echo "$output" | jq -e '.decision == "block"' >/dev/null || fail "output=$output"
	echo "$output" | jq -e '.reason | contains("stubbed failure")' >/dev/null || fail "output=$output"
	stop
	grep -qx 'bats test/' "$CALLS" || fail "second stop calls: $(cat "$CALLS")"
}

@test "an active stop hook lets the stop through without checking" {
	edit home/dot_zshrc
	stop true
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ ! -s "$CALLS" ] || fail "expected no checks, got: $(cat "$CALLS")"
}
