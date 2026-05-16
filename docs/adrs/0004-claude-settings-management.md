---
status: "proposed"
date: 2026-05-16
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Hybrid declarative-plus-imperative management of `~/.claude/settings.json`

## Context and Problem Statement

`~/.claude/settings.json` is the runtime settings file that Claude Code reads on startup. In this repo it is *generated*, not committed: `home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl` re-fires whenever its hashed inputs change, and that wrapper invokes [`bin/sync-claude-settings`](../../bin/sync-claude-settings), which mutates the file via a sequence of `jq` invocations:

- `set_status_line` — points `statusLine.command` at the powerline shim.
- `set_feature_flags` — toggles like `effortLevel`, `alwaysThinkingEnabled`, `autoUpdatesChannel`.
- `set_permissions` — a ~250-entry global `permissions.allow` list of `Bash(...:*)`, `WebFetch(domain:…)`, `Read(...)`, `Skill(...)` patterns.
- `set_hooks` — wires the scripts under `home/dot_claude/hooks/` into `PreToolUse` / `PostToolUse` matchers.
- `set_plugins` — registers `extraKnownMarketplaces` and `enabledPlugins`.
- `set_default_model` / `merge_model_env_vars` — picks the default model and (when `chezmoi data .claude.use_bedrock` is true) resolves AWS Bedrock model IDs via a sibling `bin/resolve-bedrock-models` lookup before merging them into `.env`.
- `validate_settings` — `jq empty` and a "did we lose the keys Claude owns" check, restoring from `.bak` on failure.

The complementary file `~/.claude/settings.local.json` is **not** managed: it is Claude Code's own per-machine overlay (host-specific permissions, experimental flags, model overrides for one box). The runtime merges it on top of `settings.json` without any help from this repo.

