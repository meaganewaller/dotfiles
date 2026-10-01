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
SCAN_SCRIPT="home/dot_config/hk/executable_pre-push-scan"

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

	local mise_config commands cmd bin name
	mise_config="$(repo_root)/home/dot_config/mise/config.toml.tmpl"
	commands="$(pkl eval -x 'hooks.toMap().values.flatMap((h) -> h.steps.toMap().values.map((s) -> s.check)).join("\n")' "$(repo_root)/$CONFIG_FILE")" ||
		fail "could not read the step commands from $CONFIG_FILE"
	[ -n "$commands" ] || fail "no step commands found in $CONFIG_FILE"

	while IFS= read -r cmd; do
		bin="${cmd%% *}"
		# A script this config deploys next to itself. The scanner it runs is
		# held to the same rule by the next assertion.
		if [[ "$bin" == '"$HOME/.config/hk/'*'"' ]]; then
			name="${bin#'"$HOME/.config/hk/'}"
			name="${name%'"'}"
			[ -f "$(repo_root)/home/dot_config/hk/executable_$name" ] ||
				fail "step command '$cmd' runs a script that home/dot_config/hk/ does not deploy"
			bin="$(grep -oE '^exec [a-z]+' "$(repo_root)/home/dot_config/hk/executable_$name" | sort -u | awk '{print $2}')"
			[ "$(printf '%s\n' "$bin" | wc -l)" -eq 1 ] && [ -n "$bin" ] ||
				fail "could not tell which tool executable_$name runs: '$bin'"
		fi
		grep -Eq "^(\"[a-z]+:[^\"/]+/)?$bin\"?[[:space:]]*=" "$mise_config" ||
			fail "step command '$cmd' runs '$bin', which $mise_config does not install"
	done <<<"$commands"
}

