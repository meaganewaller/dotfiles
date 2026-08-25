---
status: "accepted"
date: 2026-08-05
decision-makers: [Meagan Waller]
consulted: []
informed: []
supersedes: []
---

# Multi-account Claude Code support: personal, work, and beyond

## Context and Problem Statement

Claude Code on macOS stores all configuration in `~/.claude/` — a single directory shared across the CLI. When a user has multiple Claude accounts (personal, work, etc.) on one machine, they face a choice:

1. **One account per machine** — Use different machines or VMs for different accounts (friction, waste).
2. **Share one account across roles** — Plugins, settings, and MCP servers are global (confusion, security risk).
3. **Manual switching** — Delete/recreate `~/.claude/` by hand between accounts (error-prone).

This repo deployed Claude Code to a single `~/.claude/` directory via chezmoi, with `bin/sync-claude-settings` and `bin/sync-claude-extras` managing configuration. This worked for single-account users but did not support multiple concurrent accounts.

## Decision Drivers

- **Separate accounts on one machine.** A user with personal and work Claude accounts should be able to use both without friction or manual switching.
- **Isolated configuration per account.** Plugins, settings, MCP servers, and hooks SHOULD be account-specific so personal work doesn't leak into work workspace (and vice versa).
- **Shared config where possible.** Marketplaces and plugins that are useful to both accounts (e.g., `anthropic-agent-skills`, `superpowers`) SHOULD be declared once and applied to all.
- **Shell-enforced clarity.** Users SHOULD NOT be able to accidentally run `claude` and hit the wrong account; CLI aliases SHOULD force explicit choice (`claude-personal` vs. `claude-work`).
- **Chezmoi as source of truth.** Account directories and their initial content SHOULD be deployed via chezmoi (no manual directory creation); account-specific overrides SHOULD live in `home/.chezmoidata/claude.yaml` and chezmoi.toml.
- **Sync scripts scale to N accounts.** `bin/sync-claude-settings` and `bin/sync-claude-extras` SHOULD detect and configure all account directories, not hardcode specific names.

## Considered Options

1. **Single `~/.claude/` for all accounts.** Keep the status quo; users manage switching manually. Burden remains on the user.
2. **Multiple `~/.claude*` directories with hardcoded scripts.** Create `bin/sync-for-personal.sh` and `bin/sync-for-work.sh`, duplicating logic. Doesn't scale to 3+ accounts; violates DRY.
3. **Account-aware sync scripts with dynamic detection.** Scripts detect all `~/.claude-{account}/` directories and apply config to each, merging shared + account-specific data. Clean, extensible.

## Decision Outcome

**Adopt option (3): account-aware sync scripts with dynamic account detection.**

### Structure

1. **Account directories.** Replace single `~/.claude/` with:
   - `~/.claude-personal/` — personal account
   - `~/.claude-work/` — work account
   - `~/.claude-{name}/` — any additional accounts (extensible)

2. **Source files.** Chezmoi deploys account-specific content to `home/private_dot_claude-{account}/`:
   ```
   home/private_dot_claude-personal/
   ├── hooks/executable_*.sh           # personal hooks
   ├── skills/                         # personal skills
   ├── agents/                         # personal agents
   ├── modify_private_settings.json.tmpl
   └── private_CLAUDE.md

   home/private_dot_claude-work/
   ├── modify_private_settings.json.tmpl
   └── private_CLAUDE.md
   ```

   Shared content (e.g., `tmux-bell.sh`) lives in personal; work account symlinks or copies as needed. Shared skills/agents live in personal; work can symlink if desired, or each maintains its own.

3. **Declarative config.** `home/.chezmoidata/claude.yaml` organizes extras by scope:
   ```yaml
   claudeData:
     shared:                          # All accounts get these
       marketplaces: [...]
       plugins: [...]
       mcpServers: []
     personal:                        # Personal account only
       marketplaces: [...]
       plugins: [...]
       mcpServers: []
     work:                            # Work account only
       marketplaces: []
       plugins: []
       mcpServers: []
   ```

   Machine-local extras (private MCP servers, work-specific setup) live in `[data.claudeExternalExtra]` in `~/.config/chezmoi/chezmoi.toml` and are merged at sync time.

4. **Account detection.** `bin/sync-claude-settings` and `bin/sync-claude-extras` each have a `detect_accounts()` function:
   ```bash
   detect_accounts() {
     for dir in "${HOME}"/.claude-*/; do
       account="${dir#${HOME}/.claude-}"
       account="${account%/}"
       accounts+=("${account}")
     done
     printf '%s\n' "${accounts[@]}"
   }
   ```

   They then loop over all detected accounts and apply config to each.

5. **Sync pipelines.** Each script processes all accounts:
   ```
   bin/sync-claude-settings
     ├─ detect_accounts() → [personal, work]
     ├─ sync_account(personal)
     │  └─ apply statusLine, permissions, model to ~/.claude-personal/settings.json
     └─ sync_account(work)
        └─ apply statusLine, permissions, model to ~/.claude-work/settings.json

   bin/sync-claude-extras
     ├─ detect_accounts() → [personal, work]
     ├─ reconcile_account(personal)
     │  └─ merge shared + personal data, reconcile via claude CLI
     └─ reconcile_account(work)
        └─ merge shared + work data, reconcile via claude CLI
   ```

6. **Shell aliases enforce choice.** User configures:
   ```bash
   alias claude-personal='claude --config ~/.claude-personal'
   alias claude-work='claude --config ~/.claude-work'
   ```

   Running `claude` (without suffix) either fails or shows an error. Prevents accidental account mixing.

