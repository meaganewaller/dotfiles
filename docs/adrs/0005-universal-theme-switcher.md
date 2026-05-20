---
status: "accepted"
date: 2026-05-20
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Universal `theme` switcher driven by a registry of per-tool appliers

## Context and Problem Statement

Theme/colorscheme handling in this repo is currently fragmented and indirectly driven by **system appearance**, not by an explicit user choice:

- [`home/dot_local/libexec/dotfiles/executable_appearance`](../../home/dot_local/libexec/dotfiles/executable_appearance) reports `dark` or `light` based on `$BG`, macOS `defaults`, or a fallback.
- [`home/dot_local/libexec/dotfiles/executable_tmux-apply-theme`](../../home/dot_local/libexec/dotfiles/executable_tmux-apply-theme) reads `appearance` and `tmux set -g` pane styles for Catppuccin Mocha or Latte.
- [`home/dot_local/libexec/executable_claude-powerline-theme`](../../home/dot_local/libexec/executable_claude-powerline-theme) reads `appearance` and `jq`-merges `shared.json` with `catppuccin-mocha.json` or `catppuccin-latte.json` into a tmp config before exec'ing `claude-powerline`.
- [`home/dot_config/ghostty/config.tmpl`](../../home/dot_config/ghostty/config.tmpl) leans on Ghostty's native `theme = dark:Catppuccin Mocha,light:Catppuccin Latte` directive — also appearance-driven.
- [`home/dot_config/nvim/lua/theme/init.lua`](../../home/dot_config/nvim/lua/theme/init.lua) keeps a fixed list of managed colorschemes (afterglow, boo, catppuccin-mocha, gruvbox, kanagawa-wave, tokyonight, …) and defaults to `catppuccin-mocha` — not appearance-driven, but also not switchable from outside Neovim.

Two papercuts follow:

1. **No single command picks the palette.** "Try gruvbox everywhere for an hour" requires touching tmux, Neovim, claude-powerline, and Ghostty by hand — each with its own ergonomics.
2. **Any obvious solution risks git-diff churn.** A naive design would store the active theme in the chezmoi source (e.g. a value in `home/.chezmoidata/theme.yaml` or a rendered file under `home/dot_config/...`) so templates can interpolate it. Every flip from mocha → latte → gruvbox then mutates a tracked file and shows up in `git status`. For an ergonomic switcher used multiple times per session, that's unacceptable noise — the repo is supposed to converge to a clean tree after `chezmoi apply`, not drift every time the user changes their mind about colors.

The decision to make: how should a universal `theme` command be structured so that (a) one invocation propagates a palette to every opted-in tool, (b) new tools register themselves with a single edit, and (c) switching themes at runtime does **not** dirty the chezmoi source tree?

## Decision Drivers

- **One command, many tools**: `theme <name>` MUST be the entry point. The user SHOULD NOT need to know which tools participate.
- **One-place registration**: Adding a new tool to the switcher SHOULD be a single change (a registry row + a tiny applier script), mirroring the "data in `.chezmoidata/`, behavior in scripts" idiom from ADRs [0002](0002-tmux-plugins-via-chezmoi-externals.md), [0003](0003-mise-config-plus-lockfile.md), and [0004](0004-claude-settings-management.md).
- **No diff churn**: A theme switch MUST NOT modify any file under `home/` or other chezmoi-tracked locations. The currently-selected theme is *runtime state*, not source of truth.
- **Source still has a defined default**: A fresh `chezmoi apply` on a clean machine MUST yield a coherent baseline theme without anyone running `theme` first. That baseline lives in chezmoi data (committed) — the override lives in state (uncommitted).
- **Hot-reload where possible**: For long-running processes (tmux, Neovim, Claude Code) the switch SHOULD apply without restart. For tools that only read config at launch (Ghostty pre-1.x) the switcher MAY write into an overlay path the tool already `config-file`s from.
- **Layering with system appearance**: The existing `appearance` script is still useful for tools that prefer auto-tracking macOS dark/light. The new switcher MUST coexist with it — an explicit `theme` call wins, and falling back to `appearance` is allowed for tools that opt in.
- **No invasive abstractions**: The repo already has small POSIX shell utilities under `home/dot_local/libexec/dotfiles/`. The design SHOULD extend that style rather than introduce a new framework.