# The hooks run the global hk wherever a repository pins none of its own, and
# that binary evaluates this config, which amends one exact schema. So the
# global pin, both schemas and this repository's own pin have to be one
# version: "latest" in the global config froze at whatever was first locked
# (1.45.0 here, against a v2 schema) while Renovate kept moving the schemas
# (dotfiles-iyo).
@test "the global hk pin, both hk schemas and this repo's hk pin agree" {
	local root global user project repo
	root="$(repo_root)"
	global="$(sed -nE 's/^"aqua:jdx\/hk"[[:space:]]*=[[:space:]]*"v?([^"]+)".*/\1/p' "$root/home/dot_config/mise/config.toml.tmpl")"
	user="$(grep -oE 'releases/download/v[^/]+/hk@' "$root/$CONFIG_FILE" | sed -E 's|.*/v([^/]+)/hk@|\1|' | sort -u)"
	project="$(grep -oE 'releases/download/v[^/]+/hk@' "$root/hk.pkl" | sed -E 's|.*/v([^/]+)/hk@|\1|' | sort -u)"
	repo="$(sed -nE 's/^hk[[:space:]]*=[[:space:]]*"v?([^"]+)".*/\1/p' "$root/mise.toml")"

	[ -n "$global" ] && [ -n "$user" ] && [ -n "$project" ] && [ -n "$repo" ] ||
		fail "could not read every hk version: global='$global' user='$user' project='$project' repo='$repo'"
	[ "$global" = "$user" ] && [ "$user" = "$project" ] && [ "$project" = "$repo" ] ||
		fail "hk versions disagree: global mise config $global, $CONFIG_FILE $user, hk.pkl $project, mise.toml $repo"
}

# Agreement only lasts if Renovate moves all four at once. Without a group it
# opened one PR per manager (#377 and #378 for 2.3.1), so merging one left the
# others behind.
@test "Renovate bumps every hk version in one PR" {
	local rules
	rules="$(tr -d '[:space:]' <"$(repo_root)/renovate.json5")"
	[[ "$rules" == *"matchDepNames:['jdx/hk','hk',],groupName:'hk'"* ]] ||
		fail "renovate.json5 has no packageRule grouping jdx/hk and hk under groupName 'hk'"
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

ZERO_SHA=0000000000000000000000000000000000000000

# Runs the configured pre-push step in <work> with <input> on stdin, the way hk
# does from git's hook: hk renders the step's `stdin` template -- the remote
# name and URL, then git's own pre-push lines -- and pipes it to the command.
#
# The command runs the deployed script, $HOME/.config/hk/pre-push-scan. Point
# it at the source file instead, so the test runs what is committed without
# needing a chezmoi apply.
#
# Called directly, never captured, so `fail` here does end the test; `run`
# leaves $status and $output for the caller.
run_pre_push() {
	local work="$1" input="$2" cmd deployed script
	cmd="$(scan_command pre-push)"
	[ -n "$cmd" ] || fail "could not read the pre-push command from $CONFIG_FILE"
	deployed='"$HOME/.config/hk/pre-push-scan"'
	script="sh \"$(repo_root)/$SCAN_SCRIPT\""
	[[ "$cmd" == "$deployed"* ]] ||
		fail "the pre-push command does not run the deployed scan script: $cmd"
	# Prefix removal, not ${cmd//pattern/"$script"}: bash 3.2, which macOS
	# ships, keeps the quotes of a quoted replacement as literal characters.
	cmd="$script${cmd#"$deployed"}"

	cd "$work" || fail "cd failed"
	run bash -c 'printf "%s" "$1" | eval "$2"' _ "$input" "$cmd"
}

# A failing scan must fail on a finding. A missing script or a bad flag exits
# nonzero too, and would otherwise pass every "rejects" test.
assert_leak_found() {
	[[ "$output" == *"leaks found"* ]] || fail "the scan failed without a finding; output: $output"
}

# Commits a secret to whatever branch <work> has checked out.
commit_secret() {
	printf 'awsToken = AKIA%s\n' "$FAKE_KEY_ID_TAIL" >"$1/leak.txt"
	git -C "$1" add leak.txt
	git -C "$1" commit -qm "secret" || fail "commit failed"
}

# git's pre-push line for pushing the checked-out branch to origin's main.
push_head_line() {
	printf '%s %s refs/heads/main %s\n' \
		"$(git -C "$1" symbolic-ref HEAD)" "$(git -C "$1" rev-parse HEAD)" \
		"$(git -C "$1" rev-parse origin/main)"
}

@test "the pre-push step pipes the remote, then git's push lines, to the scan" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"

	local stdin
	stdin="$(pkl eval -x 'hooks["pre-push"].steps["betterleaks"].stdin' "$(repo_root)/$CONFIG_FILE")" ||
		fail "could not read the pre-push stdin template from $CONFIG_FILE"
	[ "$stdin" = $'{{ hook_args }}\n{{ hook_stdin }}' ] ||
		fail "run_pre_push feeds input in a shape the config no longer declares: $stdin"
}

@test "the pre-push scan script passes shellcheck" {
	command -v shellcheck >/dev/null 2>&1 || skip "shellcheck not installed"

	shellcheck "$(repo_root)/$SCAN_SCRIPT" || fail "shellcheck rejected $SCAN_SCRIPT"
}

@test "the pre-push scan rejects an unpushed commit containing a secret" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work"
	make_pushed_repo "$work"
	# A secret in a commit that has NOT been pushed. This is exactly what
	# pre-push exists to catch: a commit that never passed pre-commit.
	commit_secret "$work"

	run_pre_push "$work" "origin $work.remote.git"$'\n'"$(push_head_line "$work")"
	[ "$status" -ne 0 ] || fail "the pre-push scan passed on an unpushed secret; output: $output"
	assert_leak_found
}

@test "the pre-push scan passes when nothing is unpushed" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work"
	make_pushed_repo "$work"

	run_pre_push "$work" "origin $work.remote.git"$'\n'"$(push_head_line "$work")"
	[ "$status" -eq 0 ] || fail "the pre-push scan failed with nothing to push; output: $output"
}

# dotfiles-pe8, gap 1: the scan used to range over HEAD, so pushing any other
# branch sent its commits unscanned.
@test "the pre-push scan catches a secret on a branch that isn't checked out" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work"
	make_pushed_repo "$work"
	git -C "$work" checkout -q -b feature
	commit_secret "$work"
	git -C "$work" checkout -q -

	run_pre_push "$work" "origin $work.remote.git"$'\n'"refs/heads/feature $(git -C "$work" rev-parse feature) refs/heads/feature $ZERO_SHA"
	[ "$status" -ne 0 ] || fail "pushing a non-HEAD branch skipped its secret; output: $output"
	assert_leak_found
}

# dotfiles-pe8, gap 2: --remotes subtracted every remote, so a secret already
# on upstream slipped through a push to origin -- the private-fork-to-public
# direction.
@test "the pre-push scan catches a secret that only another remote has" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work"
	make_pushed_repo "$work"
	git init -q --bare --template= "$work.upstream.git" || fail "git init --bare failed"
	git -C "$work" remote add upstream "$work.upstream.git"
	commit_secret "$work"
	git -C "$work" push -q upstream HEAD:refs/heads/main || fail "push to upstream failed"
	git -C "$work" fetch -q upstream || fail "fetch failed"

	run_pre_push "$work" "origin $work.remote.git"$'\n'"$(push_head_line "$work")"
	[ "$status" -ne 0 ] || fail "a secret on upstream was pushed to origin unscanned; output: $output"
	assert_leak_found
}

