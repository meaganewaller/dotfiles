#!/usr/bin/env bash
# PreToolUse hook: blocks writes containing secrets or sensitive patterns
# Reads tool input JSON from stdin

set -euo pipefail

INPUT=$(cat)

# Only check file write/edit tools
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "MultiEdit" ]]; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // ""')

# Patterns that suggest hardcoded secrets
PATTERNS=(
  'AKIA[0-9A-Z]{16}'                          # AWS access key
  'sk-[a-zA-Z0-9]{32,}'                       # OpenAI / Anthropic secret key
  'ghp_[a-zA-Z0-9]{36}'                       # GitHub personal access token
  'password\s*=\s*["'"'"'][^"'"'"']{6,}'      # Hardcoded password assignment
  'secret\s*=\s*["'"'"'][^"'"'"']{8,}'        # Hardcoded secret assignment
  'BEGIN (RSA|EC|OPENSSH) PRIVATE KEY'        # Private key material
  'DATABASE_URL\s*=\s*postgres://[^$]'        # Literal DB URL (not an env var ref)
)

FOUND=""
for PATTERN in "${PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qE "$PATTERN" 2>/dev/null; then
    FOUND="$FOUND\n  - Matched pattern: $PATTERN"
  fi
done

if [[ -n "$FOUND" ]]; then
  echo "🚨 Secret detection hook blocked write to: $FILE_PATH"
  echo ""
  echo "Possible sensitive data detected:"
  echo -e "$FOUND"
  echo ""
  echo "If this is a false positive, remove the matching line or use an environment variable reference instead."
  exit 2  # Exit code 2 blocks the tool use
fi

exit 0
