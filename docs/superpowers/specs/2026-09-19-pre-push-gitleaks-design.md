# Pre-push gitleaks scan

**Date:** 2026-09-19
**Status:** designed; not yet implemented
**Beads:** `dotfiles-6c6`

Making the pre-push secret scan scan something, and adding the test whose
absence let it do nothing for months.

## Context

`home/dot_config/hk/config.pkl` runs `gitleaks protect --staged` in its
`pre-push` hook. Nothing is staged at push time, so the scan reads an empty
set and exits 0.

Observed in this repository's own hook output on 2026-09-18: the pre-push
invocation reported `INF 0 commits scanned` and `INF scanned ~0 bytes (0) in
95.5ms`, then passed. The identical command on `pre-commit` scanned ~5551
bytes and worked. Pre-push secret scanning has therefore never scanned
anything since it was added in `b5849b8`.

The failure mode is the point: the command **succeeded** while doing nothing.
Nothing distinguishes that from a clean scan except reading the byte count.

This file is chezmoi-managed and deploys to `~/.config/hk/config.pkl`, so hk
reads it in every repository on this machine, client work included.

### What pre-push is for

`pre-commit` already scans staged content. `pre-push` is the backstop for
commits that never passed it: made with `--no-verify`, created before the hook
existed, pulled in from another machine or a merge, or written by tooling.
That framing sets the target: the commits being pushed, not the working tree.

### Constraints discovered

Measured on 2026-09-19 against hk 2.0.1 and gitleaks 8.30.1:

- **hk exposes no push range.** Its template variables are `{{files}}`,
  `{{workspace}}`, `{{workspace_indicator}}` and `{{workspace_files}}` — none
  carry git's pre-push stdin (`<local ref> <local sha> <remote ref>
  <remote sha>`).
- **hk hands a pre-push step zero files.** `hk run pre-push -P -J` reports
  `fileCount: 0` for every step, so any `{{files}}`-based approach is out.
- **`gitleaks git` accepts `--log-opts`**, so an arbitrary commit range can be
  named. The range therefore has to come from git itself, not from the hook.
- **A full-history scan is cheap at this scale.** This repository — the largest
  involved, 637 commits, 4.29 MB — scans in 499 ms. The original ticket assumed
  full history "would be far too slow"; that is not true here, which widens the
  options rather than narrowing them.
- **`gitleaks protect` still exists in 8.30.1** but is the deprecated spelling;
  `gitleaks git` is its replacement, and hk's own v2 builtin emits
  `gitleaks git --pre-commit --redact --staged --verbose --no-banner`.

## Decision

Use `HEAD --not --remotes` as the range: the commits no remote has, which is
exactly what is about to leave the machine.

The alternative, `@{push}..HEAD`, describes the push more literally but fails
on a branch that has never been pushed — the most common case for new feature
work — so it needs a fallback path that would rarely run and rarely be tested.
That is the same shape as the bug being fixed here.

`HEAD --not --remotes` needs no fallback. Verified across four cases in a
throwaway repository with a bare remote:

| Case | Result |
| --- | --- |
| Everything pushed, nothing new | scans 0 bytes, exits 0 |
| Unpushed commit containing a secret | `leaks found: 1`, exits 1 |
| Brand-new branch, never pushed (`@{push}` does not resolve) | detects, exits 1 |
| No remote refs present locally | detects; degenerates to full history |

The degenerate case is bounded by the same ~500 ms as a full scan, so the
worst case costs no more than the simplest possible alternative.

## Changes

### `home/dot_config/hk/config.pkl`

Two of its three steps change; `check` is left alone, since a full-history
sweep is correct for a CI-style check.

| Hook | Before | After |
| --- | --- | --- |
| `pre-commit` | `gitleaks protect --staged` | `gitleaks git --pre-commit --redact --staged --verbose --no-banner` |
| `pre-push` | `gitleaks protect --staged` | `gitleaks git --no-banner --redact --verbose --log-opts="HEAD --not --remotes"` |
| `check` | `gitleaks git --no-banner --verbose` | unchanged |

`pre-commit` moves to the non-deprecated spelling, matching what hk's v2
builtin emits. It is in scope because it is the same deprecated command that
made the broken `pre-push` line look plausible. `--redact` is new on both: it
stops a detected secret being echoed into terminal output, which matters most
in the hook that fires while someone is watching the terminal.

### `test/hk-config.bats`

This is the part that keeps the fix from rotting. The bug survived because
nothing exercised the hook: the command exited 0 while scanning nothing, and
that is indistinguishable from a clean pass without reading the byte count.

Add two cases, both against a throwaway repository with a bare remote so no
network and no real credentials are involved:

1. **It fires.** Push a clean commit, then commit a planted test secret without
   pushing. The pre-push command must exit **non-zero**.
2. **It stays quiet.** With nothing unpushed, the same command must exit
   **zero**.

Both are required. The first alone would pass against a scan that fails on
everything; the second alone is what the current broken command already does.
Together they show the scan can distinguish the two states, which is precisely
what was never true before.

Follow the conventions already in that file: a locally defined `repo_root()`,
a module-level constant for any fixed path, `run` plus
`[ "$status" -eq N ] || fail "..."`, and `skip` when a required tool is
absent — checking `gitleaks` the way the existing test checks `pkl`.

## Out of scope

- `hk.pkl`, the beads shim, and CI are untouched.
- The `check` hook's full-history scan stays as it is.
- Whether `gitleaks` should be installed machine-wide. It resolves on PATH
  today via a mise install, but it is declared only in this repository's
  `mise.toml`, so a repository that runs hk without it would fail this step at
  runtime. That is a real gap and a separate question from what pre-push
  scans; it is not addressed here.
