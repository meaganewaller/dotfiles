# Tool Installation

Use mise exclusively (`mise use TOOL@VERSION`). No brew, apt, npm -g, or pipx unless mise lacks the tool, and even then, ask first. No version bumps without explicit instruction.

## Commits

Always route commits through the `/git-workflow:commit` skill - both the main agent and subagents - for every commit, even tiny ones. Do not craft `git commit -m "..."` ad hoc. The skill enforces conventional commits, intentional file selection, mood-based emoji that reflects *this* change (not the type label), and American English.

If you are a subagent and `/git-workflow:commit` is not in your skill list, mirror its contract manually instead of inventing your own: `<type>(<scope>): <subject> :emoji:`, American English, why-focused body. Prefer asking the orchestrating agent to run `/git-workflow:commit` over committing yourself.

## Writing language

Use **American English** in commits, PR / issue descriptions, code comments, identifiers, and docs: `color`, `behavior`, `normalize`, `organize`, `canceled`, `center`, `analyze`, `license`, `catalog`, `gray`, `program`. When integrating with third-party APIs that ship British spellings (e.g. `Element.cloneNode`), keep the upstream spelling — match what the consuming code already uses. The `/git-workflow:commit` skill enforces this for commit messages; this rule covers everything else you write.

## Skills

| Task | Invocation |
|------|------------|
| Commit | `/git-workflow:commit` |
| Open a pull request | `/git-workflow:pr` |
| File a GitHub issue | `/git-workflow:issue` |
| Split an oversized diff into reviewable PRs | `/git-workflow:split-pr` |

These ship with the `git-workflow` plugin (`meaganewaller-marketplace`). If the invocation is not in your skill list, the plugin is not enabled for this account — say so rather than falling back to ad hoc `git` commands.
