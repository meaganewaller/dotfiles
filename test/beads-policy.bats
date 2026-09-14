#!/usr/bin/env bats

load test_helper

# Beads durability policy.
#
# .chezmoidata/beads.yaml declares which org directories are mine. Beads runs
# in durable mode there (committed lean set, dolt push) and local-only mode
# everywhere else (.git/info/exclude, no sync.remote).
#
# personal_dirs and git.identities[].dirs must stay disjoint: a client org
# classified as personal would commit client issue data to a public history.
# ADR 0013's lesson -- two lists describing one identity will drift -- applies,
# so this asserts they cannot overlap instead of merging them.

repo_root() {
	cd "${BATS_TEST_DIRNAME}/.." && pwd
}

@test "beads.yaml is valid YAML" {
	assert_valid_yaml "$(repo_root)/home/.chezmoidata/beads.yaml"
}

@test "personal_dirs is non-empty" {
	local repo count
	repo="$(repo_root)"
	count="$(yq '.beads.personal_dirs | length' "$repo/home/.chezmoidata/beads.yaml")"
	[[ "$count" -gt 0 ]] || fail "beads.personal_dirs is empty"
}

@test "personal_dirs entries carry no trailing slash" {
	local repo
	repo="$(repo_root)"
	while read -r dir; do
		[[ "$dir" != */ ]] || fail "trailing slash on personal_dirs entry: $dir"
	done < <(yq -r '.beads.personal_dirs[]' "$repo/home/.chezmoidata/beads.yaml")
}

