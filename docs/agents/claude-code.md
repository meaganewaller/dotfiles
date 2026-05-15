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

- `~/.claude/settings.json` — generated and refreshed at runtime by [`bin/sync-claude-settings`](../../bin/sync-claude-settings), invoked from `home/.chezmoiscripts/run_onchange_sync-claude-settings.sh.tmpl`. The script sets `statusLine`, feature flags, the global `permissions` allowlist, hook registrations, plugin marketplaces, and the default model — and validates the result is still parseable JSON.
- `~/.claude/settings.local.json` — machine-local overlay. Not managed; deliberately left to the user / host.

This split is intentional: **`home/dot_claude/` ships content** (skills, agents, hooks, themes), and **`bin/sync-claude-settings` ships wiring** (which hooks fire, which permissions are granted, which model is default). Either side can change without disturbing the other.

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
| `adr` | Thought partner for writing Architecture Decision Records |
| `agents-md` | Bootstrap or update `AGENTS.md` for coding agents |
| `bk` | Buildkite CI helpers |
| `commit` | Conventional commits with intentional file selection |
| `copy` | Clipboard helper |
| `doc` | Diátaxis-aware documentation writing |
| `export-log` / `share-log` | Export / share the current session log |
| `gfm` | GitHub-flavored Markdown helpers |
| `gitingest` | Pull a git repo's structure into context |
| `hk` | hk (Pkl-based lint manager) helpers |
| `install-tool` | Tool installation via mise (matches the `/install` policy) |
| `mob` | Mob programming helpers |
| `pr` | Open a pull request (opens browser for final review) |
| `share-plan` | Post an implementation plan to a GitHub issue |
| `think` | Trade-off analysis aligned against vision / core principles |
| `write-skill` | Author or tune a new skill |
| `write-subagent` | Author or tune a new subagent |

**First-party vs. external:** every skill above lives in source under `home/dot_claude/skills/`, so all are first-party to this repo. There is no external skill marketplace synced into this tree today; plugin marketplaces are registered in the runtime `settings.json` via `bin/sync-claude-settings` (e.g. `pickled-claude-plugins`), but those install into Claude Code's own plugin store, not into `home/dot_claude/skills/`.

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

Hooks live at `home/dot_claude/hooks/executable_*.sh`. The `executable_` chezmoi prefix preserves the `+x` bit when chezmoi writes the file out to `~/.claude/hooks/`. Each hook reads tool-call JSON on stdin and exits non-zero (or prints) to block / annotate.

Registered today (wired into `settings.json` by `bin/sync-claude-settings`):

| Hook | Phase | Matches | What it does |
| --- | --- | --- | --- |
| `check-secrets.sh` | PreToolUse | `Write` / `Edit` / `MultiEdit` | Blocks file writes that look like they contain AWS keys, OpenAI/Anthropic keys, GitHub PATs, hardcoded passwords, private-key material, or literal `DATABASE_URL` postgres strings. |
| `guard-destructive.sh` | PreToolUse | `Bash` | Warns / blocks on Rails / DB destructive commands (`db:drop`, `db:reset`, `DROP TABLE`, `redis-cli FLUSHALL`, `rm -rf`, …). |
| `migration-reminder.sh` | PostToolUse | `Write` / `Edit` (on `db/migrate/`) | After a migration is edited, prints a pre-deploy checklist (ignored_columns, schema.rb, data migrations, …). |

**Hook contract** (when adding one):

1. Place at `home/dot_claude/hooks/executable_<name>.sh` so chezmoi writes it executable.
2. Read tool input as JSON from stdin; parse with `jq`. Check `.tool_name` early and `exit 0` for tools you don't care about — hooks fire for every tool call.
3. Exit 0 for "allow", non-zero (with a message on stderr) for "block".
4. Add the registration in `bin/sync-claude-settings` (`set_hooks`) so it's actually wired in `settings.json`.

## Settings split (managed vs. local)

| File | Managed by | Contents |
| --- | --- | --- |
| `~/.claude/settings.json` | `bin/sync-claude-settings` (re-runs on chezmoi apply when the sync script's hash changes) | `statusLine`, feature flags, `permissions.allow`, hook registrations, plugin marketplaces, default model. Bedrock model env vars are merged in if `chezmoi data .claude.use_bedrock` is true; otherwise stripped. |
| `~/.claude/settings.local.json` | Not managed | Anything truly per-machine: experimental flags, host-specific permission additions, model overrides for that box only. |

To change a managed setting: edit `bin/sync-claude-settings`, then `chezmoi apply` (the wrapping `run_onchange_sync-claude-settings.sh.tmpl` re-fires on script-hash change). To change a local-only setting: edit `~/.claude/settings.local.json` directly — chezmoi will not overwrite it.

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
- [Claude Code docs](https://docs.anthropic.com/claude-code) — upstream feature reference
- [`bin/sync-claude-settings`](../../bin/sync-claude-settings) — the source of truth for managed `settings.json` content
