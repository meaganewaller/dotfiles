#!/usr/bin/env bats
#
# `bd linear` gets LINEAR_API_KEY injected per invocation; every other bd
# subcommand must not pay for it.
#
# bd is on the hot path here -- session hooks, `bd ready`, `bd prime`,
# `bd show`, `bd close` run several times a turn -- so wrapping the whole
# binary would put an `op read` in front of each of them and relocate the Touch
# ID cost that #345 removed from shell startup. The wrapper therefore dispatches
# on the first argument, and the assertions below are written to fail if anyone
# ever flattens it into a blanket alias.
#
# Three shells implement it: zsh and bash share ~/.config/shell/bd.sh, fish has
# its own twin, so every assertion runs against all three.
#
# See docs/superpowers/specs/2026-09-22-bd-linear-credential-wrapper-design.md.

load test_helper

REPO_ROOT() { cd "${BATS_TEST_DIRNAME}/.." && pwd; }

# Render both wrapper files and put stub `bd` and `fnox` binaries on PATH.
#
# The stubs are on PATH during `chezmoi execute-template` as well as during
# execution, because the templates gate on `lookPath` -- rendering without them
# would emit nothing and every assertion below would pass vacuously.
render_wrappers() {
	local repo
	repo="$(REPO_ROOT)"

	mkdir -p "$TEST_TMPDIR/bin"

	# Reports the arguments it was handed, so the test can tell a wrapped call
	# from a direct one and confirm nothing is mangled in between.
	cat >"$TEST_TMPDIR/bin/bd" <<'STUB'
#!/bin/sh
printf 'BD ARGS=%s\n' "$*"
STUB

	# Records the invocation, then execs whatever follows `--`. Exec'ing rather
	# than exiting means the full chain runs, so a wrapper that calls fnox but
	# garbles the command after it still fails.
	cat >"$TEST_TMPDIR/bin/fnox" <<'STUB'
#!/bin/sh
printf 'FNOX %s\n' "$*" >>"$FNOX_LOG"
while [ "$#" -gt 0 ] && [ "$1" != "--" ]; do shift; done
[ "$#" -gt 0 ] && shift
exec "$@"
STUB

	chmod +x "$TEST_TMPDIR/bin/bd" "$TEST_TMPDIR/bin/fnox"

	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }
EOF

	PATH="$TEST_TMPDIR/bin:$PATH" chezmoi execute-template \
		--config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/home/dot_config/shell/bd.sh.tmpl" >"$TEST_TMPDIR/bd.sh" ||
		fail "could not render bd.sh.tmpl"

	PATH="$TEST_TMPDIR/bin:$PATH" chezmoi execute-template \
		--config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/home/dot_config/fish/conf.d/21-bd.fish.tmpl" >"$TEST_TMPDIR/bd.fish" ||
		fail "could not render 21-bd.fish.tmpl"

	# A template that rendered to nothing would make every assertion below pass
	# without testing anything.
	[ -s "$TEST_TMPDIR/bd.sh" ] || fail "bd.sh.tmpl rendered empty"
	[ -s "$TEST_TMPDIR/bd.fish" ] || fail "21-bd.fish.tmpl rendered empty"

	export FNOX_LOG="$TEST_TMPDIR/fnox.log"
	: >"$FNOX_LOG"
}

# Sets WRAPPER_SHELLS to the installed subset of zsh/bash/fish. Filtering up
# front rather than `skip`ping inside a loop keeps a missing shell from
# aborting the whole test and silently dropping the other two.
set_wrapper_shells() {
	WRAPPER_SHELLS=()
	local candidate
	for candidate in zsh bash fish; do
		command -v "$candidate" >/dev/null 2>&1 && WRAPPER_SHELLS+=("$candidate")
	done
	# bash is the floor. Without it every loop would iterate zero times and
	# these tests would pass vacuously, which is worse than failing.
	[[ " ${WRAPPER_SHELLS[*]} " == *" bash "* ]] ||
		fail "no wrapper shell installed (need at least bash)"
}