# The flip side of gap 1: scanning every local branch would catch it, but then
# one stale WIP branch blocks every unrelated push -- training --no-verify.
@test "the pre-push scan ignores secrets the push target already has" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work"
	make_pushed_repo "$work"
	commit_secret "$work"
	git -C "$work" push -q origin HEAD:refs/heads/main || fail "push failed"
	git -C "$work" fetch -q origin || fail "fetch failed"
	git -C "$work" checkout -q -b feature
	printf 'clean\n' >"$work/b.txt"
	git -C "$work" add b.txt
	git -C "$work" commit -qm "clean feature" || fail "commit failed"

	run_pre_push "$work" "origin $work.remote.git"$'\n'"refs/heads/feature $(git -C "$work" rev-parse feature) refs/heads/feature $ZERO_SHA"
	[ "$status" -eq 0 ] || fail "a new branch was blocked by a secret origin already has; output: $output"
}

@test "the pre-push scan passes a branch deletion without scanning HEAD" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work"
	make_pushed_repo "$work"
	# An unpushed secret on HEAD that a deletion does not send. Scanning it
	# anyway would mean the script fell back instead of reading the push.
	commit_secret "$work"

	run_pre_push "$work" "origin $work.remote.git"$'\n'"(delete) $ZERO_SHA refs/heads/old $(git -C "$work" rev-parse origin/main)"
	[ "$status" -eq 0 ] || fail "a branch deletion was blocked; output: $output"
}

# hk renders an empty template outside git's hook (a manual `hk run pre-push`).
# The scan must still scan something, and say what, rather than silently
# scanning nothing -- the original pre-push bug (dotfiles-6c6).
@test "the pre-push scan falls back to HEAD and says so outside a git push" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v betterleaks >/dev/null 2>&1 || skip "betterleaks not installed"

	local work="$TEST_TMPDIR/work"
	make_pushed_repo "$work"
	commit_secret "$work"

	run_pre_push "$work" $'\n'
	[ "$status" -ne 0 ] || fail "the fallback scan missed an unpushed secret on HEAD; output: $output"
	assert_leak_found
	[[ "$output" == *"HEAD --not --remotes"* ]] || fail "the fallback did not say what it scanned; output: $output"
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
