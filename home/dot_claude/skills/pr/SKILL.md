---
name: pr
description: Use when creating a pull request. Opens PR in browser for review.
argument-hint: "[additional context]"
model: sonnet
allowed-tools:
  - Glob
  - Read
  - Bash(~/.claude/skills/pr/claude-session-gist:*)
---

# Create Pull Request

Opens a pull request in the browser for final review and submission.

## Arguments

```
$ARGUMENTS
```

Optional context to incorporate into the PR description - details not covered in commits, important considerations, areas needing attention, or anything to emphasize for reviewers.

## Instructions

### 1. Check for PR Template

Search for templates in order of precedence:

```
.github/pull_request_template.md
.github/PULL_REQUEST_TEMPLATE/*.md
pull_request_template.md
PULL_REQUEST_TEMPLATE/*.md
docs/pull_request_template.md
docs/PULL_REQUEST_TEMPLATE/*.md
```

If multiple templates exist in a `PULL_REQUEST_TEMPLATE/` directory, list them and ask which to use.

### 2. Gather Context

Run in parallel:
- `git status` - check for uncommitted changes
- `git log --oneline @{upstream}..HEAD 2>/dev/null || git log --oneline -10` - commits to include
- `git diff --stat @{upstream}..HEAD 2>/dev/null || git diff --stat HEAD~5..HEAD` - files changed

If there are staged changes ready to commit, ask whether to commit first or proceed.
If there are only untracked files (not relevant to the PR), proceed without asking.

### 3. Draft PR Content

**Title:** Derive from branch name or commits. Use conventional format if repo follows it. End with a mood emoji that reflects the vibe of the conversation or task.

Palette (use these or any GitHub emoji that fits):

| Emoji | Shortcode | Mood |
|-------|-----------|------|
| :sparkles: | `:sparkles:` | excited about something new |
| :tada: | `:tada:` | celebration, milestone |
| :fire: | `:fire:` | on a roll, crushing it |
| :bug: | `:bug:` | squashing something annoying |
| :face_with_spiral_eyes: | `:face_with_spiral_eyes:` | confused, dizzy, "what even is this" |
| :rage: | `:rage:` | frustrated, fighting the tools |
| :relieved: | `:relieved:` | finally fixed, weight off shoulders |
| :broom: | `:broom:` | tidying up, chores |
| :thinking: | `:thinking:` | exploratory, not sure yet |
| :coffin: | `:coffin:` | killing dead code, removing things |
| :rocket: | `:rocket:` | shipping, deploying, launching |
| :nail_care: | `:nail_care:` | polish, aesthetics, making it pretty |

```markdown
## Why

[Problem/motivation - 1-3 sentences]

## What

[Approach - brief, not a code walkthrough]

## Notes for reviewers

[Non-obvious decisions, areas of uncertainty, or "looks wrong but isn't" explanations]

---

🤖 [Conversation log](GIST_URL)
```

The trailing horizontal rule and `🤖 [Conversation log]` line are **conditional** — include them only if the gist step in 3.1 actually produced a URL. For blocklisted repositories (see below), omit both entirely.

If user provided additional context in arguments, incorporate it appropriately into the PR body.

Draft the content but don't show it to the user for approval - proceed directly to creation.

### 3.1 Export Conversation Log and Create Gist

Publish the current session through the gist shim, which extracts **only the current session** and pipes it to a secret Gist:

```bash
~/.claude/skills/pr/claude-session-gist "${CLAUDE_SESSION_ID}"
```

The shim:
- Takes the current session ID (provided by the `${CLAUDE_SESSION_ID}` substitution)
- **Checks the current repo's git remote against the gist blocklist first** (work repos whose conversation logs must never leave the machine — defined in `home/.chezmoidata/pr.yaml`, rendered into the shim at `chezmoi apply` time)
- For a **blocklisted** repo: refuses before extracting or uploading anything — prints an explanation to stderr, exits `3`, and writes **nothing to stdout**
- Otherwise: extracts with `--detailed` output, pipes directly to `gh gist create` (secret by default), and prints **only the Gist URL** to stdout

**Handle the result:**
- **Got a URL on stdout** → include it in the PR body after the horizontal rule.
- **Exit code 3 / no URL** → the repo is blocklisted. Do **not** retry, do **not** attempt extraction another way. Omit the horizontal rule and `🤖 [Conversation log]` line from the PR body, and note in the final report that the conversation log was skipped because this repository is on the gist blocklist.

This is a hard guarantee enforced by the shim, not just a guideline — never work around it.

### 4. Push and Create PR

**Push first:** If the branch hasn't been pushed or is behind:
```bash
git push -u origin <branch-name>
```

**Then create PR using the shim:**

```bash
~/.claude/skills/pr/gh-pr-create-web --title "..." --body "..."
```

The shim automatically adds `--web`, ensuring PRs open in browser for human review. Do NOT add `--web` yourself—the shim handles it.

### 5. Report Result

Simply note that the PR creation command was executed. The browser will open automatically for final review.

## Examples

```
/pr                                           → Standard PR, opens browser
/pr This needs careful review of the DB migrations → Emphasizes DB migration review
/pr The API changes are breaking but documented    → Highlights breaking changes
```

## Edge Cases

- **No upstream:** Ask for base branch
- **Empty diff:** Warn and confirm before creating empty PR
- **Draft PR:** If user mentions "draft" or "WIP", add `--draft` flag
- **Multiple templates:** List options, ask which to use