# run_in <zsh|bash|fish> <snippet> -- snippet runs with the wrapper sourced and
# only the stub bd/fnox on PATH.
run_in() {
	local shell="$1" snippet="$2"
	local shell_bin
	shell_bin="$(command -v "$shell")" ||
		fail "$shell vanished between detection and use"

	case "$shell" in
	zsh) run env HOME="$TEST_HOME_DIR" FNOX_LOG="$FNOX_LOG" \
		PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		"$shell_bin" --no-rcs -c "source '$TEST_TMPDIR/bd.sh'; $snippet" ;;
	bash) run env HOME="$TEST_HOME_DIR" FNOX_LOG="$FNOX_LOG" \
		PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		"$shell_bin" --norc -c "source '$TEST_TMPDIR/bd.sh'; $snippet" ;;
	fish) run env HOME="$TEST_HOME_DIR" FNOX_LOG="$FNOX_LOG" \
		PATH="$TEST_TMPDIR/bin:/usr/bin:/bin" \
		"$shell_bin" --no-config -c "source '$TEST_TMPDIR/bd.fish'; $snippet" ;;
	esac
}

@test "bd linear is routed through fnox exec in every shell" {
	render_wrappers
	set_wrapper_shells

	local shell
	for shell in "${WRAPPER_SHELLS[@]}"; do
		: >"$FNOX_LOG"
		run_in "$shell" 'bd linear sync --pull'

		[ "$status" -eq 0 ] || fail "$shell: status=$status output=$output"
		[[ "$output" == *"BD ARGS=linear sync --pull"* ]] ||
			fail "$shell: bd did not receive its arguments intact: $output"
		[ -s "$FNOX_LOG" ] ||
			fail "$shell: bd linear did not go through fnox, so LINEAR_API_KEY never reaches it"
		grep -q 'fnox/config.toml' "$FNOX_LOG" ||
			fail "$shell: fnox was invoked without the machine-wide config, so an ancestor fnox.toml could shadow it: $(cat "$FNOX_LOG")"
		grep -q -- '--if-missing error' "$FNOX_LOG" ||
			fail "$shell: fnox may resolve nothing and still exit 0, running bd linear unauthenticated: $(cat "$FNOX_LOG")"
	done
}

@test "every other bd subcommand skips fnox entirely" {
	render_wrappers
	set_wrapper_shells

	# Load-bearing for cost, not style. bd runs several times per agent turn;
	# routing all of it through fnox would mean an op read -- and a Touch ID
	# prompt -- on every hook invocation. That is the regression #345 fixed,
	# and this is the assertion that catches it coming back.
	local shell subcommand
	for shell in "${WRAPPER_SHELLS[@]}"; do
		for subcommand in ready prime 'show dotfiles-6y1' close; do
			: >"$FNOX_LOG"
			run_in "$shell" "bd $subcommand"

			[ "$status" -eq 0 ] || fail "$shell: bd $subcommand: status=$status output=$output"
			[[ "$output" == *"BD ARGS=$subcommand"* ]] ||
				fail "$shell: bd $subcommand did not reach bd intact: $output"
			[ ! -s "$FNOX_LOG" ] ||
				fail "$shell: 'bd $subcommand' went through fnox; every hook's bd call would cost an op read: $(cat "$FNOX_LOG")"
		done
	done
}

@test "zsh and bash both source the wrapper" {
	# The fish twin lands in conf.d and is sourced by fish automatically; the
	# POSIX file only runs if both rc files ask for it. A wrapper nothing
	# sources is the state this whole change exists to fix.
	local repo rc
	repo="$(REPO_ROOT)"

	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }
EOF

	for rc in dot_zshrc.tmpl dot_bashrc.tmpl; do
		run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" \
			--file "$repo/home/$rc"
		[ "$status" -eq 0 ] || fail "$rc: status=$status output=$output"
		[[ "$output" == *"shell/bd.sh"* ]] ||
			fail "$rc does not source shell/bd.sh, so the wrapper never loads"
	done
}

@test "defining the wrapper does not itself invoke fnox" {
	render_wrappers
	set_wrapper_shells

	# The whole reason this is a function and not an exported variable: sourcing
	# it must stay free of 1Password, or it becomes the startup cost that
	# test/shell-startup-secrets.bats exists to prevent.
	local shell
	for shell in "${WRAPPER_SHELLS[@]}"; do
		: >"$FNOX_LOG"
		run_in "$shell" 'true'

		[ "$status" -eq 0 ] || fail "$shell: sourcing the wrapper failed: status=$status output=$output"
		[ ! -s "$FNOX_LOG" ] ||
			fail "$shell: merely defining the wrapper invoked fnox: $(cat "$FNOX_LOG")"
	done
}
