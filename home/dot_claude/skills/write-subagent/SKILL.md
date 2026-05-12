---
name: write-subagent
description: Use when the user wants to create a new Claude Code subagent, add an autonomous agent markdown file, tune agent frontmatter (name, description, model, tools), or needs a guided workflow with prompts and constraints for agent authoring in dotfiles or a project.
argument-hint: "[global|local] [agent-name-or-role...]"
model: sonnet
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Bash(chezmoi apply:*)
  - Bash(chezmoi diff:*)
  - Bash(chezmoi status:*)
---

# Write Claude Code Subagent

Turn a vague idea into a **single, well-scoped** agent definition: correct frontmatter, tight tool allowlist, and a system prompt the parent model can delegate to safely.

## Arguments

```
$ARGUMENTS
```

## Hard constraints (do not relax without explicit user approval)

1. **One job per agent** — If the user asks for “review + fix + test + deploy,” split into multiple agents or refuse the combo; compound agents trigger unpredictably and over-scope tools.
2. **Least-privilege tools** — Default to read-only (`Read`, `Grep`, `Glob`, `WebSearch`/`WebFetch` only if justified). Add `Write` / `Edit` / `Bash` only when the agent’s charter requires mutating disk or running commands—and narrow `Bash(...)` patterns when possible.
3. **Explicit boundaries** — Every agent body must state what it **will not** do (directories, destructive commands, production edits, skipping validation, etc.). Copy the tone from existing agents in this dotfiles tree (see `home/dot_claude/agents/`).
4. **`name` field** — Lowercase, hyphens, 3–50 chars, alphanumeric at start/end (e.g. `api-auditor`, not `helper` or `my_agent`).
5. **`description` field** — Must make triggering obvious (“Use this agent when …”). Prefer 2–4 short `<example>` blocks (Context / user / assistant / `<commentary>`) when the user needs reliable auto-routing; if the agent is invoke-only, say so plainly and skip examples.
6. **No secret data in the agent file** — No API keys, tokens, or private URLs; reference env vars or secret stores instead.

## Scope: where the file lives

| Scope | Path |
| --- | --- |
| **global** (default for dotfiles users) | `home/dot_claude/agents/<name>.md` under the Chezmoi source tree (same pattern as `home/dot_claude/skills/`). |
| **local** | `.claude/agents/<name>.md` in the **current** project (only if the user asked for local or the work is clearly repo-specific). |

If scope is missing, ask once:

> Should this agent be **global** (managed in dotfiles / `home/dot_claude/agents/`) or **local** (this repo’s `.claude/agents/` only)?

## Process

### 1. Compress the intent (before writing)

Ask only what you need—**max 5 questions**, one message, numbered:

1. **Trigger** — In one sentence: when should the parent *spawn* this agent vs handle the task itself?
2. **Inputs** — What does the agent assume it receives (paths, tickets, URLs, prior command output)?
3. **Outputs** — What artifact does the user get back (report structure, diff summary, checklist, files under `scratch/` only, etc.)?
4. **Risk** — Network? Git writes? Production? User data? Anything that must be **forbidden**?
5. **Model** — Prefer `inherit` unless the user needs `sonnet` / `opus` / `haiku` for cost or capability reasons.

If the user already answered these in chat, **do not re-ask**; restate assumptions in one short paragraph and proceed.

### 2. Choose tools (forced tradeoff)

Present a **Tool set** table:

| Tier | Tools | When |
| --- | --- | --- |
| A — Read-only | `Read`, `Grep`, `Glob` | Analysis, review, research, search |
| B — Read + web | A + `WebSearch`, `WebFetch` | External docs, CVEs, vendor behavior |
| C — Repo edits | B + `Write`, `Edit` | Scaffolding, config, non-production paths the user names |
| D — Execution | C + `Bash` (tight patterns) | Tests, formatters, codegen—**only** with explicit allowed commands |

Default to **A**; moving up a tier requires a one-line user justification recorded in the agent body under **Tooling policy**.

### 3. Draft the markdown

Use this skeleton (adjust sections; delete examples if invoke-only):

```markdown
---
name: <kebab-case-name>
description: |
  Use this agent when <clear conditions>. Examples:

  <example>
  Context: <where / what repo state>
  user: "<representative request>"
  assistant: "<delegate to this agent because …>"
  <commentary>
  <why this agent matches>
  </commentary>
  </example>

  <example>
  ...
  </example>
tools: [<minimal list>]
model: inherit
color: <blue|cyan|green|yellow|magenta|red>
---

# <Short title>

## Role
You are …

## In scope
1. …

## Out of scope (hard)
- …

## Procedure
1. …

## Output format
- …
```

**Color:** analysis/review → blue/cyan; validation/caution → yellow; security/critical → red; generation/creative → magenta; “success path” tasks → green.

### 4. Self-check before saving

- [ ] `name` matches pattern; file name matches `name` (e.g. `risk-audit.md` ↔ `risk-audit`).
- [ ] `description` states **when not** to use the agent if confusion is likely.
- [ ] Tools are minimal; `Bash` is absent or narrowly scoped.
- [ ] Body repeats **forbidden** actions (paths, side effects) in a bulleted **Out of scope** block.
- [ ] No secrets; no vague “use your judgment” without concrete stop conditions.

### 5. Write and hand off

- Write the file to the path from the scope table.
- Tell the user to run `chezmoi diff` / `chezmoi apply` for **global** agents.
- If the agent can modify repos or run commands, suggest spawning the existing **reviewer** agent (or a read-only pass) on the new file before relying on it in production workflows.

## Anti-patterns (call these out if the user asks for them)

- **Kitchen-sink agents** — Too many tools or responsibilities; split instead.
- **Implicit write access** — `Write` “just in case”; remove until needed.
- **Unbounded Bash** — `Bash(*)` without subagent-specific limits.
- **Vague description** — “Use for coding tasks” (never triggers correctly).
- **Duplicating project docs** — Prefer “Read `AGENTS.md` / `CLAUDE.md` first” over pasting long repo rules.

## Reference

- In-repo examples: `home/dot_claude/agents/reviewer.md`, `home/dot_claude/agents/pr-feedback-reviewer.md`, `home/dot_claude/agents/shell-wizard.md`.
- Skill authoring (parallel patterns): `home/dot_claude/skills/write-skill/SKILL.md`.
