# Claude Code in this repository

This document covers the **global Claude Code configuration** that chezmoi syncs from `home/dot_claude/` to `~/.claude/`. For the broader edit / diff / apply workflow, see [chezmoi.md](chezmoi.md). For shell behavior under Claude Code and other agents, see [ADR 0001](../adrs/0001-specialized-agent-shell.md).

## Layout

```
home/dot_claude/                # → ~/.claude/
├── CLAUDE.md                   # Global Claude Code memory (precedence: project > this > external)
├── skills/                     # User-invokable slash commands; one subdir per skill
├── agents/                     # Subagents callable via the Agent tool; one .md per agent
├── hooks/                      # PreToolUse / PostToolUse shell scripts (executable_* prefix)
└── powerline/                  # Status-line themes (catppuccin variants + shared)
```

What is **not** in source control:

- `~/.claude/settings.json` — generated and refreshed at runtime by [`bin/sync-claude-settings`](../../bin/sync-claude-settings), invoked from `home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl`. The script sets `statusLine`, feature flags, the global `permissions` allowlist, hook registrations, and the default model — and validates the result is still parseable JSON. It **no longer** writes `extraKnownMarketplaces` / `enabledPlugins`; those are CLI-owned (see below).
- `~/.claude/settings.local.json` — machine-local overlay. Not managed; deliberately left to the user / host.

### Two managers, split by who owns the bytes (ADR [0008](../adrs/0008-claude-config-two-managers.md))

Claude Code's runtime config has two surfaces with two different *writers*, so this repo manages them with two scripts:

| Manager | Owns | Mechanism |
| --- | --- | --- |
| [`bin/sync-claude-settings`](../../bin/sync-claude-settings) | the flat `settings.json` surface this repo solely owns: `statusLine`, `permissions.allow`, `hooks`, feature flags, `model` | imperative `jq` merge, then `validate_settings` |
| [`bin/sync-claude-extras`](../../bin/sync-claude-extras) | the CLI-owned surface: `extraKnownMarketplaces`, `enabledPlugins`, `mcpServers` | drives the `claude` CLI from declarative data; never edits `settings.json` directly |

Why two: the `claude` CLI is the single writer of marketplaces/plugins/MCP servers — it re-serializes those keys on every `claude plugin …` / `claude mcp …` call. Hand-writing them with `jq` races the CLI and drifts. So we **declare intent** in [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) and let the CLI realize it. See the "Claude extras" section below.

This split is intentional: **`home/dot_claude/` ships content** (skills, agents, hooks, themes), **`bin/sync-claude-settings` ships flat wiring** (which hooks fire, which permissions are granted, which model is default), and **`bin/sync-claude-extras` ships extras intent** (which marketplaces/plugins/MCP servers a machine should have).

Anything that needs *registration* lives in two places at once:

| Change | Content edit | Wiring edit also required? |
| --- | --- | --- |
| New skill (`home/dot_claude/skills/<name>/SKILL.md`) | yes | no — Claude Code auto-discovers from `~/.claude/skills/` |
| New subagent (`home/dot_claude/agents/<name>.md`) | yes | no — auto-discovered from `~/.claude/agents/` |
| New hook (`home/dot_claude/hooks/executable_<name>.sh`) | yes | **yes** — register in `set_hooks` in `bin/sync-claude-settings`, or the hook is on disk but never fires |
| New permission pattern (allowing a new tool/command) | n/a | **yes** — add to `set_permissions` in `bin/sync-claude-settings` |
| New plugin / marketplace / MCP server | n/a | **yes** — add a row to `home/.chezmoidata/claude.yaml` (public) or machine-local `[data.claudeExternalExtra]`; `bin/sync-claude-extras` reconciles it via the `claude` CLI |
| Default model / feature flag change | n/a | **yes** — `set_default_model` / `set_feature_flags` in `bin/sync-claude-settings` |