The current model works, but exposes a recurring papercut documented in `docs/agents/claude-code.md` and surfaced in [#25](https://github.com/meaganewaller/dotfiles/issues/25): **anything requiring registration is a two-place edit**. Adding a hook script under `home/dot_claude/hooks/executable_<name>.sh` is silently inert until `set_hooks` is updated. Same shape for new permission patterns (`set_permissions`), new plugin marketplaces (`set_plugins`), and new feature flags. The wiring lives in shell + jq, where it does not diff cleanly in PR review and where the linkage between "script exists on disk" and "script actually fires" is hidden inside an `EOF` heredoc.

The decision to make: how should the managed pieces of `~/.claude/settings.json` be authored and merged, given that:

1. The bulk of the content is **static data** (permission patterns, hook matcher metadata, plugin IDs, feature flags) that should review as a diff.
2. A small portion is **runtime-resolved** (Bedrock model IDs depend on `aws` lookups via `bin/resolve-bedrock-models`) and cannot live in a static template alone.
3. `settings.local.json` MUST stay unmanaged — Claude Code's overlay semantics are the contract.

## Decision Drivers

- **One-place edits**: Adding a hook, a permission, or a plugin SHOULD be a single change in a reviewable file, not an edit-script-plus-edit-content pair.
- **Reviewability**: The intended shape of `~/.claude/settings.json` SHOULD be visible in PR diffs without having to mentally evaluate a shell script. Renovate-style automation (future) MUST be able to target stable file/field shapes.
- **Repo idiom**: Existing ADRs ([0002](0002-tmux-plugins-via-chezmoi-externals.md), [0003](0003-mise-config-plus-lockfile.md)) established a pattern of **structured data in `home/.chezmoidata/`, behavior in templates / scripts**. The claude settings story SHOULD extend that idiom, not invent a new one.
- **Runtime data still has a home**: Bedrock model resolution depends on an AWS lookup at apply time; a fully static template cannot express that. The design MUST keep a narrow imperative seam for runtime-only data.
- **Safety**: The current `validate_settings` step (JSON parse + required-key check, restoring from `.bak` on failure) is load-bearing for "did I just brick `claude` startup." The new design MUST preserve a validation step.
- **Layering with `settings.local.json`**: This repo MUST NOT write to or overwrite `settings.local.json`; the design defers to Claude Code's own overlay merge.

## Considered Options

1. **Status quo — imperative sync script only.** Keep all wiring in `bin/sync-claude-settings`'s shell + jq heredocs.
2. **Full declarative — `settings.json.tmpl` rendered by chezmoi.** Move every field into a template; encode the Bedrock branch via `chezmoi data` (forcing `aws` lookup at chezmoi-init time, persisted in `.chezmoi.toml`, refreshed manually).
3. **Hybrid — declarative shape from `.chezmoidata/` + small imperative overlay for runtime data.** Static lists (permissions, hook metadata, plugins, feature flags) live as YAML in `home/.chezmoidata/`; a `settings.json.tmpl` ranges over them to emit the merged shape; `bin/sync-claude-settings` shrinks to *only* the Bedrock branch, overlaying onto the rendered file after chezmoi writes it.
4. **Auto-discovery only — template scans `home/dot_claude/hooks/` directly.** Skip the YAML sidecar; the template iterates over hook files and infers matcher/phase from filename conventions.

## Decision Outcome

**Adopt option (3): hybrid.** The settings file is composed in two passes:

| Pass | Owner | Inputs | Output |
| --- | --- | --- | --- |
| 1. **Render shape** | chezmoi template | `home/.chezmoidata/claude-permissions.yaml`, `claude-hooks.yaml`, `claude-plugins.yaml`, `claude-feature-flags.yaml` | `~/.claude/settings.json` with everything except runtime model env vars |
| 2. **Overlay runtime data** | `bin/sync-claude-settings` (shrunk) | `chezmoi data .claude.use_bedrock`, `bin/resolve-bedrock-models` output | `~/.claude/settings.json` with Bedrock `.env` vars merged in (or stripped when disabled), followed by JSON validation |

Concretely:

1. **Static data lives in `home/.chezmoidata/`**, one file per concern so PR diffs are scoped:

   - `claude-permissions.yaml` — list of allow patterns under a `permissions.allow` key. Plain strings.
   - `claude-hooks.yaml` — array of `{ phase, matcher, script }` rows. The template emits `PreToolUse` / `PostToolUse` blocks grouped by phase and matcher. *"Script exists with a yaml row" replaces "script exists and is also wired in `set_hooks`."*
   - `claude-plugins.yaml` — `marketplaces` (id → source) and `enabled` (id → bool).
   - `claude-feature-flags.yaml` — flat map of top-level boolean / scalar fields (`alwaysThinkingEnabled`, `effortLevel`, etc.), plus an `env` sub-map for static env vars (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`, …).

2. **Shape lives in `home/dot_claude/settings.json.tmpl`** — a Go-template-rendered JSON file that ranges over the four datasets and emits a single canonical document. The template is the *one* place a reader looks to understand the JSON shape; the data files are the *one* place a reader looks to understand the actual values.

3. **Runtime overlay lives in `bin/sync-claude-settings`**, reduced to roughly:

   - If `chezmoi data .claude.use_bedrock` is true: resolve Bedrock model IDs, merge into `.env` and `.model`.
   - Else: strip the four Bedrock env vars and set `.model` to the chosen default (today: `opus[1m]`).
   - Run the existing `validate_settings` (parse + required-key check + `.bak` restore-on-failure).

   The script SHOULD NOT touch `permissions`, `hooks`, `extraKnownMarketplaces`, `enabledPlugins`, `statusLine`, or static feature flags. Those are the template's job.

4. **`run_onchange` wrapper hashes both inputs** — `home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl` MUST include hashes for the template AND every `.chezmoidata/claude-*.yaml` file AND the shrunk sync script, so any change to data, shape, or overlay re-fires the pipeline (mirroring the dual-hash pattern from ADR [0003](0003-mise-config-plus-lockfile.md)).

5. **`settings.local.json` stays out of scope** — chezmoi MUST NOT manage it. `docs/agents/claude-code.md` keeps its existing "not managed; deliberately left to the user / host" guidance. Claude Code's own runtime overlay merges it.

6. **Auto-discovery (option 4) is rejected as the default.** Filename conventions like `home/dot_claude/hooks/PreToolUse__Bash__guard-destructive.sh` were considered but pushed back on: the YAML sidecar surfaces phase + matcher *as data* (greppable, diffable, schema-able later), keeps hook filenames human-readable, and avoids encoding wiring in a path. A template MAY still cross-check that every `home/dot_claude/hooks/executable_*.sh` has a row in `claude-hooks.yaml` and fail rendering otherwise — that's a useful safety belt without making the path the schema.

### Consequences

- **Positive**: A new hook, permission, plugin, or feature flag is a single edit (YAML row) — no second file to remember. The "register the hook" step from `docs/agents/claude-code.md` collapses into "add the script + add the row."
- **Positive**: PR review of settings changes becomes a YAML diff instead of "read the new heredoc carefully." Renovate / Package Manager subagent workflows targeting `.chezmoidata/claude-*.yaml` become viable later if marketplace IDs or plugin sources need bumping.
- **Positive**: The repo idiom (structured data in `.chezmoidata/`, behavior in templates / thin scripts) holds for one more subsystem.
- **Positive**: `bin/sync-claude-settings` shrinks from ~500 lines to a focused Bedrock overlay + validator, easier to test and reason about.
- **Negative**: One more file type to learn — contributors authoring hooks now author *two* small things (script + YAML row) instead of one. Mitigated by the rendering-time cross-check.
- **Negative**: The chezmoi template is a JSON-emitting Go template, which is finicky (trailing commas, quoting). Real risk of "looks fine in the diff, doesn't parse at apply time" without good local testing. The post-render `validate_settings` step is the safety net; `chezmoi execute-template --file home/dot_claude/settings.json.tmpl | jq empty` SHOULD be part of the contributor flow.
- **Negative**: Two-pass composition means a tiny window where `~/.claude/settings.json` reflects the template but not yet the Bedrock overlay. Acceptable because the overlay step is fast and atomic via `${SETTINGS}.tmp && mv`; Claude Code is unlikely to be reading the file mid-apply.
- **Negative**: Migration is non-trivial — every existing entry in the shell heredocs must be moved into a YAML file with no loss of fidelity. Tracked as follow-up issues (see Confirmation).

### Confirmation

- After migration: a fresh `chezmoi apply` on a clean machine yields the same `~/.claude/settings.json` shape and content as the pre-migration imperative script (within ordering tolerances).
- A new hook script + YAML row, with **no** edits to `bin/sync-claude-settings`, results in a working hook after `chezmoi apply` (proves the two-place edit is gone).
- A new permission pattern, added only to `home/.chezmoidata/claude-permissions.yaml`, appears in `~/.claude/settings.json` after apply.
- `bin/sync-claude-settings` no longer references `set_permissions`, `set_hooks`, `set_plugins`, `set_status_line`, or `set_feature_flags`.
- `~/.claude/settings.local.json` is **never** written by anything in this repo (`grep -RIn 'settings.local.json' home/ bin/ .chezmoiscripts/` returns only documentation references).
- `chezmoi execute-template --file home/dot_claude/settings.json.tmpl | jq empty` succeeds in CI.
- A follow-up issue is filed to migrate `bin/sync-claude-settings` per this ADR; a second follow-up updates `docs/agents/claude-code.md` to reflect the new mental model (the existing "register in `set_hooks`" sentence becomes "add a row to `claude-hooks.yaml`").

## Rejected Options

- **(1) Status quo only** — Rejected as the long-term shape because it does not address the recurring two-place-edit problem the issue was filed about. Acceptable as a transitional state during migration.
- **(2) Full declarative with Bedrock pushed into `chezmoi data`** — Rejected because Bedrock model IDs change without warning (AWS regional rollouts, deprecations); resolving them at chezmoi-init time means stale data sits in `.chezmoi.toml` until a human manually re-runs the lookup. Keeping a thin imperative overlay for Bedrock means apply-time freshness without resurrecting the two-place-edit problem for the static surface.
- **(4) Auto-discovery from filename conventions** — Rejected as the default. Encoding wiring in filenames trades one form of hidden coupling (jq heredoc) for another (filename parser). The YAML sidecar is more honest about what the schema is and surfaces matcher/phase as reviewable data.

## More information

- Issue: [#25](https://github.com/meaganewaller/dotfiles/issues/25) — the prompt for this ADR.
- Current implementation: [`bin/sync-claude-settings`](../../bin/sync-claude-settings) and [`home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl`](../../home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl).
- Repo idiom reference: ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md) (data-in-`.chezmoidata`-template-emits-shape), ADR [0003](0003-mise-config-plus-lockfile.md) (dual-hash `run_onchange`, split intent vs. resolved truth).
- Settings split documentation: [`docs/agents/claude-code.md`](../agents/claude-code.md) (the "Settings split (managed vs. local)" section, which will be updated to point at this ADR once accepted).
