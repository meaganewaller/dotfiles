#!/usr/bin/env bats

load test_helper

TEMPLATE="home/dot_local/bin/executable_claude-session-gist.tmpl"
DATA="home/.chezmoidata/pr.yaml"

EXIT_BLOCKED=3

# The macOS system bash. This suite pins it deliberately: the shim ships to a
# Mac and runs under `#!/usr/bin/env bash`, which resolves to /bin/bash (3.2.57)
# on a default PATH. Every bash-4-only construct that reached this script --
# `${var,,}` was the first -- broke the blocklist while still passing a
# `bash -n` syntax check under a Homebrew bash 5. Run the guard where it lives.
SYSTEM_BASH="/bin/bash"

# Render the shim to a runnable file, echoing its path.
render_shim() {
	chezmoi execute-template --file "$TEMPLATE" >"$TEST_TMPDIR/gist.sh" ||
		fail "chezmoi execute-template failed for $TEMPLATE"
	printf '%s\n' "$TEST_TMPDIR/gist.sh"
}

# Create a git repo with an optional remote, echoing its path.
make_repo() {
	local url="${1:-}" dir="$TEST_TMPDIR/repo.$RANDOM"

	mkdir -p "$dir"
	git -C "$dir" init -q . || fail "git init failed"
	if [ -n "$url" ]; then
		git -C "$dir" remote add origin "$url" || fail "git remote add failed"
	fi
	printf '%s\n' "$dir"
}

# Run the shim from inside a repo with the given remote, under the given bash.
# Echoes the exit status; stdout/stderr land in $SHIM_OUT / $SHIM_ERR.
#
# A non-blocked repo exits 1 on the missing claude-extract-session sibling,
# which is fine: these tests only care whether the guard fired, and "exit 3 with
# empty stdout" is exactly the contract the /pr skill keys off.
run_shim() {
	local shell_bin="$1" url="$2" repo status=0

	repo=$(make_repo "$url")
	SHIM_OUT=$(cd "$repo" && "$shell_bin" "$SHIM" some-session-id 2>"$TEST_TMPDIR/err") || status=$?
	SHIM_ERR=$(cat "$TEST_TMPDIR/err")
	printf '%s\n' "$status"
}

setup_shim() {
	SHIM=$(render_shim)
}

@test "rendered shim is valid bash under the macOS system bash" {
	setup_shim

	"$SYSTEM_BASH" -n "$SHIM" || fail "rendered shim is not valid bash 3.2 syntax"
}

@test "blocklist blocks scp-style remotes under the macOS system bash" {
	setup_shim

	status=$(run_shim "$SYSTEM_BASH" "git@github.com:testdouble/example.git")

	[ "$status" -eq "$EXIT_BLOCKED" ] ||
		fail "expected exit $EXIT_BLOCKED, got $status (stderr: $SHIM_ERR)"
	[ -z "$SHIM_OUT" ] || fail "blocked repo must write nothing to stdout, got: $SHIM_OUT"
}

@test "blocklist blocks https remotes under the macOS system bash" {
	setup_shim

	status=$(run_shim "$SYSTEM_BASH" "https://github.com/testdouble/example.git")

	[ "$status" -eq "$EXIT_BLOCKED" ] ||
		fail "expected exit $EXIT_BLOCKED, got $status (stderr: $SHIM_ERR)"
}

@test "blocklist blocks ssh:// remotes under the macOS system bash" {
	setup_shim

	status=$(run_shim "$SYSTEM_BASH" "ssh://git@github.com/testdouble/example")

	[ "$status" -eq "$EXIT_BLOCKED" ] ||
		fail "expected exit $EXIT_BLOCKED, got $status (stderr: $SHIM_ERR)"
}

# The regression that motivated this suite. Case folding used `${var,,}`, which
# is a bash 4 feature; under bash 3.2 it raised "bad substitution" and the
# blocklist stopped matching entirely. A capitalized org name is the cheapest
# way to keep case-insensitive matching honest.
@test "blocklist matching is case-insensitive under the macOS system bash" {
	setup_shim

	status=$(run_shim "$SYSTEM_BASH" "git@github.com:TestDouble/Example.git")

	[ "$status" -eq "$EXIT_BLOCKED" ] ||
		fail "mixed-case remote was not blocked: exit $status (stderr: $SHIM_ERR)"
	[[ "$SHIM_ERR" != *"bad substitution"* ]] ||
		fail "shim used a bash 4 expansion: $SHIM_ERR"
}

@test "every configured blocklist org is actually blocked" {
	setup_shim

	local org
	for org in gifthealth testdouble testdoublelabs; do
		status=$(run_shim "$SYSTEM_BASH" "git@github.com:$org/example.git")
		[ "$status" -eq "$EXIT_BLOCKED" ] ||
			fail "org '$org' is in $DATA but was not blocked: exit $status (stderr: $SHIM_ERR)"
	done
}

@test "a personal repo is not blocked" {
	setup_shim

	status=$(run_shim "$SYSTEM_BASH" "git@github.com:meaganewaller/dotfiles.git")

	[ "$status" -ne "$EXIT_BLOCKED" ] ||
		fail "personal repo was wrongly blocked (stderr: $SHIM_ERR)"
}

@test "a repo with no remote is not blocked" {
	setup_shim

	status=$(run_shim "$SYSTEM_BASH" "")

	[ "$status" -ne "$EXIT_BLOCKED" ] ||
		fail "repo without a remote was wrongly blocked (stderr: $SHIM_ERR)"
}

# Fail-closed: an unmatchable remote must block rather than publish. Guarding a
# conversation log is worth a false positive; the reverse is not.
@test "an unnormalizable remote blocks rather than publishing" {
	setup_shim

	# A remote that normalizes to the empty string: scheme and user@ strip away
	# to nothing at all.
	status=$(run_shim "$SYSTEM_BASH" "ssh://git@")

	[ "$status" -eq "$EXIT_BLOCKED" ] ||
		fail "unnormalizable remote should fail closed: exit $status (stderr: $SHIM_ERR)"
}

@test "blocklist patterns come from the pr.yaml data file" {
	setup_shim

	grep -q 'testdoublelabs' "$DATA" || fail "testdoublelabs missing from $DATA"
	grep -q 'testdoublelabs' "$SHIM" ||
		fail "blocklist did not render from $DATA into the shim"
}

@test "shim is structurally sound and shellcheck-clean" {
	setup_shim

	assert_script_structure "$(cat "$SHIM")"
	if command -v shellcheck >/dev/null 2>&1; then
		shellcheck "$SHIM" || fail "shellcheck rejected the rendered shim"
	fi
}
