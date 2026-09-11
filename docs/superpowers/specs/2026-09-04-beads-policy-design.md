# Beads durability policy

**Date:** 2026-09-04
**Status:** design, pending implementation

How Beads (`bd`) is used across projects: which repositories may have it, what
of `.beads/` is committed, and what keeps the answer from drifting again.

## Context

Beads usage had drifted between the two repositories that have it, and the
drift was not cosmetic — it cost real data.

| | `meaganewaller/dotfiles` | `meaganewaller/marketplace` |
| --- | --- | --- |
| Live database | 52 issues (2 open, 50 closed) | none — `bd stats`: "no beads database found" |
| `refs/dolt/data` on remote | present | absent |
| `sync.remote` configured | yes | **yes** — correctly, at its own remote |
| `export.auto` | `true` | **absent** |
| `.beads/issues.jsonl` tracked | yes, current as of 2026-09-03 | never written, never tracked |
| `.beads/interactions.jsonl` tracked | yes | yes — 3,453 lines, orphaned |
| `.beads/hooks/` tracked | yes, 6 hooks | yes, 18 hooks (mirrors the repo's husky hooks) |

`marketplace` was genuinely used: its committed interactions log records field
changes against **9 distinct issue IDs**, the earliest from 2026-08-08. Those
issues are unrecoverable. There is no database on disk, no `refs/dolt/data` on
the remote, and no JSONL export. What survives is an audit trail of changes to
issues that no longer exist.

`dotfiles` survived because it happened to do the redundant thing — dolt data
on the remote *and* a committed JSONL export.

Note what was **not** the problem: `sync.remote` is configured correctly in both
repositories, each pointing at its own GitHub remote. The configuration was
right; nothing ever acted on it.

The differentiator was `export.auto`. `dotfiles` sets it to `true`, so every
write command refreshed `.beads/issues.jsonl`, which then got committed by hand.
`marketplace` never set it, so no export was ever written, and when the database
went away there was nothing left but the interactions log.

One correction to a tempting reading of that: the JSONL export is **not a
backup**. `bd config --help` is explicit — it is "useful for viewers (bv),
interchange, and issue-level migration; not a backup. It is not cross-machine
sync; use `bd dolt push/pull` with a Dolt remote." So the export is a readable
artifact that makes reconstruction possible, not the durability mechanism.
Durability is `bd dolt push`, and the reason `dotfiles` has `refs/dolt/data` on
its remote while `marketplace` does not is that somebody ran that push by hand
in one repository and not the other.

The policy therefore requires both, for different reasons: the dolt push for
durability, and the committed export for a diffable, human-readable record that
survives in git even if the Dolt remote is unreachable.

### Root cause

The redundancy in `dotfiles` was maintained by hand, not by automation. Two
commits — `3dda3d0` and `d2d3ef9`, both "resync the issue export" — are that
manual compensation. `marketplace` had nobody doing it by hand, so it died.

The automation that should have prevented this exists and is not running.
`bd hooks install --beads` had been run in both repositories: it writes shims
into `.beads/hooks/`, which is why those directories are populated and
committed. That mode only takes effect when `core.hooksPath` points at the
directory, and it never did. In both repositories:

- `core.hooksPath` is unset
- `.git/hooks/` contains nothing but `.sample` files
- `bd hooks list` reports all five hooks "not installed"

The hooks were installed into a location git was never told to read. The same
files also chain `hk`, so `hk` was not running on commit or push either — two
hook systems, both believing they were installed, neither wired up.

Compounding this, there was no cross-project policy anywhere. The
`## Beads Issue Tracker` section lives in this repository's `AGENTS.md`, so it
is scoped to `dotfiles` and is generic `bd` boilerplate rather than a personal
convention. `marketplace` received the same `.agents/skills/beads/SKILL.md` and
no guidance at all about how these repositories are meant to use it.

## Decisions

1. **Durable everywhere.** Beads issues are project memory that must survive a
   fresh clone on another machine. Every durable repository pushes dolt data
   *and* keeps a committed JSONL export as the readable recovery path.
2. **Lean tracked set.** Commit the recoverable state and the shared
   configuration. Do not commit the append-only audit log or generated hooks.
3. **Policy lives where every project sees it.** A short binding rule in the
   global agent instructions, with the detail in `docs/beads.md`.
4. **Enforced by a git template directory,** so a clone gets working hooks with
   no per-repository step, plus a documented retrofit for existing clones.
5. **Personal repositories only.** Beads is adopted only under directories that
   are mine. Elsewhere it is local-only and never committed.

## Scope: which repositories may have beads

New data file `home/.chezmoidata/beads.yaml`:

```yaml
beads:
  # Org directories whose repositories are mine. Beads runs in durable mode
  # here and nowhere else. No trailing slashes; consumers append as needed.
  personal_dirs:
    - "~/src/github.com/meaganewaller"
    - "~/src/github.com/onlooker-community"
```

Two modes follow:

**Durable mode** — the repository is under a `personal_dirs` entry. The full
policy applies: the lean set is committed, dolt data is pushed. Two settings in
`.beads/config.yaml` are required, and their absence is exactly what killed
`marketplace`:

```yaml
sync.remote: "git+ssh://git@github.com/<org>/<repo>.git"   # durability
export:
    auto: true                                             # readable record
```

**Local-only mode** — anywhere else, including client organizations and
open-source repositories cloned to contribute to. Beads may still be used as a
working aid, but:

- `.beads/` is added to `.git/info/exclude`, which is per-clone and never
  committed, so nothing appears in a repository whose owner did not ask for it.
- `sync.remote` is left **unset** and no Dolt remote is configured, so
  `bd dolt push` has no target. Both matter: `bd dolt push` pushes to the Dolt
  remote, not to `sync.remote`. Plain `bd init` derives both from `origin`;
  `bd init --stealth` sets neither. Writing `refs/dolt/data` to a remote that is
  not mine is not mine to do.
- `export.auto` is left off; there is nothing to commit the export to.
- Consequence, accepted deliberately: issues in local-only repositories are not
  durable. They are a scratchpad and will not survive a reclone.

### Matching rules

Two traps documented in ADR 0013 apply directly and must not be repeated.

- **Case-insensitive.** The checkout on disk is `~/src/github.com/Gifthealth`
  while `git.yaml` names `gifthealth`. Comparison must fold case even on a
  case-insensitive APFS volume, exactly as `config.tmpl` uses `gitdir/i:`.
- **Directory prefix, not exact path.** A pattern must match repositories
  *inside* the directory. Where a `gitdir:` pattern is rendered, the trailing
  slash is appended by the template so it cannot be forgotten per entry.

### Why a separate file rather than extending `git.identities`

`git.identities` answers "which email signs commits here." This answers "is
this repository mine." The questions correlate but are not the same, and
`git.identities` deliberately enumerates only non-personal organizations —
personal is its unnamed fallback. Inverting that list would misclassify a
cloned open-source repository as personal, since it appears in neither.

ADR 0013's lesson still applies, so the two lists get a guard rather than a
merge: a test asserts `beads.personal_dirs` and every `git.identities[].dirs`
entry are **disjoint**. A client organization can never be classified personal,
and adding one to both fails the suite.

## Tracked set (durable repositories)

Committed:

| Path | Why |
| --- | --- |
| `.beads/issues.jsonl` | Readable, diffable record of issue state. Not a backup (bd says so explicitly), but the artifact that makes reconstruction possible when the database is gone. |
| `.beads/config.yaml` | Shared project configuration — carries `sync.remote` and `export.auto`. |
| `.beads/metadata.json` | Issue prefix and project identity. |
| `.beads/.gitignore` | bd-managed; required for correct ignore behavior. |
| `.beads/README.md` | Static, generated once. |

Ignored:

| Path | Why |
| --- | --- |
| `.beads/interactions.jsonl` | Append-only audit log, derived from the database, conflicts on every concurrent branch. In `marketplace` it is 3,453 lines describing issues that no longer exist — the less valuable half of the record. |
| `.beads/hooks/` | Generated per project and per toolchain. `marketplace` has 18 because beads mirrored that repository's husky hooks; `dotfiles` has 6. |

Both ignored paths are currently **tracked** in both repositories, so ignore
rules alone will not take effect. Implementation requires `git rm --cached`.

The ignore lines go in the repository-root `.gitignore`, under the existing
`# Beads / Dolt files (added by bd init)` section — **not** in
`.beads/.gitignore`, which is bd-managed and carries an explicit warning
against edits.

## Enforcement

### Template directory

A chezmoi-managed git template directory under `home/dot_config/git/`,
containing the five bd hook shims (`pre-commit`, `post-merge`, `pre-push`,
`post-checkout`, `prepare-commit-msg`), with `init.templateDir` set in
`dot_config/git/config.tmpl`. Every future `git clone` or `git init` gets
working hooks with no per-repository step.

This is compatible with the lean tracked set, and the two reinforce each other.
`bd hooks install --beads` exists to give a team a committed, shared hook
directory; since decision 2 stops tracking `.beads/hooks/`, that mode's
advantage is gone, and hooks in `.git/hooks/` are per-clone anyway — precisely
what a template directory seeds.

`core.hooksPath` must stay **unset**. If it is set, git ignores `.git/hooks/`
entirely and the template directory does nothing. The two mechanisms are
mutually exclusive; this design picks the template directory.

The shims are safe in every repository, including those with no beads at all:
the managed block guards on `command -v bd`, and bd exits 3 — "database not
initialized" — which the shim treats as success. hk chaining stays guarded on
`hk.pkl` being present.

### Retrofit

`init.templateDir` affects only repositories created after it is set. Both
existing repositories, and any other already-cloned repository, need a
retrofit. Re-running `git init` in place is that retrofit:

```sh
git init .    # idempotent; re-seeds .git/hooks/ from init.templateDir
```

Two properties were verified against the installed git before relying on them:

- Re-running `git init` in an existing repository **does** copy template hooks
  that are not already present.
- It **does not** overwrite a hook file that already exists.

The second property is what makes the retrofit safe to run anywhere: a
repository with its own husky or hk hook keeps it untouched.

### Version drift

The shims carry bd's `BEADS INTEGRATION v1.2.2` section markers, which exist so
bd can update its own block while preserving surrounding content. (The pin was
corrected from `v1.1.0`, the label copied from the `.beads/hooks/` shims an
older bd wrote; the installed bd 1.2.2 emits `v1.2.2`.) Copying the shims into
a chezmoi-managed template means they no longer receive those updates
automatically.

The no-clobber property above cuts both ways: because `git init` skips hooks
that already exist, it will **not** propagate an updated shim to a repository
that already has the old one. Resyncing after a bd upgrade therefore requires
removing the stale shims first, and only those: a hook this policy neither
owns nor chains must survive, or the safety property above breaks.

```sh
for h in pre-commit post-merge pre-push post-checkout prepare-commit-msg; do
  grep -qE 'BEADS INTEGRATION|hk run' ".git/hooks/$h" 2>/dev/null && rm -f ".git/hooks/$h"
done
git init .
```

`docs/beads.md` records the pinned version, this procedure, and the signal to
run it — bd's integration version changing in `bd hooks install` output.

## Remediation

### `dotfiles`

1. `chmod 700 .beads` — currently `0755`; bd warns on every invocation.
2. `git rm --cached .beads/interactions.jsonl` and `git rm -r --cached .beads/hooks/`.
3. Add the two ignore lines to the root `.gitignore`.
4. Wire hooks via the retrofit; confirm `bd hooks list` reports five installed.
5. Confirm `.beads/issues.jsonl` is current against the live database.

### `marketplace`

The repository is under `meaganewaller`, so durable mode applies. Its 9 issues
are unrecoverable; nothing in this plan retrieves them.

1. `chmod 700 .beads`.
2. `git rm --cached .beads/interactions.jsonl` and `git rm -r --cached .beads/hooks/` — the orphaned log and the 18 husky-mirrored hooks.
3. `bd init` to create a working database.
4. `bd config set export.auto true` — the setting whose absence meant no export
   was ever written here. `sync.remote` is already correct and needs no change.
5. Wire hooks; confirm `bd hooks list`.
6. Confirm `refs/dolt/data` reaches the remote on first push.

## Artifacts

| Artifact | Purpose |
| --- | --- |
| `home/.chezmoidata/beads.yaml` | `personal_dirs` scope list. |
| `docs/beads.md` | Full policy, retrofit command, shim resync procedure, and the rationale including the `marketplace` loss. |
| `home/.chezmoitemplates/agent-instructions-personal.md` | Short binding rule linking to `docs/beads.md`. Renders into every account's `CLAUDE.md`, so it loads in every repository. |
| `home/dot_config/git/` template dir + `config.tmpl` change | The five shims and `init.templateDir`. |
| `test/beads-policy.bats` | Guards, below. |

## Guards

Following ADR 0013's requirement that a guard fail when the bug returns:

1. `beads.personal_dirs` and `git.identities[].dirs` are disjoint.
2. Every `personal_dirs` entry has no trailing slash, matching the convention
   `git.yaml` already documents.
3. The rendered git config sets `init.templateDir` and does **not** set
   `core.hooksPath` — the specific misconfiguration that made the existing
   hooks inert.
4. The template directory contains all five shims and each is executable.

## Open implementation questions

- ~~Suppressing dolt push in local-only mode.~~ **Resolved.** `bd config` has
  `sync.remote`, stored in `.beads/config.yaml` — in both existing repositories
  it is set to that repository's own GitHub remote. Local-only mode therefore
  means no push target: `sync.remote` **unset** and no Dolt remote, which is
  what `bd init --stealth` produces, so `bd dolt push` cannot write refs to a
  remote that is not mine. (Unsetting `sync.remote` alone is not enough; it
  leaves the Dolt remote that plain `bd init` wires from `origin`.) Combined
  with `.beads/` in `.git/info/exclude`, both the export and push sides are
  covered without a runtime path check in the shim.
- **`onlooker-community` is not on this machine.** It is included in
  `personal_dirs` on the strength of ADR 0013's description of the personal
  laptop. Worth confirming it is still a personal organization before landing.

## Out of scope

- **No ADR.** The docs page carries the rationale. Reconsider if this policy
  turns out to constrain later decisions.
- **No CI check.** The template directory prevents the failure rather than
  reporting it after the fact.
- **No wrapper CLI** around `bd init`. Add one only if the two-mode distinction
  proves error-prone in practice.
- **No change to `git.identities`** or the identity routing it drives.
- **No recovery attempt for the 9 `marketplace` issues.** They are gone.
