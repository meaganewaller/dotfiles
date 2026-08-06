---
status: "accepted"
date: 2026-08-05
decision-makers: [Meagan Waller]
consulted: []
informed: []
supersedes: []
---

# The flat Claude Code settings surface becomes data, rendered by a modify_ template

## Context and Problem Statement

ADR [0008](0008-claude-config-two-managers.md) split Claude Code config by *writer*: `bin/sync-claude-settings` owned the flat `settings.json` surface (statusLine, permissions, feature flags, hooks, model) with imperative `jq`, and `bin/sync-claude-extras` declared marketplaces/plugins/MCP servers as data realized through the `claude` CLI. It explicitly accepted one cost:

> **Negative / accepted tradeoff**: The #25 two-place-edit problem **remains for hooks and permissions** … Moving hooks/permissions to declarative data later is still possible **without** a `settings.json` template … and can be its own ADR if the pain recurs.

The pain recurred, and ADR [0010](0010-multi-account-claude-code.md) made it worse in a way neither ADR anticipated. 0010 introduced per-account directories and, with them, `home/private_dot_claude-{account}/modify_private_settings.json.tmpl` — a chezmoi `modify_` script that *also* writes `settings.json`. The result was **two writers on the same surface**, contradicting 0008's whole organizing principle:

| Key | `bin/sync-claude-settings` wrote | the `modify_` script wrote | on disk |
| --- | --- | --- | --- |
| `statusLine.command` | `$HOME/.local/libexec/claude-powerline-theme` | `~/.local/bin/claude-code-statusline` | the `modify_` value |
| `env` | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | three vars incl. the same one | union |
| `hooks` | nothing (0010 dropped `set_hooks`) | three hook groups | the `modify_` value |
| `permissions`, feature flags, `model` | all of it | nothing | the script's value |

The `modify_` script ran last, so `set_status_line` had been dead code for some time — and the value it wrote pointed at `claude-powerline-theme`, which resolves `$HOME/.claude/powerline`, a path that stopped existing when 0010 removed the single `~/.claude/` directory. Nobody noticed because the key it wrote was always overwritten.

Meanwhile the two-place edit stayed exactly as 0008 described: a new permission meant editing a ~250-line `jq` heredoc; a new hook meant editing a second heredoc in a different file than the one the hook shipped in.

The decision: now that a per-account `modify_` template exists and is *already* the effective single writer, should the flat surface become declarative data rendered through it?

## Decision Drivers

- **One writer per key.** The contention above is a bug, not a design. Exactly one thing SHOULD write each `settings.json` key.
- **One-place edits.** Adding a permission, hook, env var, or feature flag SHOULD be one row in a data file — 0008's deferred goal, and issue [#25](https://github.com/meaganewaller/dotfiles/issues/25).
- **Avoid the fragility that sank 0004.** ADR 0004 planned a `settings.json.tmpl` and was rejected partly for "JSON-emitting Go template … trailing commas, quoting … renders fine, doesn't parse." Any new design MUST NOT hand-author JSON in a Go template.
- **Preserve Claude-Code-owned keys.** `theme`, `extraKnownMarketplaces`, `enabledPlugins`, and anything else we do not declare MUST survive a re-render untouched.
- **Deletion MUST work.** Removing a permission or hook from the data MUST remove it from the file; an additive-only merge that can never delete is not declarative.
- **Runtime data still has a home.** Bedrock model IDs come from an `aws` lookup at apply time and cannot live in a static file (0004 and 0008 both made this point).
- **`settings.local.json` stays unmanaged.** Unchanged from 0004/0008.

## Considered Options

1. **Status quo** — two writers, hand-maintained `jq` heredocs, dead `set_status_line`.
2. **Resolve the conflict only** — delete `set_status_line`, leave the heredocs. Fixes the bug, keeps the two-place edit.
3. **0004's plan, revived** — a standalone `home/dot_claude/settings.json.tmpl` rendering everything.
4. **Data + the `modify_` template that already exists** — move the flat surface into `home/.chezmoidata/claude*.yaml`, render it per account through a shared `.chezmoitemplates` partial invoked from each account's `modify_private_settings.json.tmpl`, and shrink `bin/sync-claude-settings` to the Bedrock overlay.

