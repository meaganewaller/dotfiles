# Claude Code in this repository

This document covers the **global Claude Code configuration** that chezmoi syncs to Claude Code installations. For the broader edit / diff / apply workflow, see [chezmoi.md](chezmoi.md). For shell behavior under Claude Code and other agents, see [ADR 0001](../adrs/0001-specialized-agent-shell.md).

## Multi-account support

This dotfiles repo supports multiple Claude Code accounts on one machine. Today that is `personal`, `work` (TestDouble), and one account per consulting client (`gifthealth`) — but nothing is hardcoded to that list: every account is a key under `claudeData` in [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml), and shells, sync scripts, and tests all derive themselves from it. See [Account lifecycle](#account-lifecycle) to add or remove one. Configuration is split as follows:

| Asset | Location | Deployed to | Notes |
| --- | --- | --- | --- |
| **Shared** (hooks, skills, agents, themes) | `home/private_dot_claude-personal/` | `~/.claude-personal/` | Personal account only; work account pulls shared assets via symlinks or separate copy |
| **Account-specific extras** (marketplaces, plugins, MCP servers) | `home/.chezmoidata/claude.yaml`, under `shared` or an account key | `bin/sync-claude-extras` reconciles to each account | Additive; shared items go to all accounts |
| **Account-specific settings** (permissions, hooks, env, feature flags) | `home/.chezmoidata/claude.yaml` + `claude-permissions.yaml`, same keys | rendered into each account's `settings.json` by its `modify_private_settings.json.tmpl` | `shared` applies everywhere; `{account}` layers on top |

### No bare `claude` — pick an account at the shell

Multi-account means there is no `~/.claude`, but the CLI happily creates one when `CLAUDE_CONFIG_DIR` is unset. A bare `claude` would therefore start a session with neither account's settings, plugins, or MCP servers, in a directory nothing here manages. So every interactive shell defines `claude-<account>` wrappers and redefines `claude` itself to print the account list and exit non-zero:

```console
$ claude
claude: pick an account -- claude-gifthealth, claude-personal, claude-work
$ echo $?
1
```

| Shell | File | Source |
| --- | --- | --- |
| zsh, bash | `~/.config/shell/claude.sh`, sourced by both rc files | [`home/dot_config/shell/claude.sh.tmpl`](../../home/dot_config/shell/claude.sh.tmpl) |
| fish | `~/.config/fish/conf.d/10-claude.fish` | [`home/dot_config/fish/conf.d/10-claude.fish.tmpl`](../../home/dot_config/fish/conf.d/10-claude.fish.tmpl) |

Fish cannot source POSIX shell, so the logic exists twice — but both files render the wrapper list from the same `claudeData` keys in `home/.chezmoidata/claude.yaml` (every key except `shared`), so adding an account there gets wrappers in all three shells with no further edits. Behavior is identical across the three, and [`test/claude-shell-dispatch.bats`](../../test/claude-shell-dispatch.bats) asserts that against all of them.

Each wrapper sets `CLAUDE_CONFIG_DIR` and folds in two things that used to live inline in `dot_zshrc.tmpl`:

- **`--add-dir ~/src` on session launches only.** The flag is variadic, so injecting it unconditionally makes `claude mcp add name cmd` become `claude --add-dir ~/src mcp add name cmd`, where `--add-dir` eats `mcp add name cmd` as more directories and the subcommand never runs. Management subcommands are passed through untouched.
- **`claude-chill`, when installed**, wraps the real binary — resolved at call time rather than at chezmoi render time, so installing it later does not need a re-apply.

Two deliberate holes, both unaffected by the guard because they run outside an interactive shell: non-interactive scripts (`bin/sync-claude-extras` sets `CLAUDE_CONFIG_DIR` itself for every call), and `command claude`, which bypasses the function by design.

The sync scripts detect which account directories exist and apply config to each.

## Account lifecycle

An account is three things. Creating or deleting only some of them leaves the setup lying to itself, so both directions are written down here.

| Part | Where |
| --- | --- |
| Declared config | `claudeData.<account>` in [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) |
| Chezmoi source dir | `home/private_dot_claude-<account>/` |
| The live account | `~/.claude-<account>/` — created by `chezmoi apply`, then filled with session history and credentials by Claude Code itself |

Everything else derives from those: the `claude-<account>` shell wrappers, [`bin/sync-claude-extras`](../../bin/sync-claude-extras), [`bin/sync-claude-settings`](../../bin/sync-claude-settings), and the test suites all read the data file or glob `~/.claude-*/` rather than carrying a list.

### Adding an account

Consulting engagements get their own account named after the client, so the shell command says which engagement you are in and credentials, history, and MCP servers never mix with `work`. Three steps:

```bash
# 1. Declare it. Empty maps/lists mean "inherit `shared` and nothing else".
$EDITOR home/.chezmoidata/claude.yaml
```

```yaml
  # ── Client account: Acme (~/.claude-acme) ───────────────────────────────────
  acme:
    settings: {}
    env: {}
    hooks: []          # hook scripts live under private_dot_claude-personal/;
    marketplaces: []   # declaring one here means shipping it under this
    plugins: []        # account's source dir too
    mcpServers: []
```

```bash
# 2. Give it a source dir. Both files are the work account's, with the account
#    name swapped in the `claude-settings` template call.
mkdir -p home/private_dot_claude-acme
sed 's/"account" "work"/"account" "acme"/' \
  home/private_dot_claude-work/modify_private_settings.json.tmpl \
  >home/private_dot_claude-acme/modify_private_settings.json.tmpl
cp home/private_dot_claude-work/private_CLAUDE.md.tmpl home/private_dot_claude-acme/

# 3. Apply, then authenticate the new account once.
chezmoi diff && chezmoi apply
./bin/test                      # the suites pick the account up from the data
exec $SHELL                     # claude-acme exists in the new shell
claude-acme                     # log in as the client account
```

Nothing else needs editing. `claude-acme` appears in zsh, bash, and fish; both sync scripts find `~/.claude-acme`; and [`test/claude-shell-dispatch.bats`](../../test/claude-shell-dispatch.bats) and [`test/claude-settings-template.bats`](../../test/claude-settings-template.bats) both enumerate accounts from `claude.yaml`, so a declared account with no source dir fails the suite instead of silently never rendering.

### Removing an account

When an engagement ends, use [`bin/remove-claude-account`](../../bin/remove-claude-account) rather than deleting things by hand — a leftover `~/.claude-<account>` is invisible in `git status` but keeps getting reconciled by both sync scripts forever, re-installing every `shared` marketplace on each `chezmoi apply`.

```bash
./bin/remove-claude-account --check acme   # what it would remove, changes nothing
./bin/remove-claude-account acme           # asks before doing it
```

It removes all three parts in one pass:

- **`claudeData.acme`** is cut out of `claude.yaml` with `awk`, not `yq -i 'del(...)'` — yq round-trips the document and strips every blank line, turning a one-block removal into a whole-file diff. The awk edit takes the block plus its banner comment and leaves the other ~180 lines byte-for-byte identical, which is what makes the result reviewable. `test/remove-claude-account.bats` asserts the diff is exactly one hunk of pure deletions.
- **`home/private_dot_claude-acme/`** is deleted; it is tracked, so git is the undo.
- **`~/.claude-acme/`** is *moved* to `${XDG_STATE_HOME:-~/.local/state}/claude-archive/acme-<UTC timestamp>/`, not deleted. It holds session transcripts, `projects/`, and `.credentials.json`. The archive deliberately lands outside `~/.claude-*`, because that glob is how both sync scripts enumerate accounts — an archive at `~/.claude-archive/` would be picked up as an account named `archive` and have every `shared` marketplace installed into it, recreating the exact orphan being removed. Pass `--purge` to delete instead, when the contract says the history may not outlive the engagement. Either way, revoke the client account's credentials on Anthropic's side too — archiving keeps `.credentials.json` on disk.

Guards, all covered by the test suite: it refuses `shared` (the merge base, not an account), refuses the last remaining account (there is no `~/.claude` to fall back on), refuses to run non-interactively without `--yes`, and validates the rewritten YAML before writing anything — so a failure leaves the repo and `$HOME` untouched rather than half-torn-down.

Finish with the usual review: `git diff`, commit, `chezmoi apply`.

## Layout (shared account)

```
home/private_dot_claude-personal/  # → ~/.claude-personal/
├── CLAUDE.md                      # Global Claude Code memory (precedence: project > this > external)
├── agents/                        # Subagents callable via the Agent tool; one .md per agent
├── hooks/                         # PreToolUse / PostToolUse shell scripts (executable_* prefix)
└── powerline/                     # Status-line themes (catppuccin variants + shared)
```

Account-specific settings (extras like plugins/marketplaces/MCP servers) are declared in `home/.chezmoidata/claude.yaml`.

What is **not** in source control:

- `~/.claude*/settings.json` — generated. Each account's [`modify_private_settings.json.tmpl`](../../home/private_dot_claude-personal/modify_private_settings.json.tmpl) renders the declared settings from `home/.chezmoidata/claude.yaml` + `claude-permissions.yaml` and merges them onto whatever is already on disk, so keys Claude Code owns and we do not declare survive. `extraKnownMarketplaces` / `enabledPlugins` are never written here; those are CLI-owned (see below).
- `~/.claude*/settings.local.json` — machine-local overlay. Not managed; deliberately left to the user / host.

### Three writers, split by who owns the bytes (ADRs [0008](../adrs/0008-claude-config-two-managers.md), [0011](../adrs/0011-claude-settings-as-data.md))

Claude Code's runtime config has surfaces with different *writers*, so this repo splits management to match. Exactly one thing writes each key:

| Writer | Owns | Mechanism | Scope |
| --- | --- | --- | --- |
| `home/private_dot_claude-{account}/modify_private_settings.json.tmpl` | the flat `settings.json` surface: `statusLine`, `permissions`, `hooks`, feature flags, `env`, `model` | renders [`home/.chezmoitemplates/claude-settings`](../../home/.chezmoitemplates/claude-settings) to JSON, then `jq '. * $desired'` onto the current file | `shared` data everywhere; `{account}` data layered on top |
| [`bin/sync-claude-settings`](../../bin/sync-claude-settings) | AWS Bedrock model IDs only: `.env.ANTHROPIC_*` and `.model` | imperative `jq`, run as `run_onchange_after_*` so it lands on top of the rendered file | All detected accounts |
| [`bin/sync-claude-extras`](../../bin/sync-claude-extras) | the CLI-owned surface: `extraKnownMarketplaces`, `enabledPlugins`, `mcpServers` | drives the `claude` CLI from declarative data in `claude.yaml`; never edits `settings.json` directly | Shared extras to all accounts; account-specific extras only to that account |

Why the extras split: the `claude` CLI is the single writer of marketplaces/plugins/MCP servers — it re-serializes those keys on every `claude plugin …` / `claude mcp …` call. Hand-writing them with `jq` races the CLI and drifts. So we **declare intent** in [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) and let the CLI realize it. See the "Claude extras" section below.

Why Bedrock is still a script: model IDs come from an `aws bedrock list-foundation-models` lookup at apply time and cannot be known by a static data file.

So: **`home/private_dot_claude-*/` ships content** (skills, agents, hooks, themes), **`home/.chezmoidata/claude*.yaml` declares wiring** (which hooks fire, which permissions are granted, which flags are set), and **`bin/sync-claude-extras` ships extras intent**.

Registration is now a single data row in every case:

| Change | Content edit | Wiring edit also required? |
| --- | --- | --- |
| New skill | not here — add it to a plugin in the marketplace repo | **yes** — declare that plugin in `claude.yaml` (see [Skills](#skills)) |
| New subagent (`home/private_dot_claude-{account}/agents/<name>.md`) | yes | no — auto-discovered from `~/.claude-{account}/agents/` |
| New hook (`home/private_dot_claude-{account}/hooks/executable_<name>.sh`) | yes | **yes** — one row under `claudeData.{scope}.hooks` in `claude.yaml`, or the hook is on disk but never fires |
| New permission pattern (allowing a new tool/command) | n/a | **yes** — one row in `home/.chezmoidata/claude-permissions.yaml` |
| New plugin / marketplace / MCP server | n/a | **yes** — one row in `home/.chezmoidata/claude.yaml` (public) or machine-local `[data.claudeExternalExtra]`; `bin/sync-claude-extras` reconciles it via the `claude` CLI |
| Default model / feature flag / env var change | n/a | **yes** — one row under `claudeData.{scope}.settings` or `.env` in `claude.yaml` |

ADR [0008](../adrs/0008-claude-config-two-managers.md) established the split by writer (superseding the never-implemented ADR [0004](../adrs/0004-claude-settings-management.md)); ADR [0011](../adrs/0011-claude-settings-as-data.md) moved the flat surface to data, closing the two-place edit for hooks and permissions that 0008 had deferred (issue [#25](https://github.com/meaganewaller/dotfiles/issues/25)).

### Editing the declared settings

The data files are `home/.chezmoidata/claude.yaml` (per-scope `settings` / `env` / `hooks`, plus the extras) and `home/.chezmoidata/claude-permissions.yaml` (`permissions.defaultMode` and the allow list — split out purely for diff hygiene; chezmoi deep-merges both into the same `claudeData.shared`).

Layering: `claudeData.shared` applies to every account, `claudeData.{account}` layers on top. Maps and scalars override; the permissions allow list and hooks concatenate.

Two placeholders expand at render time, because `.chezmoidata` files are plain YAML and cannot themselves be templates:

- `$HOME` → the real home directory. Required in permission patterns: Claude Code does **not** shell-expand those, so a literal `$HOME` would never match.
- `$CLAUDE_DIR` → `~/.claude-{account}`. Use it for hook commands so one declaration works for whichever account it is placed under.

Merge semantics matter: `jq`'s `*` recurses into objects but **replaces arrays wholesale**. That is deliberate — undeclared keys survive, while removing a permission or hook from the data actually removes it from `settings.json`.

Preview a change without applying it:

```bash
# What would change on disk (the usual check).
chezmoi diff ~/.claude-personal/settings.json

# The desired JSON on its own, with nothing merged in. The modify_ script reads
# the current file from stdin, so render it to a file and feed it /dev/null.
chezmoi execute-template --file home/private_dot_claude-personal/modify_private_settings.json.tmpl >/tmp/modify.sh
bash /tmp/modify.sh </dev/null | jq .
```

## Skill vs. subagent — when to use each

| Dimension | Skill (`skills/<name>/SKILL.md`) | Subagent (`agents/<name>.md`) |
| --- | --- | --- |
| Who invokes it | The user via `/<name>` | The main agent (or another agent) via the Agent tool |
| Context model | Runs in the **same** context as the conversation | Fresh, isolated context — only sees the prompt you hand it |
| Best for | Interactive workflows the human runs deliberately (commit, PR, write-skill) | Bounded research / review tasks where you want isolation, parallelism, or a different toolset |
| Frontmatter | `name`, `description`, `argument-hint`, `allowed-tools` | `name`, `description`, `tools`, `model` |
| Layout | Each skill is a directory; `SKILL.md` is the entry point, supporting files alongside | Single flat `.md` file |

Rule of thumb: if the human types it, it's a skill. If the main agent farms it out, it's a subagent.

## Skills

**This repository ships no skills.** They arrive as plugins from marketplaces, declared in [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) and reconciled into Claude Code's own plugin store by [`bin/sync-claude-extras`](../../bin/sync-claude-extras). `~/.claude-{account}/skills/` is empty on purpose; nothing under `home/private_dot_claude-{account}/` carries a `skills/` directory.

That is a deliberate move away from hand-managed skill directories. A skill in a plugin is versioned, shared across accounts by declaring one plugin, and updated by bumping the plugin — none of which a loose `SKILL.md` in `~` offers.

Where the skills at a `/name` prompt come from:

| Source | Declared in | Example |
| --- | --- | --- |
| Marketplace plugin | `claude.yaml` under `marketplaces` + `plugins` | `commit`, `pr`, `split-pr` from `git-workflow@meaganewaller-marketplace` |
| Repo-local | `.claude/skills/` in this working tree | `agents-local-md`, `install`, `nvim`, `update` |

Repo-local skills stay repo-local by design: they assume this working tree, so they are never synced to `~`.

To add a skill, add it to a plugin in the marketplace repository and declare that plugin in `claude.yaml` — not to `home/private_dot_claude-{account}/`. To make one available only inside this repo, put it in `.claude/skills/`.

## Subagents inventory

Each subagent is a single `.md` file at `home/private_dot_claude-personal/agents/<name>.md`:

```yaml
---
name: <agent-name>
description: When to spawn this agent
tools: Read, Write, Edit, Bash, Grep, Glob   # explicit tool list
model: sonnet                                  # or opus
---
```

Current subagents:

| Agent | Purpose |
| --- | --- |
| `pr-feedback-reviewer` | Fetch PR comments, assess validity, prioritize recommendations |
| `reviewer` | Read-only code / document review; restricted to writing reports under `scratch/` |
| `tdd-guardian` | Enforce strict TDD (RED → GREEN → MUTATE → KILL → REFACTOR) before code is written |

`reviewer` and `tdd-guardian` enforce hard role boundaries in their system prompts (e.g. "this agent must not modify any files outside of scratch/"). When extending or adding a subagent, treat the system-prompt role boundaries as load-bearing — they're what makes the agent safe to spawn unsupervised.

## Hooks

Most hooks live at `home/private_dot_claude-personal/hooks/executable_*.sh`. The `executable_` chezmoi prefix preserves the `+x` bit when chezmoi writes the file out to `~/.claude-personal/hooks/` (and similarly to `~/.claude-work/hooks/`, etc.). Each hook reads tool-call JSON on stdin and exits non-zero (or prints a decision) to block / annotate.

Declared today in [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml):

| Hook | Event | Matches | What it does |
| --- | --- | --- | --- |
| `claude-notify` | Notification | `.*` | Sends a native OS notification when Claude emits a Notification event (typically when attention/user input is needed). |
| `block-sensitive-or-generated-writes` | PreToolUse | `Write` / `Edit` / `MultiEdit` | Blocks writes to sensitive targets (`.ssh`, `.aws`, key/cert files, `.env`, credentials/secrets files, repo `private_*` stores) and generated/build artifacts (`node_modules`, `dist`, `.next`, `*.generated.*`, `*.pb.*`, ...). |
| `check-secrets-before-write` | PreToolUse | `Write` / `Edit` / `MultiEdit` | Scans pending write content (`content`, `new_string`, and `MultiEdit` replacements) for likely secrets (AWS keys, GitHub tokens, `sk-...`, private key blocks, hardcoded password/token assignments, literal DB URLs) and denies on match. |
| `block-adhoc-installers` | PreToolUse | `Bash` | Denies ad-hoc installers/runners (`npx`, `bunx`, `uvx`, `pipx`, `pip install`, `npm -g`, `gem`/`brew`/`cargo`/`go install`, …) and redirects to the `/install` skill, so tools stay captured in mise. Enforcement teeth for the "use mise exclusively" rule in `~/.claude-personal/CLAUDE.md`. Escape hatch: `CLAUDE_ALLOW_ADHOC_INSTALL=1` (human-only). |
| `tmux-bell.sh` | Notification | `.*` | Rings the tmux bell so a backgrounded session surfaces when Claude Code wants attention. |

`claude-notify` and the two write guards are declared under `shared` and implemented as policy executables in `~/.local/libexec`, so they apply to every account uniformly. `tmux-bell.sh` remains `personal`-only because it is account-local and UX-specific.

`block-adhoc-installers` is the one exception to the `home/private_dot_claude-personal/hooks/` convention: it lives at [`home/dot_local/libexec/executable_block-adhoc-installers`](../../home/dot_local/libexec/executable_block-adhoc-installers) (→ `~/.local/libexec/`, on `PATH`) because it is a self-contained policy executable rather than a Claude-specific script. Its data row uses `$HOME` rather than `$CLAUDE_DIR` for that reason.

**Hook contract** (when adding one):

1. Place at `home/private_dot_claude-personal/hooks/executable_<name>.sh` so chezmoi writes it executable.
  For cross-account policy hooks, prefer `home/dot_local/libexec/executable_<name>` and reference it via `$HOME/.local/libexec/<name>` from `claudeData.shared.hooks`.
2. Read tool input as JSON from stdin; parse with `jq`. Check `.tool_name` early and `exit 0` for tools you don't care about — hooks fire for every tool call.
3. Exit 0 for "allow", non-zero (with a message on stderr) for "block".
4. **Declare** it under `claudeData.{scope}.hooks` in `home/.chezmoidata/claude.yaml` — `{event, matcher, command}`, using `$CLAUDE_DIR` for the path. Without this the script is on disk at `~/.claude-{account}/hooks/` but `settings.json` never references it, so it never fires. Then `chezmoi apply`.

## Settings split (managed vs. local)

| File | Managed by | Contents |
| --- | --- | --- |
| `~/.claude-{account}/settings.json` | that account's `modify_private_settings.json.tmpl`, from `home/.chezmoidata/claude.yaml` + `claude-permissions.yaml` | `statusLine`, feature flags, `env`, `permissions`, hook registrations, default model. `shared` data reaches every account; `{account}` data layers on top. **Not** `extraKnownMarketplaces` / `enabledPlugins` — those are CLI-owned. |
| `.env.ANTHROPIC_*` / `.model` (Bedrock only) | `bin/sync-claude-settings`, as a `run_onchange_after_*` overlay | Merged in when `chezmoi data .claude.use_bedrock` is true; stripped when false. Runs after the file pass so its `.model` wins. |
| `extraKnownMarketplaces` / `enabledPlugins` / `mcpServers` (inside `settings.json` / `~/.claude*.json`) | the `claude` CLI, driven by `bin/sync-claude-extras` from `home/.chezmoidata/claude.yaml` + machine-local `[data.claudeExternalExtra]` | which marketplaces are registered, which plugins are enabled (per account), which MCP servers are added. Shared items go to all accounts; account-specific items only to that account. |
| `~/.claude*/settings.local.json` | Not managed | Anything truly per-machine: experimental flags, host-specific permission additions, model overrides for that box only. |

To change a managed flat setting: edit `home/.chezmoidata/claude.yaml` (or `claude-permissions.yaml`), then `chezmoi apply`. To change extras: edit `home/.chezmoidata/claude.yaml` (or machine-local extras), then `chezmoi apply` (the `run_onchange_sync-claude-extras.sh.tmpl` wrapper re-fires on data/script-hash change). To change a local-only setting: edit `~/.claude*/settings.local.json` directly — chezmoi will not overwrite it.

## Claude extras (marketplaces, plugins, MCP servers)

`extraKnownMarketplaces`, `enabledPlugins`, and `mcpServers` are written by the `claude` CLI itself — it re-serializes them on every `claude plugin …` / `claude mcp …` call. So this repo does **not** hand-write them into `settings.json`; instead it **declares intent** and lets the CLI realize it (ADR [0008](../adrs/0008-claude-config-two-managers.md)).

### Multi-account extras structure

[`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) uses `claudeData` with three keys:

```yaml
claudeData:
  shared:                  # Applied to all accounts
    marketplaces: [...]
    plugins: [...]
    mcpServers: [...]
  personal:                # Applied only to personal account (~/.claude-personal/)
    marketplaces: [...]
    plugins: [...]
    mcpServers: [...]
  work:                    # Applied only to work account (~/.claude-work/)
    marketplaces: [...]
    plugins: [...]
    mcpServers: [...]
  gifthealth:              # One client engagement (~/.claude-gifthealth/)
    marketplaces: []       # inherits `shared` and nothing else
    plugins: []
    mcpServers: []
```

The reconciler merges `shared` + account-specific for each account. Private/work/machine-specific entries live in machine-local `[data.claudeExternalExtra]` in `~/.config/chezmoi/chezmoi.toml`; the reconciler merges those too.

### Reconciliation process

- **Reconciler:** [`bin/sync-claude-extras`](../../bin/sync-claude-extras) detects all account directories (`~/.claude`, `~/.claude-personal`, `~/.claude-work`, etc.), and for each account:
  1. Reads *declared* data (shared + account-specific + machine-local) via `chezmoi data`
  2. Reads *installed* state from that account's Claude Code JSON files — `~/.claude*/plugins/known_marketplaces.json`, `~/.claude*/plugins/installed_plugins.json`, and `~/.claude*.json` (MCP)
  3. For each declared item not already present, runs the matching `claude` write (`plugin marketplace add` / `plugin install --scope user` / `mcp add --scope user`)
  4. Reports idempotently: `ok` for present items; `drift` for undeclared-but-installed; removes only with `--prune`

  Built-in marketplaces (`claude-plugins-official`) and `managed`/project-scope items are never touched. A failing `claude` write warns and continues so one bad item never aborts `chezmoi apply`.

  - **Write caveat:** because `claude` plugin/MCP writes currently need an interactive (TTY) session, *adds* won't succeed under a headless `chezmoi apply`; the reconciler warns with the command to run. In the steady state (everything already installed) it just reports `ok` and makes no writes, so it runs cleanly headless.
  - `bin/sync-claude-extras --check` — dry run; print what would change.
  - `bin/sync-claude-extras --prune` — also remove user-scope extras that are not declared.

- **Re-fires** via [`home/.chezmoiscripts/run_onchange_sync-claude-extras.sh.tmpl`](../../home/.chezmoiscripts/run_onchange_sync-claude-extras.sh.tmpl), hashed over the reconciler, `claude.yaml`, and the machine-local extras.

### Adding extras

- To add a **shared** plugin/marketplace (all accounts): add to `claudeData.shared` in `claude.yaml`, then `chezmoi apply`.
- To add a **personal-only** plugin/marketplace: add to `claudeData.personal` in `claude.yaml`, then `chezmoi apply`.
- To add a **work-only** plugin/marketplace: add to `claudeData.work` in `claude.yaml`, then `chezmoi apply`.
- To add a **client-only** plugin/marketplace: add to that client's key (e.g. `claudeData.gifthealth`), then `chezmoi apply`.
- To add a **private MCP server** or **machine-local extra**: add it under `[data.claudeExternalExtra]` in your machine-local chezmoi config, never in `claude.yaml`.

### AWS Bedrock models

`home/.chezmoi.toml.tmpl` prompts `use_bedrock` once (persisted under `[data.claude]`). When true, `bin/sync-claude-settings` calls [`bin/resolve-bedrock-models`](../../bin/resolve-bedrock-models) — which queries `aws bedrock list-foundation-models`, picks the latest active cross-region inference profile per tier (opus/sonnet/haiku, with a 24h cache), appends `[1m]` to opus/sonnet — and merges the IDs into `.env` + `.model`. When false, those Bedrock env vars are stripped and `.model` is left to the value declared in `claude.yaml`.

This is the one part of `settings.json` that cannot be data: the IDs are only knowable from an AWS call at apply time. Everything else moved to `home/.chezmoidata/` (ADR [0011](../adrs/0011-claude-settings-as-data.md)). Resolution failures (missing `aws`, no creds) degrade gracefully — the overlay writes through a temp file and validates before replacing, so a failure leaves `settings.json` exactly as the template rendered it.

## Adding a skill

Skills are not added to this repository. Add the skill to a plugin in the marketplace repo, then declare that plugin here:

```yaml
# home/.chezmoidata/claude.yaml — under the scope that should get it
plugins:
  - <plugin>@meaganewaller-marketplace
```

```bash
chezmoi diff && chezmoi apply   # renders the data
bin/sync-claude-extras --check  # shows what the claude CLI would install
```

Declaring the plugin under `shared` reaches every account at once, which is the main reason this beats a per-account `SKILL.md`: one row, both accounts, versioned upstream.

For a skill that only makes sense inside this working tree, put it in `.claude/skills/<name>/SKILL.md` instead — those are never synced to `~`.

## Adding a subagent

```bash
$EDITOR home/private_dot_claude-personal/agents/<name>.md         # add frontmatter + body
chezmoi diff && chezmoi apply
```

The Agent tool discovers subagents from `~/.claude-personal/agents/` (personal account) or `~/.claude-work/agents/` (work account). If the description is precise, the main agent will route to it automatically.

For step-by-step prompts, this repo also ships the `write-skill` and `write-subagent` skills — they walk you through the frontmatter and constraints.

## References

- [Chezmoi workflow](chezmoi.md) — the edit / diff / apply cycle these files ride on
- [ADR 0001 — Agents need a specialized shell](../adrs/0001-specialized-agent-shell.md) — why `home/dot_zshrc.tmpl` branches when invoked under Claude Code / Cursor
- [ADR 0008 — Claude config: two managers](../adrs/0008-claude-config-two-managers.md) — why settings vs. extras are split by writer
- [ADR 0010 — Multi-account Claude Code support](../adrs/0010-multi-account-claude-code.md) — why config is per-account
- [ADR 0011 — Claude settings as data](../adrs/0011-claude-settings-as-data.md) — why the flat surface is `.chezmoidata` rendered by a `modify_` template
- [Claude Code docs](https://docs.anthropic.com/claude-code) — upstream feature reference
- [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) + [`claude-permissions.yaml`](../../home/.chezmoidata/claude-permissions.yaml) — source of truth for the flat `settings.json` surface, rendered by [`home/.chezmoitemplates/claude-settings`](../../home/.chezmoitemplates/claude-settings)
- [`bin/remove-claude-account`](../../bin/remove-claude-account) — tear down one account: data block, source dir, and `~/.claude-<account>`
- [`bin/sync-claude-settings`](../../bin/sync-claude-settings) — apply-time AWS Bedrock model overlay
- [`bin/sync-claude-extras`](../../bin/sync-claude-extras) + [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) — declarative marketplaces / plugins / MCP servers, reconciled via the `claude` CLI
