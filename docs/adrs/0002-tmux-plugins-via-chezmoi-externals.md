---
status: "accepted"
date: 2026-05-13
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

Separately, plugin URLs, types, and pin-related fields should stay **reviewable and grouped** like other machine-oriented lists in this repo (`home/.chezmoidata/packages.yaml`, `aliases.yaml`), not only as long hand-maintained TOML fragments.

## Decision Drivers

- **Reproducibility**: Plugin trees should be pinned (commit SHA or tarball digest), not “whatever `git pull` last did.”
- **Renovate alignment**: Updates should flow through the same automation as other externals (see `renovate.json5` and [docs/renovate.md](../renovate.md)); pin locations must be regex-friendly where custom managers apply.
- **Single orchestration surface**: One tool applies the machine (`chezmoi apply`); no extra “install plugins” step for humans or agents to remember.
- **Security**: Immutable pins and review path for URLs; avoid unauthenticated `master`/`main` pulls where policy requires SHAs.
- **Compatibility with gpakosz/.tmux**: Overrides in `dot_tmux.conf.local` (and upstream’s sourcing order) must remain predictable.
- **Data locality**: Tmux plugin **catalog** (what to fetch, where it lands, archive vs git-repo) lives under `home/.chezmoidata/` so it matches the pattern used for packages and shell aliases.

## Considered Options

1. **TPM** — `~/.tmux/plugins/tpm` + `set -g @plugin` list; familiar ecosystem. Downside: parallel lifecycle, extra keys/docs, harder to pin every plugin consistently in one place.
2. **tpack (or similar)** — Same class of problem: second package graph and mental model.
3. **Git submodules under this repo** — Pins versions in the parent repo, but complicates clones, CI, and “edit in `home/` only” workflows; Renovate can submodule-update but it is heavier than externals already in use.
4. **Chezmoi externals only** — Each plugin (or small bundle) is an `archive` or `git-repo` entry under a path tmux already sources (e.g. under `~/.tmux/plugins/<name>` or a dedicated `~/.config/tmux/plugins/<name>`), with `refreshPeriod` and Renovate-managed URLs/SHAs where applicable.
5. **Hybrid** — Base via external (as today); rare one-off via TPM for a plugin with no sensible tarball. Increases long-term complexity; only attractive for short migrations.

## Decision Outcome

**Adopt option (4): manage tmux plugin directories exclusively via Chezmoi externals**, with the **authoritative plugin list in** `home/.chezmoidata/tmux-plugins.yaml` (root key `tmux_plugins`, array `extras`). The file `home/.chezmoiexternal.toml.tmpl` **ranges over** `.tmux_plugins.extras` and emits one external block per entry, alongside the existing static blocks (Oh My Zsh, zsh plugins, Ghostty themes, and `[".tmux"]`).

This matches how other Chezmoi template data is centralized under `home/.chezmoidata/` while keeping the **actual fetch semantics** in Chezmoi externals (not duplicated in shell scripts).

Concretely:

- **Catalog**: Add or edit rows under `tmux_plugins.extras` in `home/.chezmoidata/tmux-plugins.yaml` (`path`, `type`, `url`, plus optional `refreshPeriod`, `exact`, `stripComponents` for archives, `revision` for git-repo pins when used).
- **Apply**: `chezmoi apply` materializes those paths like any other external; `dot_tmux.conf.local` (or a future templated fragment) **`source-file` / `run-shell`** entries must reference the same paths as in the catalog.
- Prefer **`archive` + stripComponents** when upstream publishes stable tarballs; use **`git-repo`** (with `revision` when pinning) when archives are awkward.
- **No TPM / tpack** in the default path; no submodules for tmux-only deps unless an ADR explicitly documents an exception.
- **Advanced external keys** not covered by the current schema (for example Chezmoi `include` globs on archives) may stay as **one-off static blocks** in `.chezmoiexternal.toml.tmpl` until the catalog schema grows; the ADR still prefers the catalog for routine plugin rows.

This ADR does **not** require ripping out upstream gpakosz behavior; it only constrains **how new plugin trees are introduced**.

### Consequences

- **Positive**: One apply path; human-edited URLs and options live in `tmux-plugins.yaml` next to other `.chezmoidata` lists; externals TOML stays thin and mechanical.
- **Positive**: Renovate (or future custom managers) can target **stable file + field shapes** in YAML for digest/SHA bumps, in addition to static lines elsewhere in `.chezmoiexternal.toml.tmpl`.
- **Positive**: No `prefix + I` style TPM install UX to document in parallel with Chezmoi.
- **Negative**: Authors must map each plugin’s install instructions to “row in YAML + directory on disk + tmux source line”; some TPM-only docs need translation once per plugin.
- **Negative**: Very fast-moving plugins without tags may need `git-refs` + frequent Renovate noise—mitigate with grouping or longer `refreshPeriod`.
- **Negative**: Two files change for a new plugin when wiring tmux itself: the YAML catalog **and** an explicit tmux `source-file` / `run-shell` (until a template deduplicates paths).

### Confirmation

- `chezmoi apply` on a clean machine yields the same plugin directories as defined in `tmux-plugins.yaml` (no TPM clone step).
- `renovate.json5` (or documented custom managers) can update pins in that YAML (and other externals) without hand-editing trees under `~/.tmux/plugins`.
- `dot_tmux.conf.local` (or templated tmux fragment) lists explicit `source-file` / `run-shell` lines that match catalog `path` values—grep-able in review.

## Rejected Options (for default posture)

- **(1) TPM and (2) tpack as the primary story** — Rejected for duplicate orchestration and weaker default pinning story unless an exception ADR is written.
- **(3) Submodules for routine tmux plugins** — Rejected in favor of externals already used for the same class of problem elsewhere in this repo.

## More information

- Chezmoi externals: [chezmoi.io user guide / Include files from an external](https://www.chezmoi.io/user-guide/include-files-from-an-outside-source/)
- Plugin catalog: `home/.chezmoidata/tmux-plugins.yaml`; generator loop: `home/.chezmoiexternal.toml.tmpl` (after the static `[".tmux"]` block).
- Renovate custom managers for externals: [docs/renovate.md](../renovate.md).
