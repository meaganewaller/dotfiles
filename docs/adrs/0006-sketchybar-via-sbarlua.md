---
status: "accepted"
date: 2026-05-29
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Sketchybar configured in Lua via SbarLua

## Context and Problem Statement

The sketchybar menu bar (added in PR #67) was configured with a bash `sketchybarrc` plus a
`plugins/` directory of shell scripts:

- [`home/dot_config/sketchybar/executable_sketchybarrc`](../../home/dot_config/sketchybar/executable_sketchybarrc) — bash; sourced a shell color overlay and ran `sketchybar --add`/`--set` for each item.
- `home/dot_config/sketchybar/plugins/executable_battery.sh` and `executable_clock.sh` — one shell script per dynamic item, invoked by sketchybar via `script=` and re-spawned on every `update_freq` tick / event.
- [`home/dot_local/libexec/dotfiles/theme.d/executable_sketchybar`](../../home/dot_local/libexec/dotfiles/theme.d/executable_sketchybar) — the universal-theme applier (ADR [0005](0005-universal-theme-switcher.md)); wrote `$XDG_STATE_HOME/theme/sketchybar.sh` exporting `COLOR_*` env vars that the bash rcfile sourced.

Two papercuts:

1. **A subprocess per tick.** Each `battery`/`clock` item shells out to a script on every update — `pmset`, `grep`, `date`, string munging — re-paying interpreter + fork cost forever. The logic is also split across files in a second language from the bar definition.
2. **String-config friction.** Item configuration is positional `--set name key=value …` bash with manual escaping. There is no structure, no locals, no functions — adding an item means more brittle shell.

[SbarLua](https://github.com/FelixKratz/SbarLua) (by sketchybar's author) is the first-party Lua binding: a compiled `sketchybar.so` module that lets the rcfile be a single Lua program with item objects, `item:set{…}` calls, and **in-process Lua callbacks** for events instead of per-tick subprocesses.

The decision: should sketchybar move from bash to SbarLua, and — given this is a dotfiles repo whose whole point is reproducibility — how is SbarLua provisioned so a fresh machine works after one `chezmoi apply` without manual steps?

## Decision Drivers

- **Reproducible on every machine** — SbarLua is a compiled module, not a Homebrew formula. A fresh `chezmoi apply` MUST end with a working bar; no "now go clone and `make install`" README step.
- **Immutable pins** — third-party source pulled into the tree follows this repo's pin philosophy (ADRs [0002](0002-tmux-plugins-via-chezmoi-externals.md), [0003](0003-mise-config-plus-lockfile.md)): a fixed commit SHA, Renovate-bumped, not a floating branch.
- **One language for the bar** — bar layout and dynamic-item logic SHOULD live together in Lua; drop the `plugins/*.sh` subprocess-per-tick model.
- **Theme switcher stays intact** — the bar MUST keep participating in the universal `theme` switcher (ADR [0005](0005-universal-theme-switcher.md)) with no source-tree churn on switch. Only the overlay's *format* may change (shell → Lua).
- **ABI correctness** — the Lua interpreter that runs the rcfile must match the Lua the module is built against, or `require("sketchybar")` crashes.

## Considered Options

1. **Status quo** — keep bash rcfile + shell plugins.
2. **Lua config, manual SbarLua install** — rewrite in Lua but leave `make install` as a documented manual step.
3. **Lua config + SbarLua provisioned through Chezmoi (recommended)** — pin the SbarLua source as a Chezmoi external, build it with a `run_onchange` script, run the rcfile with brew's `lua`.

## Decision Outcome

**Adopt option (3).** Provisioning composes from existing repo idioms:

| Piece | Mechanism | Lives in |
| --- | --- | --- |
| **Interpreter** | brew `lua` (5.5.x) | `home/.chezmoidata/packages.yaml` |
| **Module source** | Chezmoi external, `git-repo` pinned to a commit SHA, cloned to `~/.local/share/sketchybar_lua/src` | `home/.chezmoiexternals/sketchybar-lua.toml.tmpl` |
| **Module build** | `run_onchange_after_` script: `make -C …/src install` → `~/.local/share/sketchybar_lua/sketchybar.so` | `home/.chezmoiscripts/run_onchange_after_install-sketchybar-lua.sh.tmpl` |
| **Bar config** | single Lua program (bar + defaults + item callbacks) | `home/dot_config/sketchybar/executable_sketchybarrc` |
| **Theme overlay** | Lua chunk that `return`s a color table | `$XDG_STATE_HOME/theme/sketchybar.lua` (runtime, untracked) |

Concretely:

1. **Interpreter = brew `lua`, not mise.** Sketchybar is launched by `launchd`/`brew services`, whose process environment does **not** reliably carry mise shims, so a mise-managed `lua` would leave the rcfile's `#!/usr/bin/env lua` shebang unresolved at GUI launch. brew installs `lua` onto the system PATH (`/opt/homebrew/bin`). This is a deliberate, documented exception to the global "tools via mise" rule, justified by the launch context. **ABI**: brew `lua` is `5.5.0`, which matches SbarLua's vendored `lua-5.5.0` (the module statically builds Lua but is loaded by the host interpreter, so the versions must agree) — so `require("sketchybar")` loads cleanly.

2. **SbarLua source is a pinned external.** `home/.chezmoiexternals/sketchybar-lua.toml.tmpl` is a `git-repo` external pinned to a commit SHA (Renovate `git-refs` custom manager bumps it, mirroring the tmux external). It is gated to `eq .chezmoi.os "darwin"`. Destination `~/.local/share/sketchybar_lua/src` is the build dir.

3. **Build runs after the source lands.** `run_onchange_after_install-sketchybar-lua.sh.tmpl` runs `make -C ~/.local/share/sketchybar_lua/src install`, which compiles and drops `sketchybar.so` into `~/.local/share/sketchybar_lua/`. The `_after_` prefix guarantees it runs once the external has been materialized. It hashes the external file so it **re-fires only when the pin bumps**, skips CI, and exits 0 (not 1) if the source dir is somehow absent so a partial apply never hard-fails.

4. **The rcfile is one Lua program.** It sets `package.cpath` to find the module, `require`s it, then declares the bar, item defaults, and items. `battery` and `clock` become Lua functions subscribed to events (`routine` for the periodic tick, plus `system_woke`/`power_source_change` for battery) — computed **in-process** via `os.date` and a single `io.popen("pmset")`, replacing the per-tick shell scripts. The script ends with `sbar.event_loop()`, required by SbarLua to keep the Lua process alive servicing callbacks. The `plugins/*.sh` files are deleted.

5. **Theme overlay becomes Lua.** The `theme.d/sketchybar` applier now writes `$XDG_STATE_HOME/theme/sketchybar.lua` — a chunk that `return`s `{ bar, item_bg, fg, accent, accent_alt }` as `0xAARRGGBB` strings — instead of a shell file exporting env vars. The rcfile `loadfile`s it and merges over baked-in catppuccin-mocha defaults, so a machine that never ran `theme` still gets a coherent palette. The applier still `sketchybar --reload`s. This is purely a format change; the ADR [0005](0005-universal-theme-switcher.md) contract (state-only, no source churn on switch) is unchanged, and `themes.yaml`'s `sketchybar:` palette tokens are untouched.

### Consequences

- **Positive**: No per-tick subprocesses — battery/clock update in-process. Bar layout and item logic are one structured Lua file instead of bash + N shell scripts.
- **Positive**: Fresh-machine reproducibility holds: external clone + `make install` + brew `lua` all happen inside `chezmoi apply`. No manual SbarLua step.
- **Positive**: The SbarLua pin gets Renovate update PRs like every other third-party dependency.
- **Negative**: A compile step now runs on first apply (and on pin bumps). It needs the Xcode Command Line Tools (`clang`/`make`); the build script degrades to a readable message rather than crashing apply if they're missing.
- **Negative**: A documented carve-out from the mise-first tooling rule (brew `lua`). The rationale (launchd PATH + ABI match) lives in this ADR so it is not mistaken for drift.
- **Negative**: Interpreter/module ABI coupling — if Renovate bumps SbarLua to a new vendored Lua major before brew's `lua` follows (or vice versa), `require` could break. Caught at `--reload` time; mitigation is to pin `lua` to a matching `lua@5.x` formula if they ever diverge.

### Confirmation

- Both `home/dot_config/sketchybar/executable_sketchybarrc` and a generated `sketchybar.lua` overlay parse under `luac -p` (Lua 5.5.0), and the overlay loads as a color table.
- After a fresh `chezmoi apply` on macOS: `~/.local/share/sketchybar_lua/sketchybar.so` exists, `sketchybar --reload` produces no `require`/load error, and the bar shows battery + clock.
- `theme catppuccin-latte` then `theme catppuccin-mocha` recolors the bar with no `git status` change in this repo.
- `git status` after a theme session shows nothing under `home/` (overlay is runtime state).

## More information

- SbarLua: <https://github.com/FelixKratz/SbarLua> (pinned in `home/.chezmoiexternals/sketchybar-lua.toml.tmpl`).
- Theme switcher this builds on: ADR [0005](0005-universal-theme-switcher.md).
- External + pin idiom: ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md); pin-and-Renovate idiom: ADR [0003](0003-mise-config-plus-lockfile.md).
- Touchpoints: [`executable_sketchybarrc`](../../home/dot_config/sketchybar/executable_sketchybarrc), [`theme.d/executable_sketchybar`](../../home/dot_local/libexec/dotfiles/theme.d/executable_sketchybar), [`run_onchange_after_install-sketchybar-lua.sh.tmpl`](../../home/.chezmoiscripts/run_onchange_after_install-sketchybar-lua.sh.tmpl).
