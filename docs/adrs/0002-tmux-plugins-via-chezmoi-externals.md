---
status: "proposed"
date: 2026-05-12
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Tmux plugins via Chezmoi externals (not TPM / tpack / submodules)

## Context and Problem Statement

Tmux “plugins” are usually plain directories of `.tmux` scripts or small repos that must land on disk before `tmux.conf` runs `source` / `run-shell`. Common ways to get them there are:

- **[TPM](https://github.com/tmux-plugins/tpm)** — clone-on-first-run, key-bound updates, and a second orchestration layer beside dotfiles.
- **tpack and similar** — another installer with its own state and conventions.
- **Git submodules** inside the dotfiles repo — workable, but noisy for consumers, painful in shallow clones, and easy to drift from Renovate’s model for this repository.

This repo **already** vendors the base [`gpakosz/.tmux`](https://github.com/gpakosz/.tmux) layout via Chezmoi **externals** (`home/.chezmoiexternal.toml.tmpl`, `type = "git-repo"`, `[".tmux"]`). The open question is how to add **additional** tmux plugins (vim-tmux-navigator, resurrect, continuum, theme packs, etc.) **without** introducing a second plugin manager whose state lives outside Chezmoi’s source of truth.

## Decision Drivers

- **Reproducibility**: Plugin trees should be pinned (commit SHA or tarball digest), not “whatever `git pull` last did.”
- **Renovate alignment**: Updates should flow through the same automation as other externals (see `renovate.json5` and [docs/renovate.md](../renovate.md)).
- **Single orchestration surface**: One tool applies the machine (`chezmoi apply`); no extra “install plugins” step for humans or agents to remember.
- **Security**: Immutable pins and review path for URLs; avoid unauthenticated `master`/`main` pulls where policy requires SHAs.
- **Compatibility with gpakosz/.tmux**: Overrides in `dot_tmux.conf.local` (and upstream’s sourcing order) must remain predictable.

## Considered Options

1. **TPM** — `~/.tmux/plugins/tpm` + `set -g @plugin` list; familiar ecosystem. Downside: parallel lifecycle, extra keys/docs, harder to pin every plugin consistently in one place.
2. **tpack (or similar)** — Same class of problem: second package graph and mental model.
3. **Git submodules under this repo** — Pins versions in the parent repo, but complicates clones, CI, and “edit in `home/` only” workflows; Renovate can submodule-update but it is heavier than externals already in use.
4. **Chezmoi externals only** — Each plugin (or small bundle) is an `archive` or `git-repo` entry under a path tmux already sources (e.g. under `~/.tmux/plugins/<name>` or a dedicated `~/.config/tmux/plugins/<name>`), with `refreshPeriod` and Renovate-managed URLs/SHAs where applicable.
5. **Hybrid** — Base via external (as today); rare one-off via TPM for a plugin with no sensible tarball. Increases long-term complexity; only attractive for short migrations.

## Decision Outcome (proposed)

**Adopt option (4): manage tmux plugin directories exclusively via Chezmoi externals** (and first-party files in `home/`), aligned with how Oh My Zsh, zsh plugins, Ghostty themes, and `.tmux` itself are already pulled.

Concretely:

- Add one external block per plugin (or per curated bundle), targeting a path that **`tmux.conf` / `dot_tmux.conf.local` can `source` or `run-shell`** after the gpakosz tree loads (exact order documented when implemented).
- Prefer **`archive` + stripComponents** when upstream publishes stable tarballs; use **`git-repo` + SHA in URL** (or Renovate `git-refs` updates) when archives are awkward.
- **No TPM / tpack** in the default path; no submodules for tmux-only deps unless an ADR explicitly documents an exception.

This ADR does **not** require ripping out upstream gpakosz behavior; it only constrains **how new plugin trees are introduced**.

### Consequences

- **Positive**: One apply path; pins visible in `.chezmoiexternal.toml.tmpl`; Renovate can propose bumps like other externals; agents follow existing “edit externals → Package Manager / renovate rules” guidance.
- **Positive**: No `prefix + I` style TPM install UX to document in parallel with Chezmoi.
- **Negative**: Authors must map each plugin’s install instructions to “directory on disk + source line”; some TPM-only docs need translation once per plugin.
- **Negative**: Very fast-moving plugins without tags may need `git-refs` + frequent Renovate noise—mitigate with grouping or longer `refreshPeriod`.

### Confirmation

- `chezmoi apply` on a clean machine yields the same plugin directories as in source (no TPM clone step).
- `renovate.json5` (or documented custom managers) can update each external pin without hand-editing lockfiles under `~/.tmux/plugins`.
- `dot_tmux.conf.local` (or templated tmux fragment) lists explicit `source-file` / `run-shell` lines that match external paths—grep-able in review.

## Rejected Options (for default posture)

- **(1) TPM and (2) tpack as the primary story** — Rejected for duplicate orchestration and weaker default pinning story unless an exception ADR is written.
- **(3) Submodules for routine tmux plugins** — Rejected in favor of externals already used for the same class of problem elsewhere in this repo.

## More information

- Chezmoi externals: [chezmoi.io user guide / Include files from an external](https://www.chezmoi.io/user-guide/include-files-from-an-outside-source/)
- Current external table: `home/.chezmoiexternal.toml.tmpl` (includes `[".tmux"]` git-repo).
- Renovate custom managers for externals: [docs/renovate.md](../renovate.md).
