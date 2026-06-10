---
status: "accepted"
date: 2026-06-10
decision-makers: [Meagan Waller]
consulted: []
informed: []
supersedes: [0004]
---

# Two managers for Claude Code config: settings (imperative) vs. extras (CLI-reconciled)

## Context and Problem Statement

This repo generates `~/.claude/settings.json` rather than committing it: `home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl` re-fires on hashed-input change and invokes [`bin/sync-claude-settings`](../../bin/sync-claude-settings), which mutates the file with a sequence of `jq` calls. ADR [0004](0004-claude-settings-management.md) (proposed, never implemented) planned to move the *static* parts of that file — permissions, hook metadata, **plugin marketplaces and enabled plugins**, feature flags — into `home/.chezmoidata/claude-*.yaml` rendered by a single `home/dot_claude/settings.json.tmpl`, shrinking the sync script to a Bedrock-only overlay.

A spike implementing 0004 surfaced a distinction 0004 missed: **`~/.claude/settings.json` is not one surface, it is two**, with two different *writers*.

1. **The flat surface this repo solely owns.** `statusLine`, `permissions.allow`, `hooks`, feature flags (`effortLevel`, `alwaysThinkingEnabled`, …), and `model`. Nothing else writes these. We can author them however we like — the only reader is Claude Code at startup.

2. **The surface the `claude` CLI owns and rewrites.** `extraKnownMarketplaces`, `enabledPlugins`, and `mcpServers` are written by `claude plugin marketplace add`, `claude plugin install`, and `claude mcp add`. The CLI re-serializes these keys (its own ordering, its own nested shape, scope bookkeeping like `managed` vs `user`) whenever a human runs a plugin or MCP command. Any value we hand-write into them with `jq` is **in contention with the CLI** — the next `claude plugin …` invocation can reshape or drop it, and our idempotence checks drift against the CLI's serialization.

0004's plan rendered surface (2) from a template — i.e. it would keep *writing keys the CLI considers its own*, just from a prettier source. That does not resolve the contention; it relocates it. The real problem is **ownership**, not authoring format.

The decision: how should this repo manage Claude Code config given that one slice of `settings.json` is ours to write freely and another slice has the `claude` CLI as its rightful single writer?

## Decision Drivers

- **Respect the single writer.** For `extraKnownMarketplaces` / `enabledPlugins` / `mcpServers`, the `claude` CLI is the source of truth at runtime. The repo SHOULD declare *intent* and let the CLI realize it, not race the CLI for the file.
- **Declarative intent, reviewable diffs.** Which marketplaces, plugins, and MCP servers a machine should have SHOULD live as data in a diffable file, not buried in a jq heredoc.
- **Public/private split.** Public plugin/marketplace IDs SHOULD be committed; private or machine-specific MCP servers (internal URLs, tokens) MUST stay machine-local and out of the public tree.
- **Additive and safe.** Reconciliation MUST be idempotent and additive by default — never remove a human's installed extras without an explicit opt-in — and a single failing item (network, auth) MUST NOT abort `chezmoi apply`.
- **Keep the flat surface simple.** Permissions/hooks/flags/model have exactly one writer (this repo). The cost of 0004's JSON-emitting Go template (trailing-comma/quoting fragility, "renders fine, doesn't parse") is not worth paying for a surface that an imperative `jq` script already handles safely with a post-write `validate_settings`.
- **Runtime data still has a home.** Bedrock model IDs depend on an `aws` lookup at apply time and cannot live in a static file; the design MUST keep a narrow imperative seam for that.
- **`settings.local.json` stays unmanaged.** Claude Code's per-machine overlay is its contract; this repo MUST NOT write it.

## Considered Options

1. **0004 as written — render everything (including plugins) from `settings.json.tmpl`.**
2. **Status quo — keep `set_plugins` poking `enabledPlugins`/`extraKnownMarketplaces` with jq.**
3. **Two managers — split by writer.** The flat surface stays imperative in `bin/sync-claude-settings`; the CLI-owned surface moves to a declarative dataset (`home/.chezmoidata/claude.yaml` + machine-local extras) reconciled through the `claude` CLI by a new `bin/sync-claude-extras`.

