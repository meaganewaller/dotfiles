# Beads Durability Policy Implementation Plan

> **Status (2026-09-14):** executed 2026-09-11 to 2026-09-14 via subagent-driven development, and superseded by [`docs/beads.md`](../../beads.md), which holds the authoritative procedures. Several snippets below were corrected during execution (see the SDD ledger's rulings) and are **not safe to re-run as written**.
>
> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make beads usage consistent across projects — durable under my own org directories, local-only and never committed everywhere else — and enforce it with git hooks that actually run.

**Architecture:** A new `home/.chezmoidata/beads.yaml` declares which org directories are mine. A chezmoi-managed git template directory seeds five bd hook shims into every new clone via `init.templateDir`, replacing a per-repository install step that has already been forgotten once. Policy text lives in `docs/beads.md`, with a short binding rule in the global agent instructions so it loads in every repository.

**Tech Stack:** chezmoi (Go text/template), BATS (`./bin/test`), `bd` (Beads, Dolt backend), `hk` (git hook runner), `yq`.

**Spec:** `docs/superpowers/specs/2026-09-04-beads-policy-design.md`

## Global Constraints

- **American English** in all commits, docs, comments, and identifiers.
- **Never edit managed paths in `~` directly.** Edit under `home/`, then `chezmoi diff` → `chezmoi apply`. See `docs/agents/chezmoi.md`.
- **This repository is public.** No client email addresses, no engagement-scoped key material, no client-identifying content.
- **`core.hooksPath` must remain unset.** If set, git ignores `.git/hooks/` and `init.templateDir` becomes inert. The two mechanisms are mutually exclusive.
- **`dirs` entries carry no trailing slash.** Consumers append it. This matches the convention `home/.chezmoidata/git.yaml` documents.
- **Directory matching is case-insensitive.** The checkout is `~/src/github.com/Gifthealth`; config says `gifthealth`. Use `gitdir/i:` where a git pattern is rendered.
- **Beads integration version is pinned at `v1.2.2`.** The shims mirror `bd hooks install` output; resync when bd bumps it.
- Every commit routes through the `/git-workflow:commit` skill.
- Run `./bin/test` before each commit; the suite is currently 220 passing.

---

### Task 1: Scope data and the disjointness guard

Declares which org directories are mine, and guards it against the failure ADR 0013 warns about — one identity's directory appearing in two lists that then drift.

**Files:**
- Create: `home/.chezmoidata/beads.yaml`
- Create: `test/beads-policy.bats`

**Interfaces:**
- Consumes: `home/.chezmoidata/git.yaml` → `git.identities[].dirs` (existing, read-only).
- Produces: `beads.personal_dirs` — a list of `~`-prefixed org directory strings, no trailing slash. Task 4 and Task 5 cite it; nothing renders from it yet.

- [ ] **Step 1: Write the failing test**

Create `test/beads-policy.bats`:

```bash
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

@test "personal_dirs and git.identities dirs are disjoint" {
	local repo
	repo="$(repo_root)"

	# Fold case: the checkout is ~/src/github.com/Gifthealth, config says
	# gifthealth. A case-sensitive comparison would miss the collision.
	local personal identity
	personal="$(yq -r '.beads.personal_dirs[]' "$repo/home/.chezmoidata/beads.yaml" | tr '[:upper:]' '[:lower:]' | sort)"
	identity="$(yq -r '.git.identities[].dirs[]' "$repo/home/.chezmoidata/git.yaml" | tr '[:upper:]' '[:lower:]' | sort)"

	local overlap
	overlap="$(comm -12 <(echo "$personal") <(echo "$identity"))"
	[[ -z "$overlap" ]] || fail "org dir in both personal_dirs and git.identities: $overlap"
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `./bin/test test/beads-policy.bats`
Expected: FAIL — `home/.chezmoidata/beads.yaml` does not exist.

- [ ] **Step 3: Create the data file**

Create `home/.chezmoidata/beads.yaml`:

```yaml
# Beads (bd) scope.
#
# Which org directories are mine. Beads runs in *durable* mode under these --
# the lean .beads/ set is committed and dolt data is pushed -- and in
# *local-only* mode everywhere else, where .beads/ goes into .git/info/exclude
# and sync.remote is left unset so nothing is ever written to a remote that
# is not mine.
#
# This is deliberately NOT derived from git.identities. That list enumerates
# only *non-personal* orgs (personal is its unnamed fallback), so inverting it
# would misclassify a cloned open-source repo as mine. The two lists are kept
# apart and asserted disjoint by test/beads-policy.bats.
#
# Entries carry NO trailing slash; consumers append one where a gitdir pattern
# needs it. Matching is case-insensitive -- the checkout on disk may differ in
# case from the org name here.
#
# Full policy: docs/beads.md
beads:
  personal_dirs:
    - "~/src/github.com/meaganewaller"
    - "~/src/github.com/onlooker-community"
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `./bin/test test/beads-policy.bats`
Expected: PASS, 4 tests.

- [ ] **Step 5: Verify `onlooker-community` is still a personal org**

Ask the user directly — it is not on this machine, and it is in the list on the strength of ADR 0013's description of the personal laptop. If it is not personal, remove the entry and re-run the test.

- [ ] **Step 6: Run the full suite**

Run: `./bin/test`
Expected: 224 passing (220 existing + 4 new).

- [ ] **Step 7: Commit**

Use `/git-workflow:commit` with `home/.chezmoidata/beads.yaml test/beads-policy.bats`.

---

### Task 2: Git hook shims

One shared template rendered into five hook files, following the same
`.chezmoitemplates` + thin-wrapper pattern this repository already uses for
`agents/tdd-guardian.md`.

**Why write our own rather than copy bd's:** bd's installed shims for
`pre-commit` and `pre-push` start with
`test "${HK:-1}" = "0" || exec mise x -- hk run <hook> --from-hook "$@"`. `exec`
replaces the shell process, so the beads block below it never executes when hk
is enabled. Those two hooks are the ones that matter most. This shim chains
instead, and guards hk on `hk.pkl` existing so the same file is safe in
repositories that do not use hk.

**Files:**
- Create: `home/.chezmoitemplates/git-hooks/beads-shim`
- Create: `home/dot_config/git/template/hooks/executable_pre-commit.tmpl`
- Create: `home/dot_config/git/template/hooks/executable_pre-push.tmpl`
- Create: `home/dot_config/git/template/hooks/executable_post-merge.tmpl`
- Create: `home/dot_config/git/template/hooks/executable_post-checkout.tmpl`
- Create: `home/dot_config/git/template/hooks/executable_prepare-commit-msg.tmpl`
- Modify: `test/beads-policy.bats`

**Interfaces:**
- Consumes: nothing from Task 1.
- Produces: `~/.config/git/template/hooks/<hook>` — five executable POSIX shell scripts. Task 3 points `init.templateDir` at `~/.config/git/template`.

Note: `commit-msg` is hk-only and has no beads counterpart, so it is out of
scope here. Repositories that need it still get it from `hk install`.

- [ ] **Step 1: Write the failing test**

Append to `test/beads-policy.bats`:

```bash
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
	local hook out
	for hook in $BEADS_HOOKS; do
		out="$(render_hook "$hook")"
		[[ "$out" != *"exec mise"* ]] || fail "$hook: execs hk; beads block below it is dead code"
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
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `./bin/test test/beads-policy.bats`
Expected: FAIL — the template files do not exist.

- [ ] **Step 3: Create the shared shim template**

Create `home/.chezmoitemplates/git-hooks/beads-shim`. Call it with a `hook`
key, e.g. `{{ template "git-hooks/beads-shim" (dict "hook" "pre-push") }}`.

```sh
#!/usr/bin/env sh
# Managed by chezmoi: home/.chezmoitemplates/git-hooks/beads-shim
# Seeded into new clones by init.templateDir (see dot_config/git/config.tmpl).
# Retrofit an existing clone with: git init .
#
# hk is chained, NOT exec'd. bd's own installed shims use
# `exec mise x -- hk run ...`, which replaces the shell process and makes the
# beads block below unreachable -- so on pre-commit and pre-push, the two hooks
# that matter most, beads silently never ran.
if [ "${HK:-1}" != "0" ] && [ -f hk.pkl ] && command -v mise >/dev/null 2>&1; then
	mise x -- hk run {{ .hook }} --from-hook "$@" || exit $?
fi

# --- BEGIN BEADS INTEGRATION v1.2.2 ---
# Mirrors `bd hooks install` output. Resync when bd bumps this version; see
# docs/beads.md. Do not remove these markers.
if command -v bd >/dev/null 2>&1; then
	export BD_GIT_HOOK=1
	_bd_timeout=${BEADS_HOOK_TIMEOUT:-300}
	_bd_used_perl=0
	if command -v timeout >/dev/null 2>&1; then
		timeout "$_bd_timeout" bd hooks run {{ .hook }} "$@"
		_bd_exit=$?
	elif command -v gtimeout >/dev/null 2>&1; then
		gtimeout "$_bd_timeout" bd hooks run {{ .hook }} "$@"
		_bd_exit=$?
	elif command -v perl >/dev/null 2>&1; then
		_bd_used_perl=1
		perl -e 'alarm shift; exec @ARGV' "$_bd_timeout" bd hooks run {{ .hook }} "$@"
		_bd_exit=$?
	else
		echo >&2 "beads: hook '{{ .hook }}' running without timeout; install coreutils or perl to enable BEADS_HOOK_TIMEOUT"
		bd hooks run {{ .hook }} "$@"
		_bd_exit=$?
	fi
	if [ $_bd_exit -eq 124 ] || { [ $_bd_used_perl -eq 1 ] && [ $_bd_exit -eq 142 ]; }; then
		echo >&2 "beads: hook '{{ .hook }}' timed out after ${_bd_timeout}s — continuing without beads"
		_bd_exit=0
	fi
	if [ $_bd_exit -eq 3 ]; then
		# No database in this repo. Not an error -- most repos have none.
		_bd_exit=0
	fi
	if [ $_bd_exit -ne 0 ]; then exit $_bd_exit; fi
fi
# --- END BEADS INTEGRATION v1.2.2 ---
```

- [ ] **Step 4: Create the five thin wrappers**

Each is a single line. `home/dot_config/git/template/hooks/executable_pre-commit.tmpl`:

```
{{ template "git-hooks/beads-shim" (dict "hook" "pre-commit") }}
```

`executable_pre-push.tmpl`:

```
{{ template "git-hooks/beads-shim" (dict "hook" "pre-push") }}
```

`executable_post-merge.tmpl`:

```
{{ template "git-hooks/beads-shim" (dict "hook" "post-merge") }}
```

`executable_post-checkout.tmpl`:

```
{{ template "git-hooks/beads-shim" (dict "hook" "post-checkout") }}
```

`executable_prepare-commit-msg.tmpl`:

```
{{ template "git-hooks/beads-shim" (dict "hook" "prepare-commit-msg") }}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `./bin/test test/beads-policy.bats`
Expected: PASS, 10 tests.

- [ ] **Step 6: Verify the rendered files land executable**

Run: `chezmoi diff ~/.config/git/template/`
Expected: five new files, mode `100755`. The `executable_` prefix is what sets
the bit; if any renders `100644`, the prefix is missing from that filename.

- [ ] **Step 7: Apply and smoke-test in a throwaway repo**

```bash
chezmoi apply ~/.config/git/template
tmp=$(mktemp -d) && cd "$tmp" && git init -q .
git -c init.templateDir="$HOME/.config/git/template" init -q .
ls .git/hooks/ | grep -v sample
git commit -q --allow-empty -m "smoke test"   # must succeed with no beads db
cd - && rm -rf "$tmp"
```

Expected: five hooks listed; the commit succeeds silently. A repository with no
beads database must not be blocked — that is the `-eq 3` path.

- [ ] **Step 8: Commit**

Use `/git-workflow:commit` with the template, the five wrappers, and the test.

---

### Task 3: Wire `init.templateDir`

**Files:**
- Modify: `home/dot_config/git/config.tmpl`
- Modify: `test/beads-policy.bats`

**Interfaces:**
- Consumes: `~/.config/git/template/hooks/*` from Task 2.
- Produces: `init.templateDir = ~/.config/git/template` in the rendered git config.

- [ ] **Step 1: Write the failing test**

Append to `test/beads-policy.bats`:

```bash
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
		--file "$repo/home/dot_config/git/config.tmpl"
}

@test "git config sets init.templateDir" {
	local out
	out="$(render_git_config)"
	[[ "$out" == *"templateDir"* ]] || fail "init.templateDir is not set; new clones get no hooks"
}

@test "git config never sets core.hooksPath" {
	# core.hooksPath and init.templateDir are mutually exclusive: if hooksPath
	# is set, git ignores .git/hooks entirely and the template dir is inert.
	# That exact misconfiguration is why the existing beads hooks never ran.
	local out
	out="$(render_git_config)"
	[[ "$out" != *"hooksPath"* ]] || fail "core.hooksPath is set; it makes init.templateDir inert"
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `./bin/test test/beads-policy.bats`
Expected: the `init.templateDir` test FAILS; the `core.hooksPath` test passes already.

- [ ] **Step 3: Add the setting**

In `home/dot_config/git/config.tmpl`, add to the existing `[init]` section, or
create one if absent:

```
[init]
	# Seed .git/hooks/ on clone and init from a chezmoi-managed template, so a
	# new repo gets working beads + hk hooks with no per-repo install step.
	#
	# Deliberately NOT core.hooksPath: setting that makes git ignore
	# .git/hooks entirely. `bd hooks install --beads` writes into
	# .beads/hooks/ and expects hooksPath to point there -- it never did in
	# either repo, so those shims sat unread. See docs/beads.md.
	#
	# Retrofit an existing clone by re-running `git init .` -- it copies
	# template hooks that are absent and never overwrites one that exists.
	templateDir = ~/.config/git/template
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `./bin/test test/beads-policy.bats`
Expected: PASS, 12 tests.

- [ ] **Step 5: Apply and confirm git agrees**

```bash
chezmoi apply ~/.config/git/config
git config --global --get init.templateDir
git config --global --get core.hooksPath || echo "hooksPath unset (correct)"
```

Expected: the template path, then `hooksPath unset (correct)`.

- [ ] **Step 6: Run the full suite and commit**

Run: `./bin/test`, then `/git-workflow:commit`.

---

### Task 4: `docs/beads.md`

**Files:**
- Create: `docs/beads.md`
- Modify: `CLAUDE.md` / `AGENTS.md` — add `docs/beads.md` to the "Where to read next" table

**Interfaces:**
- Consumes: `beads.personal_dirs` (Task 1), the retrofit command (Task 3).
- Produces: the canonical policy text Task 5 links to.

- [ ] **Step 1: Write the doc**

Create `docs/beads.md` covering, in this order:

1. **The two modes**, keyed on `home/.chezmoidata/beads.yaml`'s `personal_dirs`.
2. **Durable mode adoption checklist**, as a copy-pasteable block:

```bash
bd init
bd config set sync.remote "git+ssh://git@github.com/<org>/<repo>.git"
bd config set export.auto true
chmod 700 .beads
git init .                      # seeds hooks from init.templateDir
bd hooks list                   # expect five installed
```

3. **Local-only mode adoption**, for any repository that is not mine:

```bash
bd init
printf '.beads/\n' >> .git/info/exclude   # per-clone, never committed
# Leave sync.remote UNSET -- bd dolt push must have no target.
bd config get sync.remote && echo "CLEAR THIS" || echo "correct: unset"
```

4. **What is committed**, reproducing the spec's two tables.
5. **Retrofit**: `git init .`, plus the caveat that it never overwrites an
   existing hook, so a stale shim must be deleted first:

```bash
rm -f .git/hooks/{pre-commit,post-merge,pre-push,post-checkout,prepare-commit-msg}
git init .
```

6. **Shim resync**, pinned at beads integration `v1.2.2`. The signal to resync
   is that version changing in `bd hooks install` output; the procedure is to
   re-render `home/.chezmoitemplates/git-hooks/beads-shim` from bd's new block.
7. **Why**, carrying the rationale from the spec: `marketplace` lost 9 issues
   because `bd hooks install --beads` wrote shims to a path `core.hooksPath`
   never pointed at, `export.auto` was never set, and nobody pushed dolt data by
   hand. Note that the JSONL export is not a backup — `bd` says so — and that
   durability is `bd dolt push`.

- [ ] **Step 2: Add it to the entry map**

In the "Where to read next" table in `AGENTS.md` (`CLAUDE.md` symlinks to it):

```markdown
| Beads: what to commit, which repos | [docs/beads.md](docs/beads.md) |
```

- [ ] **Step 3: Verify links resolve**

Run: `hk check --from-ref origin/main --to-ref HEAD`
Expected: `markdown-lint` passes.

- [ ] **Step 4: Commit**

Use `/git-workflow:commit`.

---

### Task 5: Global rule in the agent instructions

**Files:**
- Modify: `home/.chezmoitemplates/agent-instructions-personal.md`

**Interfaces:**
- Consumes: `docs/beads.md` (Task 4).
- Produces: a `## Beads` section in every account's rendered `CLAUDE.md`.

- [ ] **Step 1: Add the section**

Append to `home/.chezmoitemplates/agent-instructions-personal.md`, after
`## Commits`:

```markdown
## Beads

Beads is durable only in **my own repositories** — those under
`~/src/github.com/meaganewaller` or `~/src/github.com/onlooker-community`
(`home/.chezmoidata/beads.yaml` is the list). There, commit `.beads/`'s
`issues.jsonl`, `config.yaml`, `metadata.json`, `.gitignore`, and `README.md`;
never `interactions.jsonl` or `hooks/`.

In any repository that is **not mine** — client work, or anything cloned to
contribute to — beads is local-only: add `.beads/` to `.git/info/exclude` and
leave `sync.remote` unset. Never commit beads artifacts to someone else's
repository, and never push `refs/dolt/data` to a remote that is not mine.

Durability comes from `bd dolt push`, not from the JSONL export — bd is explicit
that the export is not a backup. Full policy: `docs/beads.md` in the dotfiles
repo.
```

- [ ] **Step 2: Verify it renders**

Run: `chezmoi diff ~/.claude-personal/CLAUDE.md`
Expected: the new `## Beads` section, and nothing else changed.

- [ ] **Step 3: Apply and commit**

Run `chezmoi apply ~/.claude-personal/CLAUDE.md`, then `/git-workflow:commit`.

---

### Task 6: Remediate `dotfiles`

Brings this repository into compliance. No source-tree changes — this is
repository state.

**Files:**
- Modify: `.gitignore` (repository root)
- Untrack: `.beads/interactions.jsonl`, `.beads/hooks/`

- [ ] **Step 1: Fix permissions**

Run: `chmod 700 .beads`
Verify: `bd stats` no longer prints the `0755` warning.

- [ ] **Step 2: Add the ignore lines**

Under the existing `# Beads / Dolt files (added by bd init)` section in
`.gitignore`:

```gitignore
# Derived from the database and conflict-prone; see docs/beads.md.
.beads/interactions.jsonl
# Generated per-project; hooks come from init.templateDir instead.
.beads/hooks/
```

- [ ] **Step 3: Untrack the two paths**

```bash
git rm --cached .beads/interactions.jsonl
git rm -r --cached .beads/hooks/
git status --short   # expect D for both, and no other surprises
```

- [ ] **Step 4: Wire the hooks**

```bash
git init .
bd hooks list
```

Expected: five hooks reported installed. Before this task they all report "not
installed" despite `.beads/hooks/` being populated.

- [ ] **Step 5: Verify the export is current**

```bash
bd stats                       # note the issue count
wc -l .beads/issues.jsonl      # must match
```

If they disagree, run a `bd` write command to trigger the throttled auto-export,
then re-check.

- [ ] **Step 6: Verify dolt data is on the remote**

```bash
git ls-remote origin 'refs/dolt/*'
```

Expected: a `refs/dolt/data` line. If absent, run `bd dolt push`.

- [ ] **Step 7: Run the full suite and commit**

Run: `./bin/test`, then `/git-workflow:commit`.

---

### Task 7: Remediate `marketplace`

Runs in `~/src/github.com/meaganewaller/marketplace`, a different repository.
Do not mix its commits with this one's.

**Preconditions:** Tasks 1–5 are merged, so `init.templateDir` is live.

- [ ] **Step 1: Confirm the loss before changing anything**

```bash
cd ~/src/github.com/meaganewaller/marketplace
bd stats                                  # expect "no beads database found"
git ls-remote origin 'refs/dolt/*'        # expect no output
grep -c . .beads/interactions.jsonl       # expect 3453
```

The 9 issues referenced by that log are unrecoverable. Nothing in this task
retrieves them; record that plainly in the commit body rather than implying a
repair.

- [ ] **Step 2: Fix permissions**

Run: `chmod 700 .beads`

- [ ] **Step 3: Untrack the orphaned artifacts**

```bash
git rm --cached .beads/interactions.jsonl
git rm -r --cached .beads/hooks/          # 18 husky-mirrored hooks
```

Add the same two ignore lines from Task 6 Step 2 to this repository's
`.gitignore`.

- [ ] **Step 4: Initialize a working database**

```bash
bd init
bd config set export.auto true
bd config get sync.remote     # already correct; confirm, do not overwrite
```

`export.auto` being absent is the specific reason no export was ever written
here.

- [ ] **Step 5: Wire the hooks**

```bash
git init .
bd hooks list                 # expect five installed
```

- [ ] **Step 6: Verify durability end to end**

```bash
bd create --title="Verify beads durability" --description="Smoke test for the durability policy." --type=task --priority=3
bd dolt push
git ls-remote origin 'refs/dolt/*'    # expect refs/dolt/data
wc -l .beads/issues.jsonl             # expect the export to exist now
```

- [ ] **Step 7: Commit**

Use `/git-workflow:commit`. Say in the body that the 9 prior issues were lost
and are not recovered.

---

## Self-Review

**Spec coverage:**

| Spec section | Task |
| --- | --- |
| Scope / `personal_dirs` | 1 |
| Matching rules (case, no trailing slash) | 1 (tests) |
| Why a separate file | 1 (comment + disjointness test) |
| Tracked set | 4 (doc), 6 and 7 (enforced by untracking) |
| Template directory | 2 |
| `core.hooksPath` stays unset | 3 (test) |
| Retrofit | 3 (comment), 4 (doc) |
| Version drift / resync | 2 (comment), 4 (doc) |
| Remediation: `dotfiles` | 6 |
| Remediation: `marketplace` | 7 |
| Guards 1–4 | 1 (1, 2), 3 (3), 2 (4) |
| Local-only mode mechanics | 4 (doc), 5 (rule) |
| Open question: `onlooker-community` | 1 Step 5 |

**Gap found and closed:** the spec's guard 4 requires the shims be executable.
Task 2 Step 6 checks the rendered mode via `chezmoi diff` rather than a BATS
assertion, because the `executable_` bit is a chezmoi attribute rather than
something `execute-template` output can show.

**Type consistency:** `beads.personal_dirs` is used with that exact path in
Tasks 1, 4, and 5. The five hook names are spelled identically in Tasks 2, 3,
4, 6, and 7. The template key is `dict "hook"` in both the shim body and all
five wrappers.

**Known ordering constraint:** Task 7 depends on Tasks 1–5 being applied, since
it relies on `init.templateDir` existing. Tasks 6 and 7 are otherwise
independent of each other.
