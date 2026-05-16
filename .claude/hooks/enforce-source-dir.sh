#!/usr/bin/env bash
# enforce-source-dir.sh — PreToolUse hook for Claude Code
#
# Prevents agents from writing to chezmoi-managed destination files in ~/
# instead of editing source files in the project's home/ directory.
#
# Behavior:
#   Write/Edit/MultiEdit targeting ~/ (outside project) → hard deny
#   Read targeting ~/ (outside project)                  → soft warning
#   Bash referencing ~/ (non-chezmoi command)            → soft warning
#   Everything else                                      → allow (no output)

set -euo pipefail

# Resolve HOME and PROJECT_DIR to canonical paths (masOS /var -> /private/var)
ORIG_HOME="$HOME"
HOME="$(realpath "$HOME")"
CLAUDE_PROJECT_DIR=$(realpath "${CLAUDE_PROJECT_DIR:-.}")

# Read hook input from stdin
input=$(cat)

# Extract fields in one jq call
eval "$(echo "$input" | jq -r '
  @sh "tool_name=\(.tool_name // "")",
  @sh "file_path=\(.tool_input.file_path // "")",
  @sh "command=\(.tool_input.command // "")"
')"

# Resolve a file path to its canonical form.
# For existing paths, use realpath. For new files, resolve the parent.
resolve_path() {
  local p="$1"
  if [[ -e "$p" ]]; then
    realpath "$p"
  elif [[ -d "$(dirname "$p")" ]]; then
    echo "$(realpath "$(dirname "$p")")/$(basename "$p")"
  else
    echo "$p"
  fi
}

# Check if a resolved path is a chezmoi-managed destination we should protect.
# Fast-path filters first (paths outside $HOME, inside the project source, or
# under ~/.claude can never be managed destinations), then ask chezmoi
# directly so we don't over-trigger on unrelated repos that happen to live
# under $HOME (e.g. ~/src/...).
is_chezmoi_managed() {
  local resolved="$1"
  [[ "$resolved" == "$HOME"/* ]] || return 1
  [[ "$resolved" == "$CLAUDE_PROJECT_DIR"/* ]] && return 1
  [[ "$resolved" == "$HOME/.claude"/* ]] && return 1
  chezmoi source-path "$resolved" >/dev/null 2>&1
}

case "$tool_name" in
  Write | Edit | MultiEdit)
    [[ -z "$file_path" ]] && exit 0
    resolved=$(resolve_path "$file_path")
    if is_chezmoi_managed "$resolved"; then
      jq -n --arg reason "$(cat <<MSG
BLOCKED: Do not edit files in ~/ directly. This is a chezmoi-managed dotfiles repo.

To find the correct source file, run:
  chezmoi source-path $resolved

Then edit that source file (under home/ in the project tree), and deploy with:
  chezmoi apply $resolved
MSG
)" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $reason}}'
    fi
    ;;

  Read)
    [[ -z "$file_path" ]] && exit 0
    resolved=$(resolve_path "$file_path")
    if is_chezmoi_managed "$resolved"; then
      jq -n --arg ctx "$(cat <<MSG
Note: You are reading a chezmoi-managed destination file. This is deployed from
the source tree — do not edit it directly. To find the source file, run:
  chezmoi source-path $resolved
MSG
)" '{additionalContext: $ctx}'
    fi
    ;;

  Bash)
    [[ -z "$command" ]] && exit 0

    # Exempt chezmoi commands (strip leading whitespace and env-var assignments)
    stripped=$(echo "$command" | sed 's/^[[:space:]]*//' | sed 's/^[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]*//')
    # Handle multiple env vars (e.g., DEBUG=1 VERBOSE=1 chezmoi ...)
    while [[ "$stripped" =~ ^[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]] ]]; do
      stripped=$(echo "$stripped" | sed 's/^[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]*//')
    done
    if [[ "$stripped" == chezmoi* ]]; then
      exit 0
    fi

	# Check if command references home directory (check both resolved and original)
    if echo "$command" | grep -qF "$HOME/" ||
	echo "$command" | grep -qF "$ORIG_HOME/" ||
	echo "$command" | grep -qE '^(~/|\$HOME/)'; then
      jq -n --arg ctx "$(cat <<MSG
Note: This command references files in ~/. This is a chezmoi-managed repo — do
not modify files in ~/ directly. To find source files, use:
  chezmoi source-path <target>
MSG
)" '{additionalContext: $ctx}'
    fi
    ;;
esac