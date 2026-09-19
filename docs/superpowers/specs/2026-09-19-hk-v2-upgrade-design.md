# hk v2 upgrade

**Date:** 2026-09-19
**Status:** designed; not yet implemented
**Beads:** [`dotfiles-low`](#pr-1--lockfile-format-upgrade) (PR 1), [`dotfiles-q8j`](#pr-2--hk-v2) (PR 2)

Moving the hk binary to 2.x, reshaping both hk configs for the v2 schema, and
closing the Renovate gap that let one of them drift for three months.

## Context

hk is configured in two places, and they are three minor versions apart.

| | Path | Amends | Managed by Renovate | Scope |
| --- | --- | --- | --- | --- |
| Repo config | `hk.pkl` | **v2.0.1** (since #282) | yes, custom regex manager | this repository |
| Home config | `home/dot_config/hk/config.pkl` → `~/.config/hk/config.pkl` | **v1.36.0** (unchanged since it was added) | **no** | every repository on the machine |
| Binary | `mise.toml` | **1.58.1** (#281 was closed, not merged) | yes | this repository |

So a **1.58.1 binary** currently reads a **v2.0.1** repo config and a **v1.36.0**
home config, and tolerates all three. That works by accident, not by design.

Two things follow from the table that the original ticket did not account for:

- **The home config is where `gitleaks` lives.** It appears nowhere in
  `hk.pkl`, which is why the ticket's list of "every current step" reads as if
  it were a repo step. It is not. Any migration that touches only `hk.pkl`
  leaves the gitleaks configuration behind on v1.36.0.
- **Renovate never sees the home config.** Its custom manager matches
  `/^hk\.pkl$/` only. That is the mechanism by which the home config drifted,
  and leaving it unmanaged means doing this migration again at the next
  release.

### What v2 changes

From the [migration guide](https://hk.jdx.dev/migration-v2) and the
[configuration reference](https://hk.jdx.dev/configuration):

- A top-level `steps` section, when nonempty, generates the `check`, `fix`, and
  `pre-commit` hooks. An explicitly declared hook of one of those names "keeps
  its hook-level settings and replaces same-named inherited steps; top-level
  steps still supply the remaining step names."
- Variant-suffixed builtins (`gitleaks_staged`, `knip_strict`) are gone;
  builtins are typed objects amended with properties. `check_byte_order_marker`
  and `fix_byte_order_marker` merged into `byte_order_marker`.
- `stage` defaults to `true` for `pre-commit` and `false` elsewhere. `stash`
  defaults to `"none"` **everywhere**, including `pre-commit`.
- No implicit `pre-push` hook is created.
- `Types.Regex(...)`/`Config.Regex(...)`, the `defaults { }` block, TOML/YAML/JSON
  configs, `.hkrc.pkl`, and `hk generate` are removed. None of these are used
  here, but the builtin names are worth checking against v2's `Builtins.pkl`
  rather than assumed.

### Measured facts

Everything below was run against throwaway copies of `mise.toml` and
`mise.lock` on 2026-09-19 with mise 2026.9.11. The repository was not modified.

- `mise lock --bump hk` on the current lockfile is a **no-op**. With
  `mise.toml` set to `hk = "2.0.1"`, the lockfile still resolved 1.58.1. mise
  warns why: the lockfile is format version 0.
- `mise lock --upgrade` is what moves it. It rewrote the file to
  `lockfile_version = 2`, pruned the stale `hk@1.58.1` entry, and resolved
  `2.0.1` on `backend = "packslip:github.com/jdx/hk"` — the backend switch the
  ticket predicted.
- The two are **separable**. With `mise.toml` left at 1.58.1, `mise lock
  --upgrade` produced format 2 with hk still at 1.58.1 on `aqua:jdx/hk`.
- The format upgrade preserves all six sigstore `signer` lines and does **not**
  widen signature coverage: hk remains the only tool carrying them. That
  answers the open question recorded in `dotfiles-low`.
- The rewrite touches 75 platform entries across 7 target platforms and grows
  the file from 453 to 462 lines. The "9 skipped" it reports are
  `npm:markdownlint-cli` (7 — npm artifacts are not per-platform),
  `bats-core` on `windows-x64`, and `hk` on `macos-x64`.
- Nothing pins a mise version. `jdx/mise-action@v4.3.0` and the `install`
  fallback both take the current release, so format 2 carries no version-floor
  risk in CI.

## PR 1 — lockfile format upgrade

Closes `dotfiles-low`. `mise lock --upgrade` and nothing else; `mise.toml` is
not touched, so hk stays at 1.58.1 on the aqua backend and only the lockfile
structure changes.

It goes first because it is mechanical and whole-file. Landing it alone proves
CI accepts `lockfile_version = 2` before any behavior changes, so a red build
in PR 2 has one plausible cause instead of two.

`mise.lock` is a pinned, Renovate-sensitive manifest, so per `AGENTS.md` this
routes through the Package Manager subagent.

**Done when:** `hk check` and `./bin/test` are green locally, CI is green, and
the PR body accounts for the 9 skipped entries rather than leaving them
unexplained.

## PR 2 — hk v2

Closes `dotfiles-q8j`. Four parts, one PR, because the binary and the configs
are halves of one upgrade that Renovate cannot coordinate.

### (a) Binary

`mise.toml`: `hk = "1.58.1"` → `"2.0.1"`, then `mise lock --bump hk`. The
backend moves from `aqua:jdx/hk` to `packslip:github.com/jdx/hk`.

### (b) Repo config — `hk.pkl`

Adopt the native v2 shape. The current file builds a `local linters` mapping
and assigns it into three hooks, with a comment explaining that `bd-pre-commit`
cannot live in `linters` because `check` and `fix` run in CI where `bd` is not
installed. v2 supports that arrangement directly, so the workaround and its
comment are deleted: `linters` becomes the top-level `steps` map, and an
explicit `pre-commit` hook contributes `bd-pre-commit` while still inheriting
every top-level step.

Explicit hooks are kept only where they add something:

| Hook | Why it stays explicit |
| --- | --- |
| `pre-commit` | adds `bd-pre-commit`; sets `stash = "git"` |
| `pre-push` | `bd-pre-push`; v2 creates no implicit pre-push |
| `commit-msg` | `check_conventional_commit` |
| `post-merge` | `bd-post-merge` |

`stash = "git"` must be written explicitly. v2 defaults `stash` to `"none"` on
every hook, so omitting it silently drops stashing rather than inheriting the
current behavior.

Every exclusion carries forward unchanged:

| Step | Exclusion |
| --- | --- |
| `detect-private-key`, `markdown-lint` | `docs/reference/**` |
| `mixed-line-ending`, `trailing-whitespace`, `newlines` | `test/fixtures/**` |
| `jq` | VS Code and Cursor `User/*.json`, `test/fixtures/**` |
| `shellcheck`, `shfmt` | `**/*.tmpl`, `**/.chezmoitemplates/**` |

The second shell exclusion was added in #320 and is load-bearing: without it,
`home/.chezmoitemplates/git-hooks/beads-shim` is linted as shell and fails on
the `{{ range }}` inside its `for` loop. It must survive the reshape.

Each builtin in use is checked against v2's `Builtins.pkl` for a variant merge
rather than assumed to have kept its name — `check_merge_conflict`,
`check_symlinks`, `check_executables_have_shebangs`, `mixed_line_ending`,
`trailing_whitespace`, `newlines`, and `check_conventional_commit` are all in
the naming shape v2 consolidated.

### (c) Home config — `home/dot_config/hk/config.pkl`

Bump the `amends` from v1.36.0 to v2.0.1. Keep its three explicit hooks:
gitleaks runs a *different command* per hook (`gitleaks protect --staged` on
`pre-commit` and `pre-push`, `gitleaks git --no-banner --verbose` on `check`),
so a shared top-level `steps` map does not fit.

The v2 path for a home config is already `~/.config/hk/config.pkl`, which is
where chezmoi deploys it. Only the schema version is stale.

### (d) Renovate

Extend the `hk.pkl` custom manager in `renovate.json5` to also match
`home/dot_config/hk/config.pkl`. The existing regex already solves the hard
part — the version appears twice per import, as the release tag and as the
`hk@<version>.zip` asset, and capturing only the tag produced 404s (see the
comment above the manager and #311). The second path needs the same treatment.

Renovate config churn also routes through the Package Manager subagent.

## Verification

Scratch-first. Stand both configs up in a throwaway directory and run hk 2.0.1
against them before touching anything real.

The load-bearing check is a **plan diff**: capture `hk check -P` (and the
`pre-commit` plan) under 1.58.1, then again under 2.0.1, and compare. That
demonstrates "same steps, same files, same exclusions" instead of asserting it.
Specifically confirm:

1. The step list is identical, name for name.
2. Every exclusion still excludes — in particular that
   `home/.chezmoitemplates/**` matches no files for `shellcheck` and `shfmt`.
3. `bd-pre-commit` runs in `pre-commit` and **not** in `check` or `fix`, which
   is the property the deleted workaround existed to guarantee.
4. `gitleaks` still runs, from the home config, in all three of its hooks.

Then `./bin/test` (267 passing as of #320) and CI.

`test/beads-policy.bats` asserts that shims never `exec` hk and that the hk
invocation is guarded on `hk.pkl`. Those must stay green. Whether the reshape
warrants a new assertion is an implementation-time call.

## Risks

**Undocumented merge semantics.** Both the home config and `hk.pkl` declare a
`pre-commit` hook. How v2 merges a home hook with a repo hook is not covered in
the migration guide. Verify empirically before relying on it; do not reason it
out from the single-config precedence rule.

**Machine-wide blast radius.** The home config reaches every repository on this
machine, client work included. Before `chezmoi apply`, confirm that hk 1.x
still tolerates a v2-amended home config, since a repository with its own older
hk pin will read it. The current state is evidence that hk is tolerant in the
other direction, but that is not proof.

**Live hooks.** This repository's hooks were retrofitted on 2026-09-18, so a
broken `hk.pkl` blocks every commit here. That makes it the canary. `HK=0` is
the escape hatch; the beads shim already honors it.

## Out of scope

**The gitleaks pre-push no-op.** The home config runs `gitleaks protect
--staged` on `pre-push`, where nothing is staged. Observed on 2026-09-18:
that invocation reported "scanned ~0 bytes (0)" and passed, while the same
command on `pre-commit` scanned ~5551 bytes and worked. Pre-push secret
scanning has therefore never done anything. Filed separately — it is a
security-behavior change to a machine-wide config and deserves its own
verification of what to scan and how noisy it is, rather than riding inside a
toolchain migration.

**The beads shim.** `home/.chezmoitemplates/git-hooks/beads-shim` is not
changed by this work. It chains hk rather than `exec`ing it, deliberately, so
the beads block stays reachable; confirm that still holds under v2's staging
and stashing behavior, but do not edit it here.