## Considered Options

1. **Status quo — appearance-driven only.** Keep each tool reading `appearance` independently. No central switcher; "use gruvbox" is not expressible.
2. **Imperative `theme` script with hardcoded tool blocks.** A single `bin/theme` (or `home/dot_local/bin/executable_theme`) with one shell function per tool. Registration = edit the script.
3. **Theme stored in chezmoi data + `chezmoi apply` on switch.** `home/.chezmoidata/theme.yaml` holds the active theme; `theme <name>` mutates it and runs `chezmoi apply`. Templates render the new palette into tracked config files.
4. **Registry + per-tool appliers + runtime state file (recommended).** The chezmoi source holds the *catalog* (what themes exist, what each tool's palette mapping is) and the *appliers* (one executable per tool). The *active selection* lives in an XDG state file outside `home/`. `theme <name>` writes the state file and runs every applier.
5. **Auto-discovery only — no registry, scan a directory.** `theme <name>` runs every executable in `~/.local/libexec/dotfiles/theme.d/` and passes the theme name; each applier knows its own palette. No central catalog.

## Decision Outcome

**Adopt option (4), with a borrowed safety belt from (5).** The switcher composes in three layers:

| Layer | Owner | Lives in | Purpose |
| --- | --- | --- | --- |
| 1. **Catalog** | chezmoi data | `home/.chezmoidata/themes.yaml` | Static map of theme name → per-tool palette references (e.g. `gruvbox` → `{ nvim: gruvbox, tmux-powerline: catppuccin-mocha, claude-powerline: catppuccin-mocha.json, … }`) |
| 2. **Appliers** | chezmoi source | `home/dot_local/libexec/dotfiles/theme.d/executable_*` | One small POSIX script per tool. Takes the theme name as `$1`, reads the catalog if it needs the mapping, performs the in-memory or overlay write |
| 3. **Active selection** | runtime state | `~/.local/state/theme/current` (XDG_STATE_HOME) | One-line file containing the active theme name. **Not** managed by chezmoi. Created on first `theme <name>` call; absent on a fresh machine |

Concretely:

1. **`home/.chezmoidata/themes.yaml`** is the single source of truth for *which themes exist and what each tool should do for each one*. Shape (sketch):

   ```yaml
   default: catppuccin-mocha
   themes:
     catppuccin-mocha:
       nvim: catppuccin-mocha
       tmux: catppuccin-mocha
       claude-powerline: catppuccin-mocha.json
     catppuccin-latte:
       nvim: catppuccin-latte
       tmux: catppuccin-latte
       claude-powerline: catppuccin-latte.json
     gruvbox:
       nvim: gruvbox
       tmux: catppuccin-mocha  # tmux palette this tool currently supports
       claude-powerline: catppuccin-mocha.json
   ```

   A tool that doesn't have a mapping for a given theme falls back to the catalog `default`. The catalog is the *one* place a reader looks to understand what `theme gruvbox` will do across the stack.

2. **`home/dot_local/bin/executable_theme`** is the entrypoint script on `$PATH`. Behavior:

   - `theme` (no args) — print the current selection from state (or the catalog `default` if state is absent).
   - `theme list` — print catalog theme names, one per line.
   - `theme <name>` — validate against the catalog; write `~/.local/state/theme/current`; execute every `~/.local/libexec/dotfiles/theme.d/*` applier with the new theme name as `$1`; report per-applier success/failure.
   - `theme <name> --dry-run` — same validation + listing of appliers that would fire, no writes.

3. **Per-tool appliers** live in `home/dot_local/libexec/dotfiles/theme.d/` as executables named after the tool they drive (`executable_tmux`, `executable_nvim`, `executable_claude-powerline`, `executable_ghostty`, …). Each:

   - Receives the theme name as `$1`.
   - Looks up its own per-tool value from the catalog (read at runtime via a tiny shared helper, e.g. `theme-lookup <tool>` that `yq`/`jq`s the rendered catalog).
   - Applies the change *without* modifying any chezmoi-tracked file. The applier MAY write to non-tracked overlay paths (`~/.local/state/theme/<tool>.conf`, `~/.config/<tool>/active-theme.conf`) that the consuming tool `include`s / `source-file`s / `config-file`s.
   - Exits non-zero on failure; `theme` aggregates and surfaces the per-tool result.

4. **Hot-reload contracts per tool** (initial set; more added by registration):

   - **tmux** — applier runs `tmux set-environment THEME …` and `tmux source-file ~/.local/state/theme/tmux.conf`, regenerated from the catalog. Existing pane styling logic moves out of `tmux-apply-theme` into the new applier.
   - **Neovim** — applier writes `~/.local/state/theme/nvim` (just the colorscheme name) and pokes any live Neovim sessions via `nvim --server …` (when the socket is discoverable) or relies on a `BufEnter` hook in `home/dot_config/nvim/lua/theme/init.lua` that reads the state file.
   - **claude-powerline** — `claude-powerline-theme` (already exists) gains a state-file read path: if `~/.local/state/theme/current` is present and resolves to a known palette in the catalog, use that; otherwise fall back to today's appearance-driven logic. No file writes on switch — the wrapper reads state on each invocation.
   - **Ghostty** — applier writes `~/.local/state/theme/ghostty.conf` containing only `theme = …`; `home/dot_config/ghostty/config.tmpl` adds a `config-file = ~/.local/state/theme/ghostty.conf` line guarded by an `optional` directive so the file's absence is a no-op (preserving the dark/light auto behavior as the baseline).
   - Tools NOT registered (e.g. Cursor / VS Code, fish themes synced via externals) stay on their current behavior. Registration is opt-in.

5. **State file lives at `${XDG_STATE_HOME:-$HOME/.local/state}/theme/current`** and contains exactly one line: the theme name. It is created on first `theme <name>` call. It is **never** written by chezmoi and **never** referenced from chezmoi source files except as a path. A `.gitignore`-style audit (`grep -RIn '.local/state/theme' home/`) MUST only match the path string in scripts, not actual file contents under `home/`.

6. **Default theme on fresh machines** comes from the catalog: `theme` with no args (and no state file) returns `themes.yaml`'s `default` field; appliers asked to run on a fresh machine with no state default to the same. A new contributor running `chezmoi apply` for the first time gets the same coherent palette they'd get if they ran `theme catppuccin-mocha` manually.

7. **Registration safety belt (the borrow from option 5):** at `chezmoi apply` time, a `run_onchange` script MAY cross-check that every tool key referenced in `themes.yaml` has a matching applier under `home/dot_local/libexec/dotfiles/theme.d/`, and vice versa. Catalog rows without an applier (or vice versa) fail the apply with a readable error — same shape as the "every hook in `claude-hooks.yaml` has a file on disk" check from ADR [0004](0004-claude-settings-management.md).

8. **Coexistence with `appearance`:** the appearance script stays. Tools currently driven by it keep working unchanged on a machine that never runs `theme`. The applier contract is *additive* — once a tool registers, its applier wins when a state file is present, but it falls back to `appearance` otherwise. This is the seam that lets the design ship one tool at a time.

### Consequences

- **Positive**: A new tool joins the switcher with a single edit (one applier file) plus, optionally, mapping rows in the catalog. No edits to the entrypoint script.
- **Positive**: Theme switches leave the chezmoi source tree clean. `git status` after a session of palette experimentation shows no changes. The "did I leave my repo dirty" anxiety from option (3) is absent by construction.
- **Positive**: The catalog is a reviewable YAML diff when palettes change. Future automation (Renovate, Package Manager subagent) can target it the same way it would target `claude-permissions.yaml`.
- **Positive**: `claude-powerline-theme` stops re-merging JSON on every prompt render — once a state file exists, lookup is a `cat` + a `jq` against the catalog, not a heredoc per invocation. (Optional optimization, not load-bearing.)
- **Negative**: New runtime state location to remember (`~/.local/state/theme/`). Documented in `docs/zsh.md` or a new `docs/theme.md` so it does not become tribal knowledge.
- **Negative**: Two-place registration for tools that need both a catalog mapping AND an applier — though the rendering-time cross-check catches drift.
- **Negative**: Tools that read config only at launch (Ghostty pre-1.x without live config reload, some terminal emulators) need a *manual* restart to fully pick up the new theme even after the applier runs. Mitigated by writing the overlay file so the next launch is correct without further action.
- **Negative**: A future "set theme automatically on macOS dark/light flip" feature has to be layered on top — likely a `launchd` agent that calls `theme dark-default` / `theme light-default` aliases. The design accommodates it but does not ship it. Out of scope for this ADR.
- **Negative**: The catalog format is bespoke. A reader has to learn it. Mitigated by keeping it small (theme name → flat map of tool → token).

### Confirmation

- After implementation: running `theme catppuccin-mocha` on a freshly-applied machine produces no changes under `git status` in this repo.
- Running `theme gruvbox` followed by `theme catppuccin-latte` followed by `theme catppuccin-mocha` cycles every registered tool's appearance without restart for tools that support hot-reload (tmux, Neovim, claude-powerline).
- Adding a new tool to the switcher consists of (a) one new file under `home/dot_local/libexec/dotfiles/theme.d/executable_<tool>` and (b) one new key in each `themes.<name>` map in `home/.chezmoidata/themes.yaml`. No edits to `home/dot_local/bin/executable_theme`.
- `grep -RIn 'theme.d\|theme/current' home/` returns hits only in the entrypoint, appliers, and docs — never in tracked overlay paths that would dirty the tree on switch.
- A `chezmoi apply` on a machine with no `~/.local/state/theme/current` yields a coherent palette across registered tools (catalog default).
- A follow-up issue tracks per-tool applier implementation; this ADR ships only the decision and the registry shape.

## Rejected Options

- **(1) Status quo** — Rejected: does not give the user a single command to flip palettes, and does not express anything other than dark/light.
- **(2) Imperative `theme` script with hardcoded tool blocks** — Rejected: every new tool requires editing the entrypoint, and the wiring (which tools participate, what each one does for a given theme) is invisible to PR review unless a human reads the shell. Same shape as the two-place-edit problem ADR [0004](0004-claude-settings-management.md) tries to fix elsewhere.
- **(3) Theme in chezmoi data + `chezmoi apply` on every switch** — Rejected primarily because it dirties the source tree on every switch (the leading driver behind this ADR). Secondarily because `chezmoi apply` is too heavy a hammer for a UI affordance — it runs `run_onchange` scripts, externals checks, and the full template pipeline for a one-line color flip. Even an "apply just this template" variant trades clean git state for marginal speed.
- **(5) Auto-discovery without a catalog** — Rejected as the default. With no catalog, each applier becomes a mini-catalog itself ("if `$1` is `gruvbox`, use my-vendored-gruvbox; if `catppuccin-mocha`, use catppuccin-mocha; …"). Theme additions then require editing N appliers instead of N+1 lines of YAML. The cross-check at apply time (the *good* part of option 5) is borrowed and kept.

## More information

- Existing appearance plumbing: [`home/dot_local/libexec/dotfiles/executable_appearance`](../../home/dot_local/libexec/dotfiles/executable_appearance), [`executable_tmux-apply-theme`](../../home/dot_local/libexec/dotfiles/executable_tmux-apply-theme), [`home/dot_local/libexec/executable_claude-powerline-theme`](../../home/dot_local/libexec/executable_claude-powerline-theme).
- Tool-specific theme touchpoints: [`home/dot_config/nvim/lua/theme/init.lua`](../../home/dot_config/nvim/lua/theme/init.lua), [`home/dot_config/ghostty/config.tmpl`](../../home/dot_config/ghostty/config.tmpl), [`home/dot_config/tmux/tmux.conf`](../../home/dot_config/tmux/tmux.conf).
- Repo idiom references: ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md) (data in `.chezmoidata`, behavior in templates), ADR [0003](0003-mise-config-plus-lockfile.md) (intent vs. resolved truth split), ADR [0004](0004-claude-settings-management.md) (one-place registration with a rendering-time cross-check).