## Decision Outcome

**Adopt option (4).** This **extends** ADR 0008 rather than superseding it: the two-manager split by writer stands, and `bin/sync-claude-extras` is untouched. What changes is *how the flat manager authors its half* — and that the flat manager is now the `modify_` template rather than a `jq` script.

| Manager | Owns | Mechanism | Input |
| --- | --- | --- | --- |
| `modify_private_settings.json.tmpl` (per account) | `statusLine`, `permissions`, `hooks`, feature flags, `env`, `model` | renders `toPrettyJson`, then `jq '. * $desired'` onto the current file | `home/.chezmoidata/claude.yaml` + `claude-permissions.yaml` |
| `bin/sync-claude-settings` | Bedrock `.env` model IDs + `.model` | imperative `jq`, `run_onchange_after_*` | `chezmoi data .claude.use_bedrock`, `bin/resolve-bedrock-models` |
| `bin/sync-claude-extras` | `extraKnownMarketplaces`, `enabledPlugins`, `mcpServers` | drives the `claude` CLI | `claude.yaml` + machine-local extras — **unchanged by this ADR** |

Concretely:

1. **`home/.chezmoidata/claude.yaml` gains `settings`, `env`, and `hooks` per scope**, alongside the existing `marketplaces`/`plugins`/`mcpServers`. `claudeData.shared` applies to every account; `claudeData.{account}` layers on top. Maps and scalars override; the permissions allow list and hooks concatenate.

2. **`home/.chezmoidata/claude-permissions.yaml` holds `permissions.defaultMode` and the 246-entry allow list.** It is a separate file purely for diff hygiene — chezmoi deep-merges every file in `.chezmoidata/`, so its keys land under the same `claudeData.shared`.

3. **`home/.chezmoitemplates/claude-settings` renders one account's desired JSON.** It is the answer to 0004's fragility objection: it builds a `dict` and pipes it through `toPrettyJson`. **No JSON is hand-authored in template syntax**, so the trailing-comma/quoting failure mode 0004 feared cannot occur. Two placeholders expand at render time, because `.chezmoidata` files are plain YAML and cannot themselves be templates:
   - `$HOME` → the real home directory (needed because Claude Code does *not* shell-expand permission patterns)
   - `$CLAUDE_DIR` → `~/.claude-{account}`

   All lookups go through `index`, not field access: chezmoi renders with `missingkey=error`, so every surface stays optional per account.

4. **Merge semantics are jq's `*`, and they are load-bearing.** It recurses into objects but replaces arrays wholesale. That is exactly the contract wanted: undeclared keys (`theme`, the CLI-owned plugin keys) survive, while dropping a permission or a hook from the data removes it from the file. No `del()` special-casing is needed.

5. **`bin/sync-claude-settings` shrinks from ~500 lines to the Bedrock overlay.** It is wired as `run_onchange_after_*` so it lands *after* the file pass — its `.model` must win over the template's declared default. It writes through a temp file and validates before `mv`, so a failed overlay is a no-op rather than a truncated `settings.json`; the old `.bak`-and-restore dance is gone with it.

6. **`set_status_line` is deleted and the conflict resolved in favor of what was actually running**: `~/.local/bin/claude-code-statusline`. `claude-powerline-theme` still ships and still reads the stale `$HOME/.claude/powerline` path; nothing references it from settings now. Retiring it is left to a separate change.

7. **Scope placement preserves behavior exactly.** What the old script applied to *all* accounts moved to `shared`; what only the personal `modify_` script applied moved to `personal`. Verified: rendering over each live `settings.json` reproduces the same 246-entry permission set and byte-identical values for every other key.

### Consequences

