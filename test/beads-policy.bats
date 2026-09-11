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

render_hook() {
	local repo hook
	repo="$(repo_root)"
	hook="$1"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }
EOF
	chezmoi execute-template \
		--config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$repo/home/dot_config/git/template/hooks/executable_${hook}.tmpl"
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
