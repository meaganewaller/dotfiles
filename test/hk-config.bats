#!/usr/bin/env bats

load test_helper

# The HOME hk config.
#
# home/dot_config/hk/config.pkl deploys via chezmoi to ~/.config/hk/config.pkl,
# and hk reads it in EVERY repository on this machine, client work included.
# Nothing else exercises it: hk.pkl (the project's own config) gets evaluated
# for free whenever `hk check` runs in CI, but this file was hand-edited until
# Renovate started managing it too (renovate.json5), and `chezmoi apply` never
# evaluates Pkl. A schema bump that breaks this file would go unnoticed until
# a real `git commit` fails in every repo on the machine.

CONFIG_FILE="home/dot_config/hk/config.pkl"

repo_root() {
	cd "${BATS_TEST_DIRNAME}/.." && pwd
}

@test "the HOME hk config evaluates against its declared schema" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"

	run pkl eval "$(repo_root)/$CONFIG_FILE"
	[ "$status" -eq 0 ] || fail "pkl eval failed: $output"
	[[ "$output" == *"gitleaks"* ]] || fail "eval succeeded but output looks empty: $output"
}

# The exact command the config declares for <hook>'s gitleaks step, so these
# tests exercise what is configured rather than a copy of it. A copy could
# pass while the config stayed broken -- which is how the pre-push scan ran
# for months without scanning anything.
# Captured by the caller, so it runs in a subshell and `fail` here would not
# end the test. The caller must guard the result with a non-empty check.
scan_command() {
	pkl eval -x "hooks[\"$1\"].steps[\"gitleaks\"].check" "$(repo_root)/$CONFIG_FILE"
}

# A repository at <dir> with a bare origin and one pushed commit, so that
# "HEAD --not --remotes" has a remote to subtract. Created with no template so
# this machine's own hooks stay out of it.
#
# Takes the directory as an argument rather than printing it, matching
# make_repo() in test/beads-policy.bats. That is not just style: a helper whose
# output is captured runs in a subshell, where `fail`'s `exit 1` would end only
# the subshell and let the test carry on with an empty path -- silently
# under-asserting, which is the exact failure test_helper.bash warns about.
make_pushed_repo() {
	local work="$1" remote="$1.remote.git"
	git init -q --bare --template= "$remote" || fail "git init --bare failed"
	git init -q --template= "$work" || fail "git init failed"
	git -C "$work" config user.email "test@example.com"
	git -C "$work" config user.name "Test"
	git -C "$work" remote add origin "$remote"
	printf 'clean\n' >"$work/a.txt"
	git -C "$work" add a.txt
	git -C "$work" commit -qm "clean commit" || fail "commit failed"
	git -C "$work" push -q origin HEAD:refs/heads/main || fail "push failed"
	git -C "$work" fetch -q origin || fail "fetch failed"
}

@test "the pre-push scan rejects an unpushed commit containing a secret" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v gitleaks >/dev/null 2>&1 || skip "gitleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-push)"
	[ -n "$cmd" ] || fail "could not read the pre-push command from $CONFIG_FILE"

	# A secret in a commit that has NOT been pushed. This is exactly what
	# pre-push exists to catch: a commit that never passed pre-commit.
	printf 'awsToken = AKIA%s\n' 'LALEMEL33243OLIA' >"$work/leak.txt"
	git -C "$work" add leak.txt
	git -C "$work" commit -qm "unpushed secret" || fail "commit failed"

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -ne 0 ] || fail "the pre-push scan passed on an unpushed secret; command was: $cmd
output: $output"
}

@test "the pre-push scan passes when nothing is unpushed" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v gitleaks >/dev/null 2>&1 || skip "gitleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-push)"
	[ -n "$cmd" ] || fail "could not read the pre-push command from $CONFIG_FILE"

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -eq 0 ] || fail "the pre-push scan failed with nothing to push; command was: $cmd
output: $output"
}

@test "the pre-commit scan rejects a staged secret" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v gitleaks >/dev/null 2>&1 || skip "gitleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-commit)"
	[ -n "$cmd" ] || fail "could not read the pre-commit command from $CONFIG_FILE"

	# Staged but not committed -- what pre-commit sees.
	printf 'awsToken = AKIA%s\n' 'LALEMEL33243OLIA' >"$work/leak.txt"
	git -C "$work" add leak.txt

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -ne 0 ] || fail "the pre-commit scan passed on a staged secret; command was: $cmd
output: $output"
}

@test "the pre-commit scan passes when nothing is staged" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v gitleaks >/dev/null 2>&1 || skip "gitleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-commit)"
	[ -n "$cmd" ] || fail "could not read the pre-commit command from $CONFIG_FILE"

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -eq 0 ] || fail "the pre-commit scan failed with nothing staged; command was: $cmd
output: $output"
}
