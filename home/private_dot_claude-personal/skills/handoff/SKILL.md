---
name: handoff
description: Write a self-contained session handoff document so a fresh session can resume work from one file
argument-hint: "[target-file optional]"
model: sonnet
context: default
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - Write
  - AskUserQuestion
  - Bash(ls:*)
  - Bash(find:*)
  - Bash(pwd:*)
  - Bash(date:*)
  - Bash(git status:*)
  - Bash(git branch:*)
  - Bash(git rev-parse:*)
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(gh pr:*)
  - Bash(gh issue:*)
  - Bash(bd ready:*)
  - Bash(bd show:*)
---

# Session Handoff (Write Side)

Write a self-contained handoff document so a FRESH session can resume work by reading one file.

Built for `/clear` (full reset), not compaction.

The `pickup` skill is the read side.

## Use this skill when

Use when the user says things like:
- "hand off"
- "write a handoff"
- "save the session"
- "I'm going to clear"
- "dump context before I clear"
- "checkpoint this so I can pick it up later"
- or wants to end a session without losing progress

## Arguments

`$ARGUMENTS` optionally sets the output file path.

Default output path when omitted:
- `SESSION_HANDOFF.md` at repo root

If not in a git repo, use:
- `SESSION_HANDOFF.md` in current working directory

## Required output content

The handoff file must include all sections below in this order:

1. `Goal`
2. `Current Status`
3. `What Changed`
4. `Next Steps`
5. `Key Files`
6. `Decisions and Rationale`
7. `Verification`
8. `Linked Context`
9. `Open Tasks`
10. `Risks / Unknowns`
11. `Quickstart for Next Session`

## Beads-aware task policy

Detect whether this is a beads repo.

Treat it as beads-managed only when both are true:
1. `.beads/` exists in the repo
2. `bd` command is available

If beads-managed:
- `Open Tasks` must list beads IDs (for example `dotfiles-123`), not ad hoc markdown TODOs.
- Prefer pulling IDs from `bd ready` and include short status notes.
- If a known task was worked in-session, include that ID even if not in `bd ready`.

If not beads-managed:
- Use a markdown checklist for open tasks.

## Workflow

1. Determine project root and branch/commit context.
2. Summarize user goal and current progress.
3. Capture concrete next actions in execution order.
4. Record key files with purpose notes.
5. Record important decisions and why they were made.
6. Add exact verification commands and current known results.
7. Link PR/issue context when available.
8. Populate `Open Tasks` using beads IDs when applicable.
9. Add a minimal quickstart the next agent can run immediately.
10. Write the file atomically in one pass.

## Linked context rules

Include links only when known, never fabricate:
- GitHub PR URL
- GitHub issue URL
- Beads issue IDs
- Relevant local docs or runbooks

If unknown, write `None`.

## Quality bar

The handoff must be:
- Self-contained: no hidden assumptions
- Actionable: next agent can execute immediately
- Concise: high signal, low narrative
- Verifiable: commands are copy-pastable and specific

## Template

Use this template exactly:

```markdown
# Session Handoff

## Goal
- <1-3 bullets>

## Current Status
- <what is done>
- <what is in progress>
- <what is blocked>

## What Changed
- <code/config/docs/test changes>

## Next Steps
1. <next action>
2. <next action>
3. <next action>

## Key Files
- <path>: <why it matters>
- <path>: <why it matters>

## Decisions and Rationale
- <decision>: <why>

## Verification
- Ran:
  - `<command>` -> <result>
- Pending:
  - `<command>`

## Linked Context
- PR: <url or None>
- Issue: <url or None>
- Other: <url/path or None>

## Open Tasks
- <beads repo: beads IDs with brief note>
- <non-beads repo: markdown checklist item>

## Risks / Unknowns
- <risk or unknown>

## Quickstart for Next Session
1. Open `<handoff file path>`.
2. Run verification command(s): `<command>`.
3. Continue with `Next Steps` item 1.
```

## Constraints

- Do not write fictional results.
- Do not mark pending work as complete.
- Do not create markdown TODOs in beads-managed repos when a beads ID exists.
- Do not optimize for prose; optimize for handoff utility.