- **Positive**: One writer per key. The statusLine contention is gone, and with it a class of "the config I edited isn't the config that runs" bugs.
- **Positive**: Issue #25 is closed for the whole surface. A new permission is one row in `claude-permissions.yaml`; a new hook is a script plus one row in `claude.yaml`. No heredoc, no second file to remember.
- **Positive**: Removing a declared item now actually removes it, which the additive `jq` merge never did.
- **Positive**: Permissions are sorted and deduped at render time, so the list stops drifting out of alphabetical order by hand.
- **Positive**: `bin/sync-claude-settings` is small enough to hold in your head and its failure mode is a no-op.
- **Negative / accepted**: Hook commands are now absolute paths baked in at render time rather than `~`/`$HOME` resolved by the shell at hook-execution time. Same behavior, more explicit, but the rendered file is more machine-specific than before.
- **Negative / accepted**: `model` is declared in data, so every `chezmoi apply` resets an in-app `/model` choice. This is pre-existing behavior (the old script force-set it too), now visible as a documented data row that can simply be deleted.
- **Negative**: The `.chezmoidata` → `.chezmoitemplates` → `modify_` chain is one more indirection than a single script. Mitigated by the ownership table above and `docs/agents/claude-code.md`.
- **Negative**: `$HOME` / `$CLAUDE_DIR` are a small bespoke placeholder convention, needed only because chezmoi rejects `.chezmoidata/*.yaml.tmpl` (verified: "`.tmpl`: unknown format").

### Confirmation

- Rendering each account's `modify_` template over its live `settings.json` yields the identical 246-entry permission *set* and byte-identical values for every non-hook key — the migration changed ordering and hook path expansion only.
- `bin/sync-claude-settings` contains no `set_permissions` / `set_feature_flags` / `set_status_line` / `set_hooks` / `set_default_model` (asserted by `test/sync-claude-settings.bats`).
- `test/claude-settings-template.bats` covers: shared-vs-account layering, `$HOME`/`$CLAUDE_DIR` expansion, sorted+deduped permissions, per-account hook isolation, preservation of Claude-Code-owned keys, removal of undeclared permissions/hooks, idempotence, and graceful handling of an unparseable current file.
- `test/sync-claude-settings.bats` covers both Bedrock branches with stubbed `chezmoi`/`resolve-bedrock-models`, the after-script ordering requirement, and no-op-on-failure.
- A second `chezmoi apply` produces an empty diff.
- `~/.claude*/settings.local.json` is still never written by anything in this repo.

## Rejected Options

- **(1) Status quo** — Rejected. Two writers on one surface, with a dead branch pointing at a path that no longer exists.
- **(2) Resolve the conflict only** — Rejected. Fixes the bug but banks none of the value; the two-place edit was already deferred once in 0008 and kept costing.
- **(3) 0004's standalone `settings.json.tmpl`** — Rejected, but for a *narrower* reason than 0008 gave. 0008 rejected the whole idea partly on JSON-in-Go-template fragility; `toPrettyJson` removes that objection entirely. What remains is that a standalone `settings.json.tmpl` would be a **third** writer competing with the `modify_` script and would *replace* the file rather than merge onto it, destroying `theme` and the CLI-owned plugin keys. The `modify_` script already receives current contents on stdin, which is precisely the seam this needs. 0004's instinct was right; it just predated the mechanism that makes it safe.

## More information

- Extends ADR [0008](0008-claude-config-two-managers.md) (two managers split by writer) — the split stands; only the flat manager's authoring changes.
- Resolves the tradeoff 0008 explicitly deferred, and vindicates the "declarative intent in `.chezmoidata/`" half of superseded ADR [0004](0004-claude-settings-management.md).
- Interacts with ADR [0010](0010-multi-account-claude-code.md), which introduced the `modify_` templates that created the two-writer conflict.
- Issue: [#25](https://github.com/meaganewaller/dotfiles/issues/25) — now closed for hooks and permissions, not just plugins.
- Repo idiom: ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md) (data in `.chezmoidata`, behavior in templates) and ADR [0003](0003-mise-config-plus-lockfile.md) (hash-gated `run_onchange`).
- Implementation: [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml), [`home/.chezmoidata/claude-permissions.yaml`](../../home/.chezmoidata/claude-permissions.yaml), [`home/.chezmoitemplates/claude-settings`](../../home/.chezmoitemplates/claude-settings), [`bin/sync-claude-settings`](../../bin/sync-claude-settings).