## Decision Outcome

**Adopt option (3): two managers, split by who owns the bytes at runtime.** This **supersedes ADR 0004.**

| Manager | Owns | Mechanism | Input |
| --- | --- | --- | --- |
| `bin/sync-claude-settings` | `statusLine`, `permissions.allow`, `hooks`, feature flags, `model` (+ Bedrock `env` overlay) | imperative `jq`, in-place merge, then `validate_settings` | the script itself; `chezmoi data .claude.use_bedrock`; `bin/resolve-bedrock-models` |
| `bin/sync-claude-extras` | `extraKnownMarketplaces`, `enabledPlugins`, `mcpServers` | drives the `claude` CLI (the real single writer); never edits `settings.json` directly | `home/.chezmoidata/claude.yaml` (public) + `[data.claudeExternalExtra]` (machine-local) |

Concretely:

1. **`bin/sync-claude-settings` drops `set_plugins` entirely.** It no longer touches `extraKnownMarketplaces` or `enabledPlugins`. It keeps `set_status_line`, `set_feature_flags`, `set_permissions`, `set_hooks`, and the model logic. Its hook wiring is merge-based (remove the repo-owned group(s), re-append canonical group(s)) so plugin- or CLI-contributed hook groups survive a re-sync.

2. **`bin/sync-claude-extras` reconciles the CLI-owned surface.** It reads declared marketplaces / plugins / MCP servers from `home/.chezmoidata/claude.yaml` (public) merged with machine-local `[data.claudeExternalExtra]`, then for each missing item runs the corresponding `claude` command. It is **idempotent and additive**: already-present items are reported `ok`; items installed but not declared are reported as `drift` and only removed under `--prune`; `managed`/project-scope items are never pruned. `--check` is a dry run. A failing `claude` call logs a warning and continues.

3. **A global ad-hoc-installer guard** lives at `home/dot_local/libexec/executable_block-adhoc-installers` and is wired as a `PreToolUse`/`Bash` hook by `set_hooks`. It denies `npx`/`bunx`/`uvx`/`pipx`/`pip install`/`npm -g`/`gem|brew|cargo|go install`/… and redirects to the `/install` skill, so tools stay captured in mise and the dotfiles. It is the **enforcement teeth** for the "use mise exclusively" rule already stated in `home/dot_claude/CLAUDE.md`. A human escape hatch (`CLAUDE_ALLOW_ADHOC_INSTALL=1`) exists; an agent cannot set it for itself.

4. **Bedrock support is a runtime overlay.** `home/.chezmoi.toml.tmpl` prompts `use_bedrock` once and persists it under `[data.claude]`. When true, `bin/sync-claude-settings` calls `bin/resolve-bedrock-models` (which queries `aws bedrock list-foundation-models`, picks the latest active cross-region inference profile per tier, and caches the result for 24h) and merges the IDs into `.env` + `.model`; when false, the Bedrock env vars are stripped and `.model` is set to the Anthropic-direct default.

5. **`run_onchange` wrappers hash their inputs.** `run_onchange_sync-claude-settings.sh.tmpl` hashes the sync script (and records `use_bedrock`); `run_onchange_sync-claude-extras.sh.tmpl` hashes the reconciler, the public `claude.yaml`, and the machine-local extras, so any change to script or declared data re-fires the relevant pipeline (the dual/triple-hash idiom from ADR [0003](0003-mise-config-plus-lockfile.md)).

6. **`settings.local.json` stays out of scope** — neither manager writes it.

### Consequences

