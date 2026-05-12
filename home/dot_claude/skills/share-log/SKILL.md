---
name: share-log
description: Use when sharing the current conversation as a Gist. Creates a secret Gist with the current Claude Code session log extracted to markdown.
argument-hint: "[description for filename]"
model: haiku
allowed-tools:
  - Bash(~/.claude/skills/share-log/claude-extract-session:*)
  - Bash(gh gist create:*)
---

# Share Conversation Log

Creates a **secret** GitHub Gist containing the current Claude Code session as markdown. Uses the `share-log` shim (which delegates to `~/.claude/skills/pr/claude-extract-session`); both skills must be present after `chezmoi apply`.

## Arguments

```
$ARGUMENTS
```

Optional description used in the Gist filename. If omitted, use **`conversation`**.

## Instructions

### 1. Preconditions

- **`${CLAUDE_SESSION_ID}`** must be set (Claude Code substitution). If it is empty or missing, stop and tell the user the skill only runs inside a Claude Code session.
- **`gh`** must be authenticated (`gh auth status`). If not, tell the user to run `gh auth login`.
- **`claude-extract`** must be on `PATH` (the shim shells out to it). If the shim errors with “claude-extract not found”, tell the user to install the `claude-extract` CLI.

### 2. Filename slug

1. Take the first argument string; if none, use `conversation`.
2. **Sanitize** for a safe filename segment: lowercase, trim, replace runs of spaces with a single hyphen, remove characters that are not `[a-z0-9-]`, collapse repeated hyphens, strip leading/trailing hyphens. If the result is empty, use `conversation`.
3. Final gist filename: `claude-conversation-<slug>.md`

### 3. Extract session and create Gist

Pipe **only the current session** markdown to a new gist (secret by default; do not pass `--public`):

```bash
~/.claude/skills/share-log/claude-extract-session "${CLAUDE_SESSION_ID}" \
  | gh gist create --filename "claude-conversation-<slug>.md" -
```

The shim:

- Accepts the session ID (from `${CLAUDE_SESSION_ID}`).
- Runs the same extraction path as the PR skill (`--detailed` transcript to stdout).
- **No gist body written to disk** except what `gh` sends to GitHub.

### 4. Report result

Print the **Gist URL** returned by `gh`. State clearly: the gist is **secret** (not discoverable in your profile’s public list, but anyone with the URL can read it—treat the link as sensitive).

## Examples

| Invocation | Slug | Filename |
| --- | --- | --- |
| `/share-log` | `conversation` | `claude-conversation-conversation.md` |
| `/share-log debugging auth issue` | `debugging-auth-issue` | `claude-conversation-debugging-auth-issue.md` |
| `/share-log refactoring session` | `refactoring-session` | `claude-conversation-refactoring-session.md` |

## Edge cases

| Situation | Action |
| --- | --- |
| Empty or unset `CLAUDE_SESSION_ID` | Do not run the pipe; explain that this skill requires Claude Code’s session context. |
| `gh` not authenticated | Prompt for `gh auth login` (or `gh auth status` to diagnose). |
| `claude-extract` missing | Point to installing the CLI; the extract shim errors if it is not in `PATH`. |
| `gh gist create` fails (rate limit, network) | Surface stderr; suggest retry or `gh auth status`. |
| Wrapper missing (`../pr/claude-extract-session`) | User likely applied only part of dotfiles; ensure `chezmoi apply` includes `~/.claude/skills/pr/claude-extract-session`. |
