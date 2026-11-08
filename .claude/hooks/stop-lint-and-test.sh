#!/usr/bin/env bash
# stop-lint-and-test.sh — Stop hook for Claude Code
#
# Runs lint and test checks when the agent stops and the working tree is dirty.
# Blocks the stop if either check fails, giving the agent a chance to fix issues.
#
# Only checks files that changed since the last snapshot, avoiding false
# positives from pre-existing issues in unrelated files and a full test run on
# every turn while the tree is dirty for reasons outside the session. Also
# registered as a SessionStart hook, which takes the first snapshot; each
# passing check takes the next. With no snapshot, every dirty file is checked.

set -euo pipefail

input=$(cat)

# Run from the project root so git diff and `bats test/` resolve correctly
# regardless of where the hook was invoked from.
cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}" || exit 0

# Hooks run without shell rc files sourced, so mise's shims dir (where `hk`
# and `bats` actually live) isn't on PATH even though `mise` itself is.
export PATH="${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims:$PATH"

# One snapshot per session, kept inside .git so it is never committed.
session_id=$(echo "$input" | jq -j '.session_id // "default"' | tr -c 'A-Za-z0-9_-' '_')
snapshot_dir=$(git rev-parse --git-path claude-stop-hook)
snapshot="$snapshot_dir/$session_id"

# Print "<blob hash> <path>" for every dirty tracked file (staged + unstaged).
dirty_state() {
	{
		git diff --name-only
		git diff --cached --name-only
	} | sort -u | while IFS= read -r f; do
		if [[ -e "$f" ]]; then
			printf '%s %s\n' "$(git hash-object -- "$f")" "$f"
		else
			printf 'deleted %s\n' "$f"
		fi
	done
}

take_snapshot() {
	mkdir -p "$snapshot_dir"
	find "$snapshot_dir" -type f -mtime +7 -delete 2>/dev/null || true
	dirty_state >"$snapshot"
}

if [[ "$(echo "$input" | jq -r '.hook_event_name // ""')" == "SessionStart" ]]; then
	take_snapshot
	exit 0
fi

# Prevent infinite loops: if the stop hook is already active, allow the stop
stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active // false')
if [[ "$stop_hook_active" == "true" ]]; then
	exit 0
fi

# Collect files whose content differs from the snapshot (all, without one)
files=()
while IFS= read -r line; do
	if [[ -f "$snapshot" ]] && grep -Fxq -- "$line" "$snapshot"; then
		continue
	fi
	files+=("${line#* }")
done < <(dirty_state)

# If nothing changed since the snapshot, nothing to check
if [[ ${#files[@]} -eq 0 ]]; then
	exit 0
fi

# Nothing under test/ reads these, so changes to them alone skip the suite.
needs_tests=false
lint_files=()
for f in "${files[@]}"; do
	[[ -e "$f" ]] && lint_files+=("$f")
	case "$f" in
	docs/* | .beads/* | mise.lock) ;;
	*/*) needs_tests=true ;;
	*.md) ;;
	*) needs_tests=true ;;
	esac
done

failures=""

# Run lint only on changed files
if [[ ${#lint_files[@]} -gt 0 ]]; then
	lint_output=$(hk fix "${lint_files[@]}" 2>&1) || failures="Lint failed:
${lint_output}
"
fi

# Run tests
if [[ "$needs_tests" == "true" ]]; then
	test_output=$(bats test/ 2>&1) || failures="${failures}Tests failed:
${test_output}"
fi

if [[ -n "$failures" ]]; then
	jq -n --arg reason "$failures" '{"decision": "block", "reason": $reason}'
else
	# Snapshot after `hk fix`, which may have rewritten the files it checked.
	take_snapshot
	exit 0
fi
