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
| [0003](0003-mise-config-plus-lockfile.md) | Mise config + lockfile | 2026-05-15 | accepted | Fuzzy/`latest` in `mise.toml` / global config; exact pins + checksums + URLs in committed `mise.lock`; Renovate PRs update locks; Chezmoi `run_onchange` hashes lockfile so `mise install` re-runs when it changes. |
| [0004](0004-claude-settings-management.md) | Claude settings management | 2026-05-16 | superseded | Proposed (never implemented) hybrid: move static lists incl. plugins to `home/.chezmoidata/claude-*.yaml` rendered by `settings.json.tmpl`. Superseded by [0008](0008-claude-config-two-managers.md), which realizes the plugin/MCP surface through the `claude` CLI instead of a settings template. |
| [0005](0005-universal-theme-switcher.md) | Universal `theme` switcher | 2026-05-20 | accepted | `theme <name>` on `$PATH` writes a state file at `~/.local/state/theme/current` and runs every applier under `home/dot_local/libexec/dotfiles/theme.d/`; catalog of theme → per-tool palette mapping lives in `home/.chezmoidata/themes.yaml`. Switches never dirty the chezmoi source tree. |
| [0006](0006-sketchybar-via-sbarlua.md) | Sketchybar via SbarLua | 2026-05-29 | accepted | Sketchybar config moves from bash to Lua via SbarLua. The module is pinned as a `git-repo` external (`home/.chezmoiexternals/sketchybar-lua.toml.tmpl`), built by a `run_onchange_after_` script into `~/.local/share/sketchybar_lua/sketchybar.so`, and run by brew `lua` (5.5, ABI-matched). Theme overlay becomes a Lua color table; ADR 0005 contract unchanged. |
| [0007](0007-window-management-strategy.md) | Window management strategy | 2026-06-02 | accepted | Adopt AeroSpace tiling in numbered phases (float-everything baseline → tile one workspace at a time), coexisting with Loop. Clear ownership: AeroSpace owns workspaces + tiling, Loop owns manual snapping of *floating* windows, so they never contend. Loop's `loop` cask is brought into `packages.yaml`; Loop is phased out only once tiling covers most workspaces (revisit condition recorded). |
| [0008](0008-claude-config-two-managers.md) | Claude config: two managers | 2026-06-10 | accepted | Split `~/.claude` config by who owns the bytes: `bin/sync-claude-settings` keeps the flat surface (statusLine, permissions, hooks, flags, model) imperatively; marketplaces/plugins/MCP move to declarative `home/.chezmoidata/claude.yaml` (+ machine-local extras) reconciled through the `claude` CLI by `bin/sync-claude-extras`. Adds a `block-adhoc-installers` guard enforcing `/install`, and apply-time Bedrock model resolution. Supersedes [0004](0004-claude-settings-management.md). |