ADR [0008](../adrs/0008-claude-config-two-managers.md) records this decision (and supersedes the never-implemented ADR [0004](../adrs/0004-claude-settings-management.md), which had planned to render plugins from a `settings.json` template — that would have kept racing the CLI). The two-place edit for *plugins/marketplaces/MCP* is now a single `claude.yaml` row; it remains for *hooks and permissions* by choice (tracking issue [#25](https://github.com/meaganewaller/dotfiles/issues/25)).

## Skill vs. subagent — when to use each

| Dimension | Skill (`skills/<name>/SKILL.md`) | Subagent (`agents/<name>.md`) |
| --- | --- | --- |
| Who invokes it | The user via `/<name>` | The main agent (or another agent) via the Agent tool |
| Context model | Runs in the **same** context as the conversation | Fresh, isolated context — only sees the prompt you hand it |
| Best for | Interactive workflows the human runs deliberately (commit, PR, write-skill) | Bounded research / review tasks where you want isolation, parallelism, or a different toolset |
| Frontmatter | `name`, `description`, `argument-hint`, `allowed-tools` | `name`, `description`, `tools`, `model` |
| Layout | Each skill is a directory; `SKILL.md` is the entry point, supporting files alongside | Single flat `.md` file |

Rule of thumb: if the human types it, it's a skill. If the main agent farms it out, it's a subagent.

## Skills inventory

Each entry is a directory at `home/dot_claude/skills/<name>/` containing a `SKILL.md` with YAML frontmatter:

```yaml
---
name: <invocation>            # how the user types it (without the leading `/`)
description: <one-liner>      # used for skill matching
argument-hint: "[args]"       # shown in help; optional
allowed-tools:                # tool allowlist for the skill's runtime
  - Bash(git status:*)
model: opus                   # optional model override
---
```

Current skills:

| Skill | One-liner |
| --- | --- |
| `1password` | 1Password CLI sign-in, desktop integration, and secret injection |
| `adr` | Thought partner for writing Architecture Decision Records |
| `agent-browser` | Browser automation CLI for agents (prefer over built-in browser tools) |
| `agents-md` | Bootstrap or update `AGENTS.md` for coding agents |
| `apple-notes` | Apple Notes via memo CLI (create, view, edit, delete, search, export) |
| `apple-reminders` | Apple Reminders via remindctl (list, add, edit, complete, delete) |
| `babysit-pr` | Monitor open PRs toward merge (CI, reviews, conflicts); pairs with `/loop` |
| `behavior-audit` | Compliance audit for skills, `AGENTS.md`, and hooks via scenario testing |
| `bk` | Buildkite CI helpers |
| `commit` | Conventional commits with intentional file selection |
| `copy` | Clipboard helper |
| `diff-explain` | Explain a diff in plain English (staged, commits, branches, PRs) |
| `doc` | Diátaxis-aware documentation writing |
| `export-log` / `share-log` | Export / share the current session log |
| `gfm` | GitHub-flavored Markdown helpers |
| `gitingest` | Pull a git repo's structure into context |
| `hk` | hk (Pkl-based lint manager) helpers |
| `install-tool` | Tool installation via mise (matches the `/install` policy) |
| `jira-integration` | Jira tickets via MCP or REST (fetch, update, comment, transition) |
| `mob` | Mob programming helpers |
| `pr` | Open a pull request (opens browser for final review) |
| `pr-review` | Inline PR review comments and thread replies via `gh` and GraphQL |
| `search-first` | Research-before-coding; search tools, libraries, and patterns before custom code |
| `share-plan` | Post an implementation plan to a GitHub issue |
| `split-pr` | Suggest how to split current changes into smaller, reviewable PRs |
| `tailwind-design-system` | Production Tailwind design systems (tokens, components, accessibility) |
| `think` | Trade-off analysis aligned against vision / core principles |
| `write-skill` | Author or tune a new skill |
| `write-subagent` | Author or tune a new subagent |

**First-party vs. external:** every skill above lives in source under `home/dot_claude/skills/`, so all are first-party to this repo. There is no external skill marketplace synced into this tree today; plugin marketplaces and plugins are declared in [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) and reconciled into Claude Code's own plugin store by `bin/sync-claude-extras` (see "Claude extras" below), not into `home/dot_claude/skills/`.

## Inspecting skills

`bin/skill-info` surfaces git-derived metadata for the skills above without storing anything in frontmatter:

```bash
bin/skill-info                 # all skills, newest-modified first
bin/skill-info <name>          # full history for one skill
bin/skill-info --stale 180     # skills not touched in 180+ days
```

Dates and commit subjects come from `git log --follow` on each `SKILL.md`, so the listing is always current and never drifts. Conventional-commit mood emoji (`:nail_care:`, `:sparkles:`, etc.) are rendered as the actual UTF-8 glyphs in the output.

Use it before a sweep ("which skills are stale enough to revisit?") or to recall when a behavioral change landed without scanning `git log` manually.

## Subagents inventory

Each subagent is a single `.md` file at `home/dot_claude/agents/<name>.md`:

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
| `shell-wizard` | Write clean, safe, readable shell scripts |
| `tdd-guardian` | Enforce strict TDD (RED → GREEN → MUTATE → KILL → REFACTOR) before code is written |

`reviewer` and `tdd-guardian` enforce hard role boundaries in their system prompts (e.g. "this agent must not modify any files outside of scratch/"). When extending or adding a subagent, treat the system-prompt role boundaries as load-bearing — they're what makes the agent safe to spawn unsupervised.

## Hooks

Most hooks live at `home/dot_claude/hooks/executable_*.sh`. The `executable_` chezmoi prefix preserves the `+x` bit when chezmoi writes the file out to `~/.claude/hooks/`. Each hook reads tool-call JSON on stdin and exits non-zero (or prints a decision) to block / annotate.

Registered today (wired into `settings.json` by `set_hooks` in `bin/sync-claude-settings`):

| Hook | Phase | Matches | What it does |
| --- | --- | --- | --- |
| `check-secrets.sh` | PreToolUse | `Write` / `Edit` / `MultiEdit` | Blocks file writes that look like they contain AWS keys, OpenAI/Anthropic keys, GitHub PATs, hardcoded passwords, private-key material, or literal `DATABASE_URL` postgres strings. |
| `guard-destructive.sh` | PreToolUse | `Bash` | Warns / blocks on Rails / DB destructive commands (`db:drop`, `db:reset`, `DROP TABLE`, `redis-cli FLUSHALL`, `rm -rf`, …). |
| `block-adhoc-installers` | PreToolUse | `Bash` | Denies ad-hoc installers/runners (`npx`, `bunx`, `uvx`, `pipx`, `pip install`, `npm -g`, `gem`/`brew`/`cargo`/`go install`, …) and redirects to the `/install` skill, so tools stay captured in mise. Enforcement teeth for the "use mise exclusively" rule in `~/.claude/CLAUDE.md`. Escape hatch: `CLAUDE_ALLOW_ADHOC_INSTALL=1` (human-only). |
| `migration-reminder.sh` | PostToolUse | `Write` / `Edit` (on `db/migrate/`) | After a migration is edited, prints a pre-deploy checklist (ignored_columns, schema.rb, data migrations, …). |

`block-adhoc-installers` is the one exception to the `home/dot_claude/hooks/` convention: it lives at [`home/dot_local/libexec/executable_block-adhoc-installers`](../../home/dot_local/libexec/executable_block-adhoc-installers) (→ `~/.local/libexec/`, on `PATH`) because it is a self-contained policy executable rather than a Claude-specific script, sharing the `libexec` home with `claude-powerline-theme`. `set_hooks` references it by absolute path. `set_hooks` merges its four groups in idempotently — it drops only groups containing one of *our* commands and re-appends ours, so hook groups added by plugins or the `claude` CLI survive a re-sync.

**Hook contract** (when adding one):

1. Place at `home/dot_claude/hooks/executable_<name>.sh` so chezmoi writes it executable.
2. Read tool input as JSON from stdin; parse with `jq`. Check `.tool_name` early and `exit 0` for tools you don't care about — hooks fire for every tool call.
3. Exit 0 for "allow", non-zero (with a message on stderr) for "block".
4. **Register** in `bin/sync-claude-settings` (`set_hooks`). Without this step the script is on disk at `~/.claude/hooks/` but `settings.json` never references it, so it never fires. Then `chezmoi apply` — the run_onchange wrapper re-runs the sync script when its hash changes.

## Settings split (managed vs. local)

| File | Managed by | Contents |
| --- | --- | --- |
| `~/.claude/settings.json` | `bin/sync-claude-settings` (re-runs on chezmoi apply when the sync script's hash changes) | `statusLine`, feature flags, `permissions.allow`, hook registrations, default model. Bedrock model env vars are merged in if `chezmoi data .claude.use_bedrock` is true; otherwise stripped. **Not** `extraKnownMarketplaces` / `enabledPlugins` — those are CLI-owned. |
| `extraKnownMarketplaces` / `enabledPlugins` / `mcpServers` (inside `settings.json` / `~/.claude.json`) | the `claude` CLI, driven by `bin/sync-claude-extras` from `home/.chezmoidata/claude.yaml` + machine-local `[data.claudeExternalExtra]` | which marketplaces are registered, which plugins are enabled, which MCP servers are added |
| `~/.claude/settings.local.json` | Not managed | Anything truly per-machine: experimental flags, host-specific permission additions, model overrides for that box only. |

To change a managed flat setting: edit `bin/sync-claude-settings`, then `chezmoi apply` (the wrapping `run_onchange_sync-claude-settings.sh.tmpl` re-fires on script-hash change). To change extras: edit `home/.chezmoidata/claude.yaml` (or machine-local extras), then `chezmoi apply` (the `run_onchange_sync-claude-extras.sh.tmpl` wrapper re-fires on data/script-hash change). To change a local-only setting: edit `~/.claude/settings.local.json` directly — chezmoi will not overwrite it.

## Claude extras (marketplaces, plugins, MCP servers)

`extraKnownMarketplaces`, `enabledPlugins`, and `mcpServers` are written by the `claude` CLI itself — it re-serializes them on every `claude plugin …` / `claude mcp …` call. So this repo does **not** hand-write them into `settings.json`; instead it **declares intent** and lets the CLI realize it (ADR [0008](../adrs/0008-claude-config-two-managers.md)).

- **Declared state:** [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) under `claudeData` — `marketplaces` (name + repo), `plugins` (`<id>@<marketplace>` strings), `mcpServers`. **Public only.** Private/work/machine-specific entries live in machine-local `[data.claudeExternalExtra]` in `~/.config/chezmoi/chezmoi.toml`; the reconciler merges the two.
- **Reconciler:** [`bin/sync-claude-extras`](../../bin/sync-claude-extras) reads the merged *declared* data via `chezmoi data`, and reads the *installed* state from Claude Code's own JSON files — `~/.claude/plugins/known_marketplaces.json`, `~/.claude/plugins/installed_plugins.json`, and `~/.claude.json` (MCP). It reads from those files rather than `claude … --json` because the `claude` CLI no longer exposes installed state headlessly (≥ 2.1.x: those subcommands are TTY-interactive and dropped `--json`). For each declared item not already present, it runs the matching `claude` write (`plugin marketplace add` / `plugin install --scope user` / `mcp add --scope user`). It is **idempotent and additive**: present items report `ok`; undeclared-but-installed items report `drift` and are removed only with `--prune`; built-in marketplaces (`claude-plugins-official`) and `managed`/project-scope items are never touched. A failing `claude` write warns and continues so one bad item never aborts `chezmoi apply`.
  - **Write caveat:** because `claude` plugin/MCP writes currently need an interactive (TTY) session, *adds* won't succeed under a headless `chezmoi apply`; the reconciler warns with the command to run. In the steady state (everything already installed) it just reports `ok` and makes no writes, so it runs cleanly headless.
  - `bin/sync-claude-extras --check` — dry run; print what would change.
  - `bin/sync-claude-extras --prune` — also remove user-scope extras that are not declared.
- **Re-fires** via [`home/.chezmoiscripts/run_onchange_sync-claude-extras.sh.tmpl`](../../home/.chezmoiscripts/run_onchange_sync-claude-extras.sh.tmpl), hashed over the reconciler, `claude.yaml`, and the machine-local extras.

To add a plugin: add `<id>@<marketplace>` to `claude.yaml` (and the marketplace under `marketplaces:` if new), then `chezmoi apply`. To add a private MCP server: add it under `[data.claudeExternalExtra]` in your machine-local chezmoi config, never in `claude.yaml`.

### AWS Bedrock models

`home/.chezmoi.toml.tmpl` prompts `use_bedrock` once (persisted under `[data.claude]`). When true, `bin/sync-claude-settings` calls [`bin/resolve-bedrock-models`](../../bin/resolve-bedrock-models) — which queries `aws bedrock list-foundation-models`, picks the latest active cross-region inference profile per tier (opus/sonnet/haiku, with a 24h cache), appends `[1m]` to opus/sonnet — and merges the IDs into `.env` + `.model`. When false, those Bedrock env vars are stripped and `.model` is set to the Anthropic-direct default. Resolution failures (missing `aws`, no creds) degrade gracefully: the script continues and `validate_settings` still runs.

## Adding a skill

```bash
mkdir -p home/dot_claude/skills/<name>
$EDITOR home/dot_claude/skills/<name>/SKILL.md   # add frontmatter + body
chezmoi diff && chezmoi apply
```

Then `/<name>` in any Claude Code session.

## Adding a subagent

```bash
$EDITOR home/dot_claude/agents/<name>.md         # add frontmatter + body
chezmoi diff && chezmoi apply
```

The Agent tool discovers subagents from `~/.claude/agents/`. If the description is precise, the main agent will route to it automatically.

For step-by-step prompts, this repo also ships the `write-skill` and `write-subagent` skills — they walk you through the frontmatter and constraints.

## References

- [Chezmoi workflow](chezmoi.md) — the edit / diff / apply cycle these files ride on
- [ADR 0001 — Agents need a specialized shell](../adrs/0001-specialized-agent-shell.md) — why `home/dot_zshrc.tmpl` branches when invoked under Claude Code / Cursor
- [ADR 0008 — Claude config: two managers](../adrs/0008-claude-config-two-managers.md) — why settings vs. extras are managed by two scripts
- [Claude Code docs](https://docs.anthropic.com/claude-code) — upstream feature reference
- [`bin/sync-claude-settings`](../../bin/sync-claude-settings) — source of truth for the managed flat `settings.json` surface
- [`bin/sync-claude-extras`](../../bin/sync-claude-extras) + [`home/.chezmoidata/claude.yaml`](../../home/.chezmoidata/claude.yaml) — declarative marketplaces / plugins / MCP servers, reconciled via the `claude` CLI
