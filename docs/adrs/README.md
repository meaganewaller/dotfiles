# Architecture Decision Records (ADRs)

This directory holds **architecture decision records** for this dotfiles repository: short, durable write-ups of significant choices (shell behavior, tooling layout, automation tradeoffs) and the context that led to them.

ADRs are not step-by-step how-tos. They answer **what we decided**, **why**, and **what we explicitly did not choose**, so future changes can be reviewed against original intent instead of re-litigating from scratch.

## Conventions

- **Filename**: `NNNN-short-kebab-title.md` (zero-padded sequence, then a slug). Example: `0001-specialized-agent-shell.md`.
- **Frontmatter**: Each ADR should include YAML at the top with at least `status`, `date`, and `decision-makers`. Optional fields such as `consulted` and `informed` are welcome when relevant.
- **Status**: Typical values include `proposed`, `accepted`, `superseded`, or `deprecated`. Update the status (and this README table) when a decision changes or is replaced by a newer ADR.

When you add a new ADR, append a row to the index table below.

## Index

| ADR | Title | Date | Status | Summary |
| --- | --- | --- | --- | --- |
| [0001](0001-specialized-agent-shell.md) | Agents need a specialized shell | 2026-05-12 | accepted | Branch `dot_zshrc` early for agent contexts so POSIX-style commands and fast startup win; keep mise/PATH via explicit env and vendor fingerprints (`CLAUDECODE`, Cursor vars, etc.). |
| [0002](0002-tmux-plugins-via-chezmoi-externals.md) | Tmux plugins via Chezmoi externals | 2026-05-13 | accepted | Plugin catalog in `home/.chezmoidata/tmux-plugins.yaml`; `.chezmoiexternal.toml.tmpl` emits externals from that list—no TPM/tpack/submodules for routine plugins. |
| [0003](0003-mise-config-plus-lockfile.md) | Mise config + lockfile | 2026-05-12 | proposed | Fuzzy/`latest` in `mise.toml` / global config; exact pins + checksums + URLs in committed `mise.lock`; Renovate PRs update locks; Chezmoi `run_onchange` hashes lockfile so `mise install` re-runs when it changes. |
