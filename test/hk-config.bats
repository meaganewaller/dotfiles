#!/usr/bin/env bats

load test_helper

# The HOME hk config.
#
# home/dot_config/hk/config.pkl deploys via chezmoi to ~/.config/hk/config.pkl,
# and hk reads it whenever it runs manually in ANY repository on this machine,
# client work included. It only runs automatically, via the seeded git hooks,
# in repositories under a beads.personal_dirs prefix that also have their own
# hk.pkl (home/.chezmoitemplates/git-hooks/beads-shim).
# Nothing else exercises it: hk.pkl (the project's own config) gets evaluated
# for free whenever `hk check` runs in CI, but this file was hand-edited until
# Renovate started managing it too (renovate.json5), and `chezmoi apply` never
# evaluates Pkl. A schema bump that breaks this file would go unnoticed until
# a real `git commit` fails in every repo on the machine.

CONFIG_FILE="home/dot_config/hk/config.pkl"

# The tail of a made-up AWS access key ID, kept apart from its "AKIA" prefix so
# this file never matches a scanner itself. It has to look random: betterleaks
# drops AWS key IDs with entropy <= 3.0 as placeholders, so the old fixture,
# AKIA + LALEMEL33243OLIA, passed every scan once the hooks moved off gitleaks.
FAKE_KEY_ID_TAIL="Q3ZJ7X2M9KVR4TPL"

repo_root() {
	cd "${BATS_TEST_DIRNAME}/.." && pwd
}

@test "the HOME hk config evaluates against its declared schema" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"

	run pkl eval "$(repo_root)/$CONFIG_FILE"
	[ "$status" -eq 0 ] || fail "pkl eval failed: $output"
	[[ "$output" == *"betterleaks"* ]] || fail "eval succeeded but output looks empty: $output"
}

# The hooks run in repositories that pin nothing of their own, so every tool a
# step calls has to come from the global mise config. The project's mise.toml
# pins a scanner too, but only for CI and only here -- which is how a gitleaks
# step passed in this repo while failing every push elsewhere with "No version
# is set for shim: gitleaks" (dotfiles-00b).
@test "every hk step runs a tool the global mise config installs" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"

	local mise_config commands cmd bin
	mise_config="$(repo_root)/home/dot_config/mise/config.toml.tmpl"
	commands="$(pkl eval -x 'hooks.toMap().values.flatMap((h) -> h.steps.toMap().values.map((s) -> s.check)).join("\n")' "$(repo_root)/$CONFIG_FILE")" ||
		fail "could not read the step commands from $CONFIG_FILE"
	[ -n "$commands" ] || fail "no step commands found in $CONFIG_FILE"

	while IFS= read -r cmd; do
		bin="${cmd%% *}"
		grep -Eq "^(\"[a-z]+:[^\"/]+/)?$bin\"?[[:space:]]*=" "$mise_config" ||
			fail "step command '$cmd' runs '$bin', which $mise_config does not install"
	done <<<"$commands"
}

# The exact command the config declares for <hook>'s betterleaks step, so these
# tests exercise what is configured rather than a copy of it. A copy could
# pass while the config stayed broken -- which is how the pre-push scan ran
# for months without scanning anything.
# Captured by the caller, so it runs in a subshell and `fail` here would not
# end the test. The caller must guard the result with a non-empty check.
scan_command() {
	pkl eval -x "hooks[\"$1\"].steps[\"betterleaks\"].check" "$(repo_root)/$CONFIG_FILE"
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
	# This machine signs commits via 1Password's op-ssh-sign; a CI runner has
	# no such binary. Override locally so the throwaway repo can commit
	# without it, rather than inheriting a global config it cannot satisfy.
	git -C "$work" config commit.gpgsign false
	git -C "$work" remote add origin "$remote"
	printf 'clean\n' >"$work/a.txt"
	git -C "$work" add a.txt
	git -C "$work" commit -qm "clean commit" || fail "commit failed"
	git -C "$work" push -q origin HEAD:refs/heads/main || fail "push failed"
	git -C "$work" fetch -q origin || fail "fetch failed"
}

@test "the pre-push scan rejects an unpushed commit containing a secret" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-push)"
	[ -n "$cmd" ] || fail "could not read the pre-push command from $CONFIG_FILE"

	# A secret in a commit that has NOT been pushed. This is exactly what
	# pre-push exists to catch: a commit that never passed pre-commit.
	printf 'awsToken = AKIA%s\n' "$FAKE_KEY_ID_TAIL" >"$work/leak.txt"
	git -C "$work" add leak.txt
	git -C "$work" commit -qm "unpushed secret" || fail "commit failed"

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -ne 0 ] || fail "the pre-push scan passed on an unpushed secret; command was: $cmd
output: $output"
}

@test "the pre-push scan passes when nothing is unpushed" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

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
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-commit)"
	[ -n "$cmd" ] || fail "could not read the pre-commit command from $CONFIG_FILE"

	# Staged but not committed -- what pre-commit sees.
	printf 'awsToken = AKIA%s\n' "$FAKE_KEY_ID_TAIL" >"$work/leak.txt"
	git -C "$work" add leak.txt

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -ne 0 ] || fail "the pre-commit scan passed on a staged secret; command was: $cmd
output: $output"
}

@test "the pre-commit scan passes when nothing is staged" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-commit)"
	[ -n "$cmd" ] || fail "could not read the pre-commit command from $CONFIG_FILE"

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -eq 0 ] || fail "the pre-commit scan failed with nothing staged; command was: $cmd
output: $output"
}
