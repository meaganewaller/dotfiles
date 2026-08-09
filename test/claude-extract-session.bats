#!/usr/bin/env bats

load test_helper

SHIM="home/dot_local/bin/executable_claude-extract-session"

# Same reasoning as claude-session-gist.bats: this ships to a Mac and runs under
# `#!/usr/bin/env bash`, which is /bin/bash 3.2.57 on a default PATH. Exercise
# the guard where it actually lives.
SYSTEM_BASH="/bin/bash"

# A valid-looking UUID whose 8-char prefix the stub below will report.
SESSION_ID="abcd1234-0000-4000-8000-000000000000"

# Install a fake claude-extract on PATH that records the HOME it was run under
# and where that HOME's .claude pointed. The real binary hardcodes
# ~/.claude/projects, so "which HOME did it see" IS the behavior under test.
stub_claude_extract() {
	mkdir -p "$TEST_TMPDIR/bin"
	cat >"$TEST_TMPDIR/bin/claude-extract" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$HOME" >>"$STUB_LOG"
# Resolve where the shim home's .claude points, so the test can assert it.
if [ -L "$HOME/.claude" ]; then
	printf 'link:%s\n' "$(readlink "$HOME/.claude")" >>"$STUB_LOG"
fi

out=""
mode=""
while [ $# -gt 0 ]; do
	case "$1" in
	--list) mode="list" ;;
	--output)
		shift
		out="$1"
		;;
	esac
	shift
done

if [ "$mode" = "list" ]; then
	printf '1. some-project\n   Session: abcd1234...\n'
	exit 0
fi

printf '# Extracted\n' >"$out/session.md"
STUB
	chmod +x "$TEST_TMPDIR/bin/claude-extract"
	export STUB_LOG="$TEST_TMPDIR/stub.log"
	: >"$STUB_LOG"
	PATH="$TEST_TMPDIR/bin:$PATH"
	export PATH
}

# Build a config dir that looks like a Claude config root.
make_config_dir() {
	local dir="$TEST_TMPDIR/$1"
	mkdir -p "$dir/projects"
	printf '%s\n' "$dir"
}

@test "shim is valid bash under the macOS system bash" {
	"$SYSTEM_BASH" -n "$SHIM" || fail "shim is not valid bash 3.2 syntax"
}

@test "extracts against CLAUDE_CONFIG_DIR rather than ~/.claude" {
	stub_claude_extract
	local config
	config=$(make_config_dir "claude-personal")

	CLAUDE_CONFIG_DIR="$config" "$SYSTEM_BASH" "$SHIM" "$SESSION_ID" >/dev/null 2>&1 ||
		fail "shim failed with CLAUDE_CONFIG_DIR=$config"

	grep -q "link:$config" "$STUB_LOG" ||
		fail "claude-extract did not see .claude -> $config; log was: $(cat "$STUB_LOG")"
}

@test "never exposes the real ~/.claude when CLAUDE_CONFIG_DIR is set" {
	stub_claude_extract
	local config
	config=$(make_config_dir "claude-work")

	CLAUDE_CONFIG_DIR="$config" "$SYSTEM_BASH" "$SHIM" "$SESSION_ID" >/dev/null 2>&1 ||
		fail "shim failed with CLAUDE_CONFIG_DIR=$config"

	# Every recorded HOME must be the throwaway shim, never the user's real one.
	while IFS= read -r line; do
		case "$line" in
		link:*) continue ;;
		esac
		[ "$line" != "$HOME" ] ||
			fail "claude-extract ran with the real HOME ($HOME), so it would read ~/.claude"
	done <"$STUB_LOG"
}

@test "one config dir cannot reach another's transcripts" {
	stub_claude_extract
	local personal work
	personal=$(make_config_dir "claude-personal")
	work=$(make_config_dir "claude-work")

	CLAUDE_CONFIG_DIR="$work" "$SYSTEM_BASH" "$SHIM" "$SESSION_ID" >/dev/null 2>&1 ||
		fail "shim failed with CLAUDE_CONFIG_DIR=$work"

	grep -q "link:$personal" "$STUB_LOG" &&
		fail "a work-scoped run reached the personal config dir"
	grep -q "link:$work" "$STUB_LOG" ||
		fail "a work-scoped run did not reach the work config dir"
}

@test "falls back to ~/.claude when CLAUDE_CONFIG_DIR is unset" {
	stub_claude_extract
	local fake_home="$TEST_TMPDIR/fakehome"
	mkdir -p "$fake_home/.claude/projects"

	env -u CLAUDE_CONFIG_DIR HOME="$fake_home" "$SYSTEM_BASH" "$SHIM" "$SESSION_ID" >/dev/null 2>&1 ||
		fail "shim failed with CLAUDE_CONFIG_DIR unset"

	grep -q "link:$fake_home/.claude" "$STUB_LOG" ||
		fail "unset CLAUDE_CONFIG_DIR did not fall back to \$HOME/.claude; log: $(cat "$STUB_LOG")"
}

@test "fails clearly when the config dir has no projects directory" {
	stub_claude_extract
	local empty="$TEST_TMPDIR/empty"
	mkdir -p "$empty"

	local status=0
	CLAUDE_CONFIG_DIR="$empty" "$SYSTEM_BASH" "$SHIM" "$SESSION_ID" \
		>/dev/null 2>"$TEST_TMPDIR/err" || status=$?

	[ "$status" -ne 0 ] || fail "expected a non-zero exit for a config dir with no projects/"
	grep -q "no transcripts at $empty/projects" "$TEST_TMPDIR/err" ||
		fail "expected an explanatory error; got: $(cat "$TEST_TMPDIR/err")"
}

@test "removes the throwaway home it creates" {
	stub_claude_extract
	local config
	config=$(make_config_dir "claude-personal")

	CLAUDE_CONFIG_DIR="$config" "$SYSTEM_BASH" "$SHIM" "$SESSION_ID" >/dev/null 2>&1 ||
		fail "shim failed with CLAUDE_CONFIG_DIR=$config"

	# Each recorded HOME was a mktemp dir; none may survive the run.
	while IFS= read -r line; do
		case "$line" in
		link:*) continue ;;
		esac
		[ ! -d "$line" ] || fail "shim home $line was left behind"
	done <"$STUB_LOG"
}
