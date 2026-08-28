---
name: plan-mode
description: EnterPlanMode planning skill that explores the codebase and writes specific actionable implementation plans for user approval
argument-hint: "[task context optional]"
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
  - Bash(git status:*)
  - Bash(git branch:*)
  - Bash(git rev-parse:*)
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(rg:*)
  - Bash(rg --files:*)
---

# Plan Mode Orchestrator

Use this skill when entering plan mode (EnterPlanMode) to explore a codebase and write a specific, actionable implementation plan for user approval.

Use this skill whenever the user enters plan mode, or proactively when the task has planning weight even without explicit plan-mode language.

## Trigger conditions

Always trigger when:
- EnterPlanMode is active

Also trigger proactively when any of these are true:
- Task touches 3 or more files
- Task makes architectural choices
- Task modifies subsystem boundaries
- Task refactors across modules
- Task implements a feature spanning multiple layers

## Purpose

1. Convert ambiguous implementation asks into a concrete execution plan.
2. Surface assumptions, risks, and decision points before code edits.
3. Produce a plan that is specific enough for immediate execution after approval.

## Required behavior

1. Explore relevant code paths before planning.
2. Identify impacted files/modules and dependency edges.
3. Enumerate viable implementation approaches when there are tradeoffs.
4. Select an appropriate planning variant automatically.
5. Present one recommended plan with rationale.
6. Ask for explicit user approval before implementation.

## Automatic variant selection

Choose one or combine multiple variants based on task shape:

1. Single-session plan
- Use when scope is narrow and can be completed in one focused pass.
- Output includes concise ordered steps and verification.

2. TDD-structured plan
- Use when behavior change is non-trivial or regression risk is medium/high.
- Output uses RED -> GREEN -> REFACTOR with test scope and checkpoints.

3. Agent-team multi-file plan
- Use when 3+ files, cross-module changes, or layered feature work is involved.
- Output partitions workstreams by area, defines integration points, and sequencing.

4. Hybrid plan
- Use when task needs both TDD rigor and multi-file coordination.
- Output combines workstream partitioning with per-stream RED/GREEN/REFACTOR loops.

## Discovery workflow

1. Clarify objective and non-goals from user request.
2. Locate likely entry points, call paths, and config/data contracts.
3. Map impacted files and classify each as:
- direct edit
- indirect dependency
- test or fixture
- docs or migration surface
4. Identify constraints from tooling, architecture, and existing conventions.
5. Capture unknowns requiring user input before implementation.

## Plan output contract

Return plan in this structure:

1. Goal
- one paragraph max

2. Scope
- in scope bullets
- out of scope bullets

3. Impact map
- file/module list with why each is affected

4. Approach options
- option A, option B (if relevant)
- recommendation and rationale

5. Execution plan
- ordered steps with concrete actions
- include where tests are added or updated

6. Verification plan
- exact commands/checks
- expected outcomes

7. Risks and mitigations
- top risks and containment strategy

8. Open questions
- blocking decisions needing user input

9. Approval gate
- explicit prompt asking user to approve or adjust the plan

## Quality bar

Plans must be:
- Specific: include exact files/modules when known
- Actionable: each step can be executed without reinterpretation
- Minimal-risk: call out migration and rollback concerns
- Verifiable: include objective checks, not vague statements

## TDD requirements when TDD variant is selected

1. RED
- define failing tests first
- state what failure proves

2. GREEN
- smallest code change to pass tests

3. REFACTOR
- cleanup with tests still green
- preserve behavior and interfaces unless intentionally changed

## Multi-file coordination requirements when team variant is selected

1. Partition work into streams (for example API, domain, persistence, UI, docs/tests).
2. Define contracts each stream depends on.
3. Sequence streams to avoid merge conflicts and deadlocks.
4. Include integration checkpoints between streams.

## Constraints

1. Do not start implementation while in planning mode unless user explicitly approves.
2. Do not propose broad rewrites when targeted edits can satisfy requirements.
3. Do not omit tests when behavior changes.
4. Do not hide uncertainty; surface assumptions explicitly.

## Example prompts

- /plan-mode Add audit logging for billing retries across API, service, and DB layers.
- /plan-mode Refactor auth token validation shared across CLI and web handlers.
- /plan-mode Plan a TDD rollout for rate-limit backoff behavior.