- **Positive**: Plugins, marketplaces, and MCP servers are now declared in one diffable file (`claude.yaml`) and realized by their rightful owner (the `claude` CLI). No more racing the CLI's serialization; no more drift between our jq and its rewrites.
- **Positive**: Adding a plugin/marketplace is a one-line edit to `claude.yaml` (the #25 two-place-edit problem is solved *for the CLI-owned surface*).
- **Positive**: Private MCP servers have a clean machine-local home (`[data.claudeExternalExtra]`) and never leak into the public tree.
- **Positive**: The flat surface keeps the simple, well-tested imperative script + `validate_settings` safety net — no JSON-emitting Go template to get wrong.
- **Positive**: The install policy in `CLAUDE.md` gains runtime enforcement instead of being advisory.
- **Negative / accepted tradeoff**: The #25 two-place-edit problem **remains for hooks and permissions** — a new hook is still a script *plus* a row in `set_hooks`, a new permission still edits `set_permissions`. This ADR judges that acceptable: those surfaces have one writer and change rarely, and 0004's template cure carried real fragility. Moving hooks/permissions to declarative data later is still possible **without** a `settings.json` template (e.g. a `claude-hooks.yaml` the imperative script ranges over) and can be its own ADR if the pain recurs.
- **Negative**: Two managers and two `run_onchange` wrappers are more moving parts than one script. Mitigated by clear ownership (the table above) and `docs/agents/claude-code.md`.
- **Negative**: `bin/sync-claude-extras` depends on the `claude` CLI and network/auth. Mitigated: missing `claude` skips cleanly, per-item failures warn and continue, `--check` previews.

### Confirmation

- `bin/sync-claude-settings` no longer references `set_plugins`, `extraKnownMarketplaces`, or `enabledPlugins` (`grep` is clean).
- A fresh `chezmoi apply` wires all four repo hooks (`check-secrets`, `guard-destructive`, `block-adhoc-installers`, `migration-reminder`) into `settings.json`, and re-running is idempotent and preserves foreign hook groups (covered by `test/sync-claude-settings.bats`).
- Adding a plugin ID to `home/.chezmoidata/claude.yaml` and running `bin/sync-claude-extras --check` reports it as a would-add; a real run installs it via `claude plugin install`.
- `block-adhoc-installers` denies the blocked installer matrix and allows `mise install` / `brew reinstall` / non-install subcommands (covered by `test/block-adhoc-installers.bats`).
- `bin/resolve-bedrock-models` returns the latest active profile per tier from sample input and degrades gracefully when `aws` is absent or the call fails (covered by `test/resolve-bedrock-models.bats`).
- `~/.claude/settings.local.json` is never written by anything in this repo.

## Rejected Options

- **(1) 0004 as written** — Rejected. Rendering `enabledPlugins`/`extraKnownMarketplaces` from a template still writes CLI-owned keys, so it relocates the contention with the `claude` CLI rather than removing it; it also imports the JSON-Go-template fragility 0004 itself flagged. The good part of 0004 — declarative intent in `.chezmoidata/` — is kept, but realized through the CLI, not a settings template.
- **(2) Status quo** — Rejected. `set_plugins` poking the CLI-owned keys is exactly the drift this ADR removes.

## More information

- Supersedes ADR [0004](0004-claude-settings-management.md) (Claude settings management, proposed).
- Origin: a spike on branch `feat/add-claude-data-to-chezmoi`, stashed and reimplemented per this ADR.
- Issue: [#25](https://github.com/meaganewaller/dotfiles/issues/25) — the two-place-edit pain that prompted 0004; this ADR resolves it for the CLI-owned surface and consciously defers it for hooks/permissions.
- Repo idiom: ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md) (data in `.chezmoidata`, behavior in templates/scripts) and ADR [0003](0003-mise-config-plus-lockfile.md) (hash-gated `run_onchange`, split intent vs. resolved truth).
- Implementation: [`bin/sync-claude-settings`](../../bin/sync-claude-settings), [`bin/sync-claude-extras`](../../bin/sync-claude-extras), [`bin/resolve-bedrock-models`](../../bin/resolve-bedrock-models), [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml), [`home/dot_local/libexec/executable_block-adhoc-installers`](../../home/dot_local/libexec/executable_block-adhoc-installers).
- Operator-facing docs: [`docs/agents/claude-code.md`](../agents/claude-code.md).
