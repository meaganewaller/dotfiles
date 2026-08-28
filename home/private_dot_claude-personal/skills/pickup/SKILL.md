---
name: pickup
description: Resume work from a session-handoff document written by the handoff skill
argument-hint: "[slug | date | handoff-file-path optional]"
model: sonnet
context: default
allowed-tools:
  - Read
  - Glob
  - Grep
  - AskUserQuestion
  - Bash(ls:*)
  - Bash(find:*)
  - Bash(pwd:*)
  - Bash(date:*)
  - Bash(stat:*)
  - Bash(git status:*)
  - Bash(git branch:*)
  - Bash(git rev-parse:*)
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(git remote -v:*)
  - Bash(gh pr:*)
  - Bash(gh issue:*)
  - Bash(bd ready:*)
  - Bash(bd show:*)
---

# Session Pickup (Read Side)

Resume work from a session handoff document written by the `handoff` skill.

Agent-agnostic: works for Claude, Codex, and lu.

Built for fresh sessions, especially right after `/clear`.

## Use this skill when

Use when the user says things like:
- "pick up"
- "pick up where I left off"
- "resume"
- "resume the session"
- "continue the last session"
- "load the handoff"
- "what was I doing"
- or invokes this at session start after `/clear`

## Arguments

`$ARGUMENTS` may be empty or include one target selector.

No argument:
- Find the NEWEST handoff for the current repo.

With argument:
- Treat as a target selector in this order:
  1. Existing file path
  2. Slug match in filename
  3. Date token (for example `2026-08-28`) match in filename/content

If multiple matches remain, ask the user to choose.

## Handoff discovery rules

1. Resolve repo root with git when available.
2. Search likely handoff locations in priority order:
   - repo root: `SESSION_HANDOFF.md`
   - repo root: `**/*handoff*.md`
   - repo root: `**/SESSION_HANDOFF*.md`
3. Exclude obvious noise paths (for example `.git/`, `node_modules/`, build artifacts).
4. Pick newest by modified time when no explicit target is provided.

If no handoff is found, stop and ask whether to:
1. continue without handoff, or
2. run write-side `handoff` first in the previous session next time.

## What pickup must do

1. Read the selected handoff doc fully.
2. Extract and restate:
   - Goal
   - Current Status
   - Next Steps
   - Verification commands
   - Linked Context
   - Open Tasks
   - Risks / Unknowns
3. Rebuild an execution-ready todo list from `Next Steps` and `Open Tasks`.
4. Rehydrate beads tasks to LIVE state when in a beads repo.
5. Verify repository state before continuing.

## Beads rehydration policy

Treat as beads-managed only when both are true:
1. `.beads/` exists
2. `bd` command is available

When beads-managed:
1. Parse beads IDs from `Open Tasks`.
2. Refresh each with `bd show <id>`.
3. Prefer LIVE beads status over stale handoff text.
4. If an ID from handoff no longer exists, flag clearly and ask user how to proceed.
5. Use beads IDs as the source of truth for task state.

When not beads-managed:
- Use markdown checklist tasks from handoff as the working todo list.

## Repository verification checklist

Before executing next work, verify:
1. Current repo root and branch.
2. Dirty/clean working tree (`git status --short`).
3. Whether handoff references files that exist.
4. Whether verification commands are safe and runnable.
5. Whether linked PR/issue still exists (when URLs are provided and tooling is available).

Report mismatches explicitly (for example: branch drift, missing files, failed checks).

## Output contract

After reading and verification, respond with:

1. `Pickup Summary`
   - one-paragraph summary of what was being done
2. `Ready Todo List`
   - ordered actionable steps for this session
3. `Live Task State`
   - beads IDs + status if beads-managed
   - checklist state otherwise
4. `Repo Check`
   - branch, dirty state, key mismatches
5. `Proposed First Action`
   - exactly one concrete next command/action

## Safety and correctness rules

1. Do not assume handoff state is current; always verify before acting.
2. Do not fabricate PR/issue/task status.
3. Prefer explicit user confirmation when verification reveals drift.
4. Keep pickup output concise and execution-focused.
5. If handoff omits critical info, call it out and propose the minimum recovery steps.

## Fast path

If handoff is recent, repo matches, and tasks are clear:
1. Provide pickup summary.
2. Present the ready todo list.
3. Start executing `Proposed First Action` after user confirmation.
