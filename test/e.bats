#!/usr/bin/env bats

# Tests for home/dot_local/bin/executable_e
# Runs `e` with a fake HOME and stubbed claude, gh, git, and tmux, so each test
# can see which account directory and project `e` launched Claude Code with.

load test_helper

setup() {
	TEST_TMPDIR=$(mktemp -d)
	E_SCRIPT="$BATS_TEST_DIRNAME/../home/dot_local/bin/executable_e"

	export HOME="$TEST_TMPDIR/home"
	export PROJECTS_DIR="$TEST_TMPDIR/projects"
	export USER=me
	mkdir -p "$HOME/.claude-personal" "$PROJECTS_DIR"
	unset GITHUB_USER GITHUB_ORGS CLAUDE_ACCOUNT CLAUDE_CONFIG_DIR TMUX

	STUB_BIN="$TEST_TMPDIR/bin"
	mkdir -p "$STUB_BIN"
	# claude records how it was launched instead of starting a session.
	cat >"$STUB_BIN/claude" <<'STUB'
#!/usr/bin/env bash
echo "CONFIG=${CLAUDE_CONFIG_DIR-<unset>}"
echo "PWD=$PWD"
echo "ARGS=$*"
STUB
	# gh has no logged-in user, so only GITHUB_USER/GITHUB_ORGS/USER count.
	printf '#!/usr/bin/env bash\nexit 1\n' >"$STUB_BIN/gh"
	# git clone succeeds only for repos listed in $CLONEABLE.
	cat >"$STUB_BIN/git" <<'STUB'
#!/usr/bin/env bash
if [[ "$1" == clone ]]; then
	case " ${CLONEABLE:-} " in
	*" $2 "*) mkdir -p "$3"; echo "Cloning into '$3'..." >&2; exit 0 ;;
	*) echo "fatal: repository '$2' not found" >&2; exit 128 ;;
	esac
fi
exit 0
STUB
	printf '#!/usr/bin/env bash\necho "${TMUX_ACCOUNT:-}"\n' >"$STUB_BIN/tmux"
	chmod +x "$STUB_BIN"/*
	export PATH="$STUB_BIN:$PATH"
}

teardown() {
	rm -rf "$TEST_TMPDIR"
}

run_e() {
	run zsh "$E_SCRIPT" "$@"
}

assert_launched() {
	local account="$1" project="$2"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"CONFIG=$HOME/.claude-$account"* ]] || fail "expected account $account, output=$output"
	[[ "$output" == *"PWD=$PROJECTS_DIR/$project"* ]] || fail "expected project $project, output=$output"
}

@test "ORG/REPO launches claude with the only account's config dir" {
	mkdir -p "$PROJECTS_DIR/acme/widget"
	run_e acme/widget
	assert_launched personal acme/widget
	[[ "$output" == *"ARGS=--add-dir $HOME/src"* ]] || fail "output=$output"
}

@test "REPO finds an existing local repo under GITHUB_ORGS without cloning" {
	mkdir -p "$PROJECTS_DIR/acme/widget"
	GITHUB_ORGS=acme run_e widget
	assert_launched personal acme/widget
	[[ "$output" != *"Cloning"* ]] || fail "should not clone, output=$output"
}

@test "GITHUB_ORGS is split on commas and trimmed" {
	mkdir -p "$PROJECTS_DIR/beta/widget"
	GITHUB_ORGS="acme, beta" run_e widget
	assert_launched personal beta/widget
}

@test "REPO that only exists upstream is cloned and opened" {
	CLONEABLE="https://github.com/beta/widget.git" GITHUB_ORGS=acme,beta run_e widget
	assert_launched personal beta/widget
}

@test "several accounts and no choice fails without launching claude" {
	mkdir -p "$HOME/.claude-work" "$PROJECTS_DIR/acme/widget"
	run_e acme/widget
	[ "$status" -ne 0 ] || fail "expected failure, output=$output"
	[[ "$output" == *"personal"*"work"* ]] || fail "expected the accounts listed, output=$output"
	[[ "$output" != *"CONFIG="* ]] || fail "claude should not run, output=$output"
}

@test "CLAUDE_ACCOUNT picks the account" {
	mkdir -p "$HOME/.claude-work" "$PROJECTS_DIR/acme/widget"
	CLAUDE_ACCOUNT=work run_e acme/widget
	assert_launched work acme/widget
}

@test "inside tmux, @claude_account picks the account" {
	mkdir -p "$HOME/.claude-work" "$PROJECTS_DIR/acme/widget"
	TMUX=/tmp/tmux-1/default TMUX_ACCOUNT=work run_e acme/widget
	assert_launched work acme/widget
}

@test "--account overrides CLAUDE_ACCOUNT" {
	mkdir -p "$HOME/.claude-work" "$PROJECTS_DIR/acme/widget"
	CLAUDE_ACCOUNT=work run_e --account personal acme/widget
	assert_launched personal acme/widget
}

@test "an unknown account fails without launching claude" {
	mkdir -p "$PROJECTS_DIR/acme/widget"
	run_e --account nope acme/widget
	[ "$status" -ne 0 ] || fail "expected failure, output=$output"
	[[ "$output" == *"nope"* ]] || fail "output=$output"
	[[ "$output" != *"CONFIG="* ]] || fail "claude should not run, output=$output"
}
