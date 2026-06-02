---
status: "accepted"
date: 2026-06-02
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Window management strategy: phased AeroSpace adoption alongside Loop

## Context and Problem Statement

Window arrangement on macOS has been **manual**, driven by [Loop](https://github.com/MrKai77/Loop) — a
radial/keyboard window-snapping app. Loop is installed (`/Applications/Loop.app`) as a Homebrew cask
(`loop`), but at the time of this decision it is **not in the source tree** — it is unmanaged drift
versus [`home/.chezmoidata/packages.yaml`](../../home/.chezmoidata/packages.yaml).

[AeroSpace](https://nikitabobko.github.io/AeroSpace/) (a tiling window manager built on virtual
workspaces rather than macOS Spaces) is the desired direction. But adopting a tiling WM the obvious
way — install it, let it tile everything — is exactly the failure mode that has stalled this before:
windows fly to positions I didn't choose, the manual arrangements I rely on disappear, and there's
no graceful way to "arrange this one thing by hand" mid-flow. Going all-in on tiling in a single step
trades one working setup for a broken-feeling one and a steep relearning cliff.

The problem: **how do we move toward AeroSpace tiling without ever dropping below "usable," and how
do AeroSpace and Loop divide responsibility while both are installed?** There must be a clear
separation of concerns and an explicit, falsifiable condition for when Loop is no longer needed —
rather than two window managers fighting over the same windows indefinitely.

## Decision Drivers

- **Never drop below usable** — after *every* change, the desktop must be at least as workable as
  before. No "endure the chaos until it's tuned" period.
- **Always an escape hatch** — at any phase, manual arrangement (Loop) and a config reload must remain
  one keystroke away, so a bad layout is never a trap.
- **No muscle-memory cliff** — new keybindings are introduced a few at a time and earned through use,
  not dumped wholesale.
- **Truth in the tree** — both tools are durable config and belong under `home/`; an installed-but-
  unmanaged Loop contradicts the repo's core principle and must be brought in.
- **Reversibility** — each phase is its own PR, so any phase can be reverted in isolation without
  unwinding the whole adoption.
- **Clear ownership** — at any moment it must be obvious which tool is responsible for a given window,
  so the two never silently contend.

## Considered Options

1. **Status quo** — Loop only, all arrangement manual. No workspace model, no tiling.
2. **Rip-and-replace** — install AeroSpace, enable tiling globally, remove Loop in one PR.
3. **Phased AeroSpace adoption coexisting with Loop (recommended)** — introduce AeroSpace
   float-first, expand tiling one workspace at a time across numbered phases, keep Loop as the manual
   arranger for floating windows, and retire Loop only once tiling covers enough of the workflow.

## Decision Outcome

**Adopt option (3).** AeroSpace and Loop coexist with a deliberate division of labor, and AeroSpace's
tiling surface grows phase by phase. The two tools do not conflict because **AeroSpace's tiling and
Loop's snapping never apply to the same window at the same time**:

| Concern | Owner | Notes |
| --- | --- | --- |
| Virtual **workspaces** + navigation (`alt+1..9`, move-to-workspace, back-and-forth) | **AeroSpace** | New from Phase 1; replaces nothing — macOS has no equivalent keyboard model in use here. |
| **Auto-tiling** of windows within a workspace | **AeroSpace** | Starts at *zero* (everything floats) and grows one workspace at a time, Phases 2+. |
| **Manual snap/resize** of *floating* windows (halves, quarters, center, custom) | **Loop** | Unchanged. In early phases AeroSpace floats every window, so Loop stays fully in charge. |
| App→workspace placement | **AeroSpace** | Phase 4. |
| Menu-bar workspace indicators | **AeroSpace → sketchybar** | Phase 5, via the existing bar (ADR [0006](0006-sketchybar-via-sbarlua.md)). |

The contract that keeps them out of each other's way: **Loop only ever acts on floating windows.**
A window AeroSpace is tiling is, by definition, not floating, so Loop's snap commands are a no-op
there. As tiling expands across phases, the set of floating windows (Loop's domain) shrinks
monotonically — Loop's role *naturally* contracts rather than being forcibly removed.

### Adoption phases

Each phase is a standalone PR. AeroSpace config lives in
[`home/dot_config/aerospace/aerospace.toml`](../../home/dot_config/aerospace/aerospace.toml) (target
`~/.config/aerospace/aerospace.toml`); AeroSpace hot-reloads on save, so no reload script is needed.
Phase boundaries are commented inline in that file so each phase is an obvious diff.

| Phase | Scope | Loop's role | Status |
| --- | --- | --- | --- |
| **1** | Calm baseline. Install cask; **float everything** via a catch-all `on-window-detected`. Only new powers: workspace navigation (`alt+1..9`, `alt+shift+1..9`, `alt+tab`) + `alt+shift+c` reload. Screen looks like plain macOS. | **Full** — every window floats, Loop arranges all of them. | In effect |
| **2** | Tile **one** workspace (e.g. terminals); everything else floats. Add focus movement (`alt+h/j/k/l`) in that workspace. | Manual arrangement everywhere *except* the one tiled workspace. | Planned |
| **3** | Layout controls: tiles ↔ accordion toggle, move within layout, gaps, `alt+f` fullscreen. Tiling stays opt-in per workspace. | Shrinks to the still-floating workspaces. | Planned |
| **4** | `on-window-detected` rules: apps auto-land on their workspace. | Floating windows only. | Planned |
| **5** | sketchybar workspace indicators via `exec-on-workspace-change`, themed through the ADR [0005](0005-universal-theme-switcher.md) overlay. | Unchanged. | Planned |
| **6** | Modes (resize, service), optional disable of macOS Spaces animation in `run_onchange_configure-macos-preferences.sh.tmpl`. | Whatever floating surface remains. | Planned |

### Bringing Loop into the tree

As a direct consequence of declaring Loop a managed, coexisting tool, the `loop` cask is added to
[`home/.chezmoidata/packages.yaml`](../../home/.chezmoidata/packages.yaml) under the Window Management
group (next to `nikitabobko/tap/aerospace`), resolving the current drift. Loop's own settings remain
managed by Loop for now; if they prove worth pinning, that is a follow-up, not part of this decision.

### Consequences

- **Positive**: The desktop is usable after every phase — no chaos window. A bad AeroSpace layout is
  always escapable by floating the window and reaching for Loop, or `alt+shift+c` to reload.
- **Positive**: Keybindings are learned incrementally; no relearning cliff.
- **Positive**: Clear, non-overlapping ownership (tiled = AeroSpace, floating = Loop) means the two
  never contend for the same window.
- **Positive**: Loop's drift is resolved; both window tools are now truth-in-tree.
- **Negative**: Two window-management tools run simultaneously for an extended, open-ended period —
  more moving parts, two sets of keybindings to keep non-overlapping (AeroSpace on `alt`, Loop on its
  own trigger).
- **Negative**: The end state is deliberately undated — Loop lingers until the revisit condition below
  is met, which may be a long time or never.

### Confirmation

- After `chezmoi apply` on macOS: `~/.config/aerospace/aerospace.toml` exists, AeroSpace launches,
  and `alt+1..9` switches workspaces while no window auto-moves (Phase 1 float-everything holds).
- Loop's snap shortcuts still arrange floating windows with AeroSpace running.
- `loop` appears in `packages.yaml` and `brew bundle` no longer reports it as untracked.
- AeroSpace and Loop keybindings do not collide (AeroSpace uses `alt`; Loop uses its configured
  trigger key).

## Revisit when

Reopen this ADR and decide whether to **phase Loop out** when any of these holds:

- Tiling has expanded (through Phases 2–4) to the point where **most workspaces tile by default** and
  the set of routinely-floating windows is small enough that Loop is rarely invoked.
- AeroSpace's own float-management (manual float toggle + move/resize/center commands and a resize
  mode from Phase 6) covers the manual-arrangement cases Loop is currently relied on for.
- Maintaining two tools' keybindings without overlap becomes more friction than Loop's remaining value.

At that point the decision is whether to **go all-in on tiled workspaces** — remove the `loop` cask,
drop Loop from `packages.yaml`, and let AeroSpace own floating-window arrangement too — recording the
outcome as a superseding ADR. Until then, coexistence stands.

## More information

- AeroSpace: <https://nikitabobko.github.io/AeroSpace/>; pinned as the `nikitabobko/tap/aerospace`
  cask in [`home/.chezmoidata/packages.yaml`](../../home/.chezmoidata/packages.yaml).
- Loop: <https://github.com/MrKai77/Loop> (`loop` cask).
- Phase config: [`home/dot_config/aerospace/aerospace.toml`](../../home/dot_config/aerospace/aerospace.toml).
- Builds on: sketchybar (ADR [0006](0006-sketchybar-via-sbarlua.md)) for Phase 5, the universal theme
  switcher (ADR [0005](0005-universal-theme-switcher.md)) for indicator coloring.
