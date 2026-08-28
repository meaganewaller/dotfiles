---
name: review-feedback
description: Evaluate and verify code review feedback before implementing any suggestions
argument-hint: "[review summary or link optional]"
model: sonnet
context: default
allowed-tools:
  - Read
  - Glob
  - Grep
  - AskUserQuestion
  - Bash(ls:*)
  - Bash(find:*)
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(git show:*)
  - Bash(git log:*)
  - Bash(rg:*)
  - Bash(bats:*)
  - Bash(npm test:*)
  - Bash(pnpm test:*)
  - Bash(go test:*)
  - Bash(pytest:*)
---

# Review Feedback Validation

Use this skill when receiving code review feedback from CodeRabbit, Copilot, a human PR reviewer, or any other review source.

Run this skill before implementing any suggestions, especially if feedback is unclear, contradictory, or technically questionable.

This skill requires technical rigor and verification, not performative agreement or blind implementation.

## When to use

Use when the user asks to:
- address review comments
- apply PR feedback
- evaluate reviewer suggestions
- respond to uncertain or disputed review points
- triage bot review comments versus human comments

## Core principles

1. Validate first, implement second.
2. Treat each suggestion as a hypothesis until proven.
3. Require evidence from code, tests, docs, or reproducible behavior.
4. Prefer minimal, correct fixes over broad rewrites.
5. Reject incorrect suggestions clearly and respectfully with rationale.

## Required workflow

1. Collect feedback items.
- Parse every comment into a discrete item.
- Capture source, file location, and claimed problem.

2. Classify each item.
- correctness bug
- reliability or edge case
- performance
- security
- maintainability or readability
- style only
- uncertain or ambiguous

3. Verify technically before changing code.
- Inspect the referenced code paths.
- Check surrounding constraints and invariants.
- Reproduce behavior when possible.
- Run focused tests or static checks relevant to the claim.

4. Decide per item.
- accept: feedback is correct and should be implemented
- partial: concern is valid but proposed fix is not ideal
- reject: concern is incorrect, obsolete, or out of scope
- defer: insufficient context, needs explicit user decision

5. Produce an implementation plan only for accepted or partial items.
- sequence by risk and dependency
- include exact files and tests to touch
- include rollback-safe order for risky changes

6. Ask for approval before implementation when there are tradeoffs.

## Output contract

Return results in this structure:

1. Review Findings
- one row per feedback item with:
  - source
  - summary
  - severity
  - verdict: accept, partial, reject, defer
  - evidence

2. Proposed Changes
- concrete edits for accepted or partial items
- file-level impact map

3. Verification Plan
- exact commands to run
- expected outcomes

4. Open Questions
- decisions needed from user

5. Suggested Reviewer Response
- concise response drafts for each rejected or deferred item

## Severity guidance

Use this scale:
- high: correctness, data loss, security, or production risk
- medium: likely bug, reliability, or meaningful maintainability risk
- low: style or optional refactor with no behavior change

## Anti-patterns to avoid

1. Do not rubber-stamp bot feedback.
2. Do not make speculative fixes without reproducing or proving the issue.
3. Do not collapse distinct comments into one vague task.
4. Do not ignore valid reviewer intent when wording is imperfect.
5. Do not present uncertainty as fact.

## Fast path

If feedback is clearly correct and low risk:
1. confirm evidence quickly
2. propose minimal patch
3. run targeted verification
4. report before and after behavior

## Example prompts

- /review-feedback Triage these Copilot and human PR comments before edits.
- /review-feedback Validate CodeRabbit findings and propose only proven fixes.
- /review-feedback Review this feedback list and draft responses for rejects.