7. **Hook management.** Hooks are deployed via chezmoi (e.g., `home/private_dot_claude-personal/hooks/tmux-bell.sh`). The sync scripts no longer attempt to register hooks; hooks are treated as deployed static content that the Claude CLI discovers.

### Consequences

- **Positive**: Multiple accounts can coexist and be used independently without manual switching or file juggling.
- **Positive**: Shared config (plugins, marketplaces) is declared once in `claude.yaml` and applied to all accounts, reducing duplication.
- **Positive**: Account-specific config (extra plugins, private MCP servers) is isolated, reducing security/privacy risk.
- **Positive**: Shell aliases make account choice explicit and prevent accidents.
- **Positive**: Scripts scale to N accounts without modification.
- **Positive**: Chezmoi remains the source of truth; no manual directory management.
- **Negative / accepted tradeoff**: Account directories must exist before sync runs; a new account requires manual `mkdir ~/.claude-{name}` or a chezmoi template that creates it. Mitigated: documented in `docs/agents/claude-code.md`, and adding a new account is a rare operation.
- **Negative**: Glob-based detection has no way to tell a retired account from a live one, so removing an account is a three-part operation that is easy to half-do. Addressed by the amendment below.
- **Negative**: Hook management moved from sync script to chezmoi deployment; hooks are no longer wired by the script. Mitigated: hooks are simpler (no removal logic needed), and stateless (present or absent, not mutated by sync).
- **Negative**: Slightly more complex sync script logic (account loop, dynamic directory paths). Mitigated by clear function separation and tests.

### Relationship to ADR 0008

ADR 0008 established the **two-manager split**: `bin/sync-claude-settings` owns the flat surface (settings.json fields), and `bin/sync-claude-extras` owns the CLI-owned surface (plugins/marketplaces/MCPs). This ADR **extends, not changes, that split**:

- Each manager now processes **all detected accounts** instead of assuming a single `~/.claude/`.
- The data structure for extras (`home/.chezmoidata/claude.yaml`) gains an **account hierarchy** (shared, personal, work, …).
- Hooks are no longer synced by `bin/sync-claude-settings`; they are deployed via chezmoi and assumed to exist (removed `set_hooks()` logic).

The two-manager philosophy remains: settings are imperative (`jq` in place), extras are declarative (CLI-reconciled).

## Confirmation

- `bin/sync-claude-settings` and `bin/sync-claude-extras` both detect and process all `~/.claude-{account}/` directories.
- `home/.chezmoidata/claude.yaml` has `shared`, `personal`, and `work` sections; declared extras are applied correctly per account.
- Running `chezmoi apply` creates / updates settings.json in all detected account directories; `~/.claude/` is NOT created.
- `bin/sync-claude-extras --check` reports what would be synced per account (shared + account-specific).
- Test suite passes for multi-account setup:
  - `test/sync-claude-settings.bats`: 9/9 ✅
  - `test/sync-claude-extras.bats`: 6/6 ✅
- Adding a new account (e.g., `~/.claude-stage/`) and re-running sync automatically configures it.

## Amendment (2026-08-25): account teardown

Detecting accounts by globbing `~/.claude-*/` scales to N accounts, as intended — but it also means the sync scripts cannot distinguish a retired account from a live one. Deleting an account's data block and source dir leaves `~/.claude-{name}/` behind, invisible in `git status`, still detected, and still having every `shared` marketplace re-installed into it on each `chezmoi apply`. That cost was not obvious when accounts were assumed to be two and permanent; it became obvious once consulting clients started getting one account each, with a natural end date.

[`bin/remove-claude-account`](../../bin/remove-claude-account) closes the loop, removing all three parts in one validated pass. Two choices inside it are worth recording:

- **Archive, not delete — and outside the account namespace.** `~/.claude-{name}/` moves to `$XDG_STATE_HOME/claude-archive/{name}-{UTC}/` rather than being removed. It holds session transcripts, `projects/`, and `.credentials.json` — none of it reconstructible, and a `mv` is instant and reversible. The destination is deliberately *not* `~/.claude-archive/`: account detection is a `~/.claude-*/` glob, so an archive there would be reconciled as an account named `archive`, which is the very orphan being cleaned up. `--purge` deletes instead, for engagements whose contract says the history may not outlive them.
- **`awk`, not `yq -i`.** mikefarah yq round-trips the document and strips every blank line, so `del(.claudeData.{name})` on the heavily-commented `claude.yaml` produces a diff touching every section. A targeted awk block-delete leaves the rest byte-for-byte identical, which is what keeps the teardown reviewable in a PR. `test/remove-claude-account.bats` pins that: the edit must be exactly one hunk of pure deletions.

The structural assumptions the awk relies on (accounts are 2-space keys under `claudeData:`, their banner comments are 2-space-indented, in-block comments are deeper) are now load-bearing for `claude.yaml` and asserted by that suite.

## Future Considerations

- **Account templates.** A chezmoi template could auto-create `~/.claude-{name}/` directories on first run (e.g., prompt for additional accounts during `chezmoi init`). The inverse — `bin/remove-claude-account` — now exists.
- **Account-specific hooks.** If future hooks need to differ per account, they can be stored in `home/private_dot_claude-{account}/hooks/` and deployed independently.
- **Shared skills/agents.** If personal skills/agents are needed in work account, a symlink or chezmoi external can share them without duplication.