@test "no personal_dirs entry equals, contains, or is contained by a client identity dir" {
	local repo
	repo="$(repo_root)"

	# Fold case: the checkout is ~/src/github.com/Gifthealth, config says
	# gifthealth. A case-sensitive comparison would miss the collision.
	#
	# Exact-string disjointness is not enough: a parent directory such as
	# ~/src/github.com would pass an exact-match check while silently
	# swallowing every client repo underneath it into "personal". Containment
	# is checked on a "/" boundary so ~/src/github.com/gift does not "contain"
	# ~/src/github.com/gifthealth.
	local personal identity p i bad
	personal="$(yq -r '.beads.personal_dirs[]' "$repo/home/.chezmoidata/beads.yaml" | tr '[:upper:]' '[:lower:]')"
	identity="$(yq -r '.git.identities[].dirs[]' "$repo/home/.chezmoidata/git.yaml" | tr '[:upper:]' '[:lower:]')"

	bad=""
	while IFS= read -r p; do
		[ -n "$p" ] || continue
		while IFS= read -r i; do
			[ -n "$i" ] || continue
			if [[ "$p" == "$i" || "$i" == "$p"/* || "$p" == "$i"/* ]]; then
				bad+="$p <-> $i"$'\n'
			fi
		done <<<"$identity"
	done <<<"$personal"

	[ -z "$bad" ] || fail "personal_dirs overlaps a client identity dir: $bad"
}

# Git hook shims.
#
# Seeded via init.templateDir (Task 3) so every new clone gets them. bd's own
# installed shims start with `exec mise x -- hk run <hook> --from-hook "$@"`,
# and exec replaces the shell process -- the beads block below it never runs
# when hk is enabled. These shims chain hk instead, guarded on hk.pkl existing
# so the same file is safe in repositories that do not use hk.

BEADS_HOOKS="pre-commit pre-push post-merge post-checkout prepare-commit-msg"

# Render a source template, given relative to the repository root, with this
# repository's data and a throwaway home directory.
render_template() {
	local repo
	repo="$(repo_root)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }
EOF
	chezmoi execute-template \
		--config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/$1"
}

render_hook() {
	render_template "home/dot_config/git/template/hooks/executable_$1.tmpl"
}

@test "every beads hook shim exists and renders valid shell" {
	local hook out
	for hook in $BEADS_HOOKS; do
		out="$(render_hook "$hook")" || fail "render failed: $hook"
		assert_valid_shell "$out"
	done
}

@test "each shim invokes bd for its own hook name" {
	local hook out
	for hook in $BEADS_HOOKS; do
		out="$(render_hook "$hook")"
		[[ "$out" == *"bd hooks run $hook"* ]] || fail "$hook: does not call 'bd hooks run $hook'"
	done
}

@test "shims never exec hk, which would make the beads block unreachable" {
	# The mandated shim comment explains this failure mode using the literal
	# text "exec mise x -- hk run ..." -- strip comment lines before matching
	# so that explanatory prose cannot make this assertion pass or fail on its
	# own account.
	local hook out code
	for hook in $BEADS_HOOKS; do
		out="$(render_hook "$hook")"
		code="$(printf '%s\n' "$out" | grep -v '^[[:space:]]*#')"
		[[ "$code" != *"exec mise"* && "$code" != *"exec hk"* ]] ||
			fail "$hook: execs hk; beads block below it is dead code"
	done
}

@test "shims guard hk on hk.pkl so they are safe in non-hk repos" {
	local out
	out="$(render_hook pre-commit)"
	[[ "$out" == *"hk.pkl"* ]] || fail "pre-commit: hk invocation is not guarded on hk.pkl"
}

@test "shims carry the pinned beads integration markers" {
	local hook out
	for hook in $BEADS_HOOKS; do
		out="$(render_hook "$hook")"
		[[ "$out" == *"BEGIN BEADS INTEGRATION v1.2.2"* ]] || fail "$hook: missing begin marker"
		[[ "$out" == *"END BEADS INTEGRATION v1.2.2"* ]] || fail "$hook: missing end marker"
	done
}

@test "shims treat an uninitialized database as success" {
	# bd exits 3 when there is no database. Without this the shim would block
	# every commit in every repo that has no beads workspace.
	local out
	out="$(render_hook pre-commit)"
	[[ "$out" == *"-eq 3"* ]] || fail "pre-commit: does not handle bd exit 3"
}

# Behavioral shim tests.
#
# The incident behind this policy was hooks that silently never ran bd, which
# no text match on a rendered hook can catch. These run a rendered hook the way
# git does -- from the top of the work tree, or from the git dir of a bare
# repository -- with stub bd and mise first on PATH. Each stub appends its argv
# to $STUB_LOG, one "[arg]" per argument, so quoting survives into the log.

HK_CALL="mise [x] [--] [hk] [run] [pre-commit] [--from-hook]"

setup_stubs() {
	STUB_BIN="$TEST_TMPDIR/bin"
	STUB_LOG="$TEST_TMPDIR/stub.log"
	# Physical path: git reports the toplevel with symlinks resolved, and
	# macOS's TMPDIR sits behind the /var -> /private/var link.
	STUB_HOME="$(cd "$TEST_TMPDIR" && pwd -P)/stub-home"
	mkdir -p "$STUB_BIN" "$STUB_HOME"
	: >"$STUB_LOG"
	# bd exits 3 unless a test says otherwise: no database, which is what most
	# repositories answer.
	cat >"$STUB_BIN/bd" <<'EOF'
#!/bin/sh
{ printf 'bd'; printf ' [%s]' "$@"; echo; } >>"$STUB_LOG"
exit "${BD_STUB_EXIT:-3}"
EOF
	cat >"$STUB_BIN/mise" <<'EOF'
#!/bin/sh
{ printf 'mise'; printf ' [%s]' "$@"; echo; } >>"$STUB_LOG"
EOF
	chmod +x "$STUB_BIN/bd" "$STUB_BIN/mise"
}

# Run the rendered <hook> from <dir> with the stubs first on PATH and HOME at
# the stub home. Remaining arguments go to the hook.
run_hook() {
	local hook="$1" dir="$2"
	shift 2
	mkdir -p "$TEST_TMPDIR/hooks"
	render_hook "$hook" >"$TEST_TMPDIR/hooks/$hook" || fail "render failed: $hook"
	chmod +x "$TEST_TMPDIR/hooks/$hook"
	cd "$dir" || fail "cannot enter $dir"
	run env -u GIT_DIR -u GIT_WORK_TREE HOME="$STUB_HOME" PATH="$STUB_BIN:$PATH" \
		STUB_LOG="$STUB_LOG" BD_STUB_EXIT="${BD_STUB_EXIT:-3}" \
		"$TEST_TMPDIR/hooks/$hook" "$@"
}

# A repository at <dir>, created with no template so this machine's own hooks
# stay out of it.
make_repo() {
	git init -q --template= "$1" || fail "git init failed: $1"
}

# The same, holding an hk.pkl, so whether hk chains is down to the personal-dir
# scope alone.
make_hk_repo() {
	make_repo "$1"
	: >"$1/hk.pkl"
}

# Each personal_dirs entry, or only the one at index <n>, with ~ expanded
# against the stub home.
personal_dirs() {
	local dir
	while read -r dir; do
		printf '%s\n' "$STUB_HOME/${dir#\~/}"
	done < <(yq -r ".beads.personal_dirs[${1-}]" "$(repo_root)/home/.chezmoidata/beads.yaml")
}

@test "a shim treats bd's exit 3 as success, silently" {
	setup_stubs
	make_repo "$STUB_HOME/repo"
	run_hook pre-commit "$STUB_HOME/repo"
	[ "$status" -eq 0 ] || fail "exit $status, want 0"
	[ -z "$output" ] || fail "printed: $output"
	grep -q '^bd ' "$STUB_LOG" || fail "bd never ran, so exit 3 was not exercised"
}

@test "a shim fails when bd fails" {
	setup_stubs
	make_repo "$STUB_HOME/repo"
	BD_STUB_EXIT=1
	run_hook pre-commit "$STUB_HOME/repo"
	[ "$status" -eq 1 ] || fail "exit $status, want bd's 1"
}

@test "each shim hands bd its own hook name and arguments" {
	local hook
	setup_stubs
	make_repo "$STUB_HOME/repo"
	for hook in $BEADS_HOOKS; do
		: >"$STUB_LOG"
		run_hook "$hook" "$STUB_HOME/repo" one "two words"
		[ "$status" -eq 0 ] || fail "$hook: exit $status"
		grep -qxF "bd [hooks] [run] [$hook] [one] [two words]" "$STUB_LOG" ||
			fail "$hook: bd got: $(cat "$STUB_LOG")"
	done
}

@test "a shim never runs mise without an hk.pkl, even in a personal repo" {
	local dir
	setup_stubs
	dir="$(personal_dirs 0)/repo"
	make_repo "$dir"
	run_hook pre-commit "$dir"
	[ "$status" -eq 0 ] || fail "exit $status"
	if grep -q '^mise ' "$STUB_LOG"; then
		fail "mise ran without an hk.pkl: $(cat "$STUB_LOG")"
	fi
}

@test "shims run neither bd nor hk in a bare repository, such as Dolt's cache" {
	# Dolt's git-remote-cache is a bare repository that git seeds from this
	# template, and git runs a bare repository's hooks from its git dir: bd
	# there would re-enter the database in the middle of `bd dolt push`. A
	# personal dir and an hk.pkl make everything else line up, so only the
	# bare-repository exit can keep both stubs out of the log.
	local hook dir
	setup_stubs
	dir="$(personal_dirs 0)/cache.git"
	git init -q --bare --template= "$dir" || fail "git init --bare failed"
	: >"$dir/hk.pkl"
	for hook in $BEADS_HOOKS; do
		run_hook "$hook" "$dir"
		[ "$status" -eq 0 ] || fail "$hook: exit $status in a bare repository"
	done
	[ ! -s "$STUB_LOG" ] || fail "a hook ran in a bare repository: $(cat "$STUB_LOG")"
}

# hk scope.
#
# hk evaluates the repository's own hk.pkl. Git never runs a clone's code on
# its own, and neither may a hook this policy seeds into every clone on the
# machine, post-checkout included: hk chains only under beads.personal_dirs.

@test "hk chains in a repository under each personal dir" {
	local dir
	setup_stubs
	while read -r dir; do
		make_hk_repo "$dir/repo"
		: >"$STUB_LOG"
		run_hook pre-commit "$dir/repo"
		[ "$status" -eq 0 ] || fail "exit $status in $dir/repo"
		grep -qxF "$HK_CALL" "$STUB_LOG" || fail "hk did not chain in $dir/repo: $(cat "$STUB_LOG")"
	done < <(personal_dirs)
}

@test "hk never chains in a foreign repository, even with an hk.pkl" {
	local hook dir
	setup_stubs
	dir="$STUB_HOME/src/github.com/someone-else/repo"
	make_hk_repo "$dir"
	for hook in $BEADS_HOOKS; do
		run_hook "$hook" "$dir"
		[ "$status" -eq 0 ] || fail "$hook: exit $status"
	done
	if grep -q '^mise ' "$STUB_LOG"; then
		fail "hk chained in a foreign repository: $(cat "$STUB_LOG")"
	fi
}

@test "personal-dir matching ignores case" {
	# The checkout on disk can differ in case from the org name in beads.yaml.
	local dir
	setup_stubs
	dir="$(personal_dirs 0)"
	dir="$STUB_HOME/$(printf '%s' "${dir#"$STUB_HOME"/}" | tr '[:lower:]' '[:upper:]')/repo"
	make_hk_repo "$dir"
	run_hook pre-commit "$dir"
	[ "$status" -eq 0 ] || fail "exit $status"
	grep -qxF "$HK_CALL" "$STUB_LOG" || fail "hk did not chain in $dir: $(cat "$STUB_LOG")"
}

@test "personal-dir matching stops at a / boundary" {
	# ~/src/github.com/meaganewaller must not claim .../meaganewaller-evil.
	local dir
	setup_stubs
	dir="$(personal_dirs 0)-evil/repo"
	make_hk_repo "$dir"
	run_hook pre-commit "$dir"
	[ "$status" -eq 0 ] || fail "exit $status"
	if grep -q '^mise ' "$STUB_LOG"; then
		fail "hk chained in $dir: $(cat "$STUB_LOG")"
	fi
}

# init.templateDir wiring.
#
# Seeds .git/hooks/ on every future clone/init from the template rendered
# above, so the beads + hk shims are present with no per-repo install step.
# Assert against what git itself parses out of the rendered config rather
# than matching on rendered text: the mandated [init] comment explains the
# core.hooksPath pitfall by name, so a plain string search for "hooksPath"
# would fail against the file's own explanatory prose.

render_git_config() {
	local repo
	repo="$(repo_root)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
EOF
	chezmoi execute-template \
		--config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/home/dot_config/git/config.tmpl" \
		>"$TEST_TMPDIR/config"
}

@test "git config sets init.templateDir" {
	render_git_config
	local out
	out="$(git config --file "$TEST_TMPDIR/config" --get init.templateDir)" ||
		fail "init.templateDir is not set; new clones get no hooks"
	[[ "$out" == "~/.config/git/template" ]] ||
		fail "init.templateDir is '$out', expected '~/.config/git/template'"
}

@test "git config never sets core.hooksPath" {
	# core.hooksPath and init.templateDir are mutually exclusive: if hooksPath
	# is set, git ignores .git/hooks entirely and the template dir is inert.
	# That exact misconfiguration is why the existing beads hooks never ran.
	render_git_config
	if git config --file "$TEST_TMPDIR/config" --get core.hooksPath >/dev/null; then
		fail "core.hooksPath is set; it makes init.templateDir inert"
	fi
}
