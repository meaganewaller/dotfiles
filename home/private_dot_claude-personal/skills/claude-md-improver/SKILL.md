---
name: claude-md-improver
description: Audit and improve Claude Code memory surfaces (CLAUDE.md, rules, and auto memory) using the official memory docs as source of truth
argument-hint: "[audit | improve | compact | troubleshoot] [optional-scope]"
model: sonnet
context: default
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - Write
  - Bash(find:*)
  - Bash(ls:*)
  - Bash(wc -l:*)
  - Bash(wc -c:*)
  - Bash(chezmoi diff:*)
  - Bash(chezmoi status:*)
---

# Claude Memory Surface Audit and Improvement

Use this skill to audit and improve Claude Code memory surfaces in a repository.

Source of truth:
- https://code.claude.com/docs/en/memory.md

This skill treats the memory docs above as authoritative for behavior, limits, and precedence.

## Arguments

`$ARGUMENTS`

Modes:
- `audit`: inspect current memory surfaces and report findings
- `improve`: make targeted edits and cleanup
- `compact`: reduce size/noise in CLAUDE.md and rules
- `troubleshoot`: diagnose why instructions are not being followed

Optional scope examples:
- `project`
- `user`
- `rules`
- `auto-memory`

## Core facts to enforce

1. CLAUDE.md and auto memory are context, not hard enforcement.
2. Use hooks/settings for strict enforcement (not CLAUDE.md wording alone).
3. Keep CLAUDE.md concise and specific (target under 200 lines per file).
4. Auto memory startup load is only the first 200 lines or 25KB of MEMORY.md.
5. Topic files in auto memory are loaded on demand, not at session startup.
6. Conflicting instructions across memory surfaces reduce adherence.
7. Rules in .claude/rules can scope instructions by `paths` frontmatter.

## Audit workflow

1. Inventory memory surfaces.
	- Project: `./CLAUDE.md`, `./.claude/CLAUDE.md`, `./CLAUDE.local.md`
	- Rules: `./.claude/rules/**/*.md`
	- User/account scope: `~/.claude-*/CLAUDE.md`, `~/.claude-*/rules/**/*.md` (if accessible)
	- Managed policy (if applicable to machine):
	  - macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`
	  - Linux/WSL: `/etc/claude-code/CLAUDE.md`
	  - Windows: `C:\Program Files\ClaudeCode\CLAUDE.md`
	- Auto memory: `~/.claude-*/projects/<project>/memory/MEMORY.md` and topic files

2. Validate load intent and scope.
	- Confirm high-level instructions live in top-level CLAUDE.md.
	- Confirm narrow guidance is in path-scoped rules.
	- Confirm personal, repo-local preferences are in CLAUDE.local.md or user scope.
	- Flag instructions that belong in hooks/settings rather than memory text.

3. Check quality and token efficiency.
	- Count lines/bytes for each CLAUDE.md and MEMORY.md.
	- Flag vague instructions (for example: "format nicely", "test thoroughly").
	- Flag duplicate and contradictory rules.
	- Flag codebase-derivable content that does not need to be in memory.

4. Check import hygiene.
	- Find `@path` imports.
	- Verify imported files exist and are still relevant.
	- Flag external imports that may require trust/approval awareness.

5. Check auto memory structure.
	- Ensure MEMORY.md behaves like an index (brief entries, one line per memory).
	- Ensure details are in topic files, not in a bloated index.
	- Note stale memories that should be merged or removed.

## Improvement workflow

1. Normalize instruction placement.
	- Keep always-on project standards in project CLAUDE.md.
	- Move specialized guidance to `.claude/rules/` files.
	- Add `paths` frontmatter for directory/file-type-specific rules.

2. Rewrite for specificity.
	- Convert vague statements into verifiable instructions.
	- Include concrete commands/paths where useful.
	- Remove contradictory wording.

3. Reduce startup context load.
	- Trim repeated or low-value prose.
	- Keep background rationale brief.
	- Prefer pointers to source docs over duplicating large sections.

4. Strengthen enforcement boundaries.
	- For must-run checks, recommend hooks.
	- For deny/allow policy, recommend settings/managed policy.
	- Keep CLAUDE.md focused on behavioral guidance.

5. Clean auto memory responsibly.
	- Keep MEMORY.md concise and index-like.
	- Consolidate stale topics.
	- Preserve high-signal facts (user preferences, durable project context, feedback loops).

## Troubleshooting checklist

When instructions are not followed:
1. Verify files are in loadable locations.
2. Check for conflicting ancestor/local/rule instructions.
3. Confirm instructions are concrete enough to execute.
4. Recommend `/context` to verify loaded memory files.
5. Recommend `/memory` to inspect/edit memory files.
6. If behavior must be mandatory, move to hooks/settings.

## Output contract

For every run, produce:
1. Findings table:
	- file
	- issue type (conflict, vague, stale, oversize, misplaced, derivable)
	- severity (high/medium/low)
	- recommended fix
2. Proposed edits (or applied edits, if asked to modify now).
3. Residual risks and follow-ups.

## Editing rules

1. Do not invent memory behavior not documented in the source-of-truth page.
2. Prefer minimal, reviewable edits over large rewrites.
3. Preserve existing project conventions unless they conflict with documented behavior.
4. When uncertain, report assumptions explicitly and request confirmation.

## Quick prompts

- `/claude-md-improver audit project`
- `/claude-md-improver improve rules`
- `/claude-md-improver compact`
- `/claude-md-improver troubleshoot`
