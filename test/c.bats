#!/usr/bin/env bats

# Tests for home/dot_config/zsh/functions/c
# Autoloads `c` into a clean zsh with a fake HOME and stubbed gh and git, then
# prints where the shell ended up, so each test sees the cd `c` performed and
# whether the calling shell survived.

load test_helper

setup() {
	TEST_TMPDIR=$(mktemp -d)
	FUNCTIONS_DIR="$BATS_TEST_DIRNAME/../home/dot_config/zsh/functions"

	export HOME="$TEST_TMPDIR/home"
	export PROJECTS_DIR="$TEST_TMPDIR/projects"
	export USER=me
	mkdir -p "$HOME" "$PROJECTS_DIR"
	unset GITHUB_USER GITHUB_ORGS

	STUB_BIN="$TEST_TMPDIR/bin"
	mkdir -p "$STUB_BIN"
	# gh has no logged-in user, so only GITHUB_USER/GITHUB_ORGS/USER count.
	printf '#!/usr/bin/env bash\nexit 1\n' >"$STUB_BIN/gh"
	# git clone succeeds only for repos listed in $CLONEABLE, and like real git
	# it reports progress, so a caller capturing stdout would see any leak.
	cat >"$STUB_BIN/git" <<'STUB'
#!/usr/bin/env bash
if [[ "$1" == clone ]]; then
	case " ${CLONEABLE:-} " in
	*" $2 "*) mkdir -p "$3"; echo "Cloning into '$3'..."; exit 0 ;;
	*) echo "fatal: repository '$2' not found" >&2; exit 128 ;;
	esac
fi
exit 0
STUB
	chmod +x "$STUB_BIN"/*
	export PATH="$STUB_BIN:$PATH"
}

teardown() {
	rm -rf "$TEST_TMPDIR"
}

# Run `c "$@"` the way an interactive shell does (autoload -Uz), then report
# the shell's state. stdin is /dev/null, so the create prompt can't be answered.
run_c() {
	run zsh -f -c '
		fpath=("$1" $fpath); shift
		autoload -Uz c
		c "$@"
		echo "STATUS=$?"
		echo "PWD=$PWD"
		echo "SURVIVED"
	' zsh "$FUNCTIONS_DIR" "$@" </dev/null
}

assert_in_project() {
	local project="$1"
	[[ "$output" == *"PWD=$PROJECTS_DIR/$project"$'\n'* ]] || fail "expected cd into $project, output=$output"
	[[ "$output" == *"SURVIVED"* ]] || fail "shell exited, output=$output"
}

@test "c ORG/REPO cds into an existing project" {
	mkdir -p "$PROJECTS_DIR/acme/widget"
	run_c acme/widget
	assert_in_project acme/widget
	[[ "$output" == *"STATUS=0"* ]] || fail "output=$output"
}

@test "c REPO finds a local repo under an org from comma-separated GITHUB_ORGS" {
	export GITHUB_ORGS="acme, other-org"
	mkdir -p "$PROJECTS_DIR/other-org/widget"
	run_c widget
	assert_in_project other-org/widget
}

@test "c REPO clones into ORG/REPO, not into git's progress output" {
	export GITHUB_ORGS="acme"
	export CLONEABLE="https://github.com/acme/widget.git"
	run_c widget
	assert_in_project acme/widget
	[[ "$output" == *"STATUS=0"* ]] || fail "output=$output"
}

@test "a failed clone and unanswered create prompt return to the shell" {
	run_c acme/missing
	[[ "$output" == *"SURVIVED"* ]] || fail "c exited the calling shell, output=$output"
	[[ "$output" == *"STATUS=1"* ]] || fail "expected c to fail, output=$output"
	[ ! -d "$PROJECTS_DIR/acme/missing" ] || fail "created a repo nobody agreed to"
}

@test "c REPO that nobody has returns to the shell" {
	run_c missing
	[[ "$output" == *"SURVIVED"* ]] || fail "c exited the calling shell, output=$output"
	[[ "$output" == *"STATUS=1"* ]] || fail "expected c to fail, output=$output"
}

@test "c leaves no helper functions or variables in the user's shell" {
	mkdir -p "$PROJECTS_DIR/acme/widget"
	run zsh -f -c '
		fpath=("$1" $fpath)
		autoload -Uz c
		before=(${(k)functions})
		c acme/widget >/dev/null
		after=(${(k)functions})
		echo "NEW=${(j: :)${after:|before}}"
		echo "ORG=${org-<unset>}"
	' zsh "$FUNCTIONS_DIR"
	[[ "$output" == *"NEW="$'\n'* || "$output" == *"NEW=" ]] || fail "leaked functions: $output"
	[[ "$output" == *"ORG=<unset>"* ]] || fail "leaked variables: $output"
}
