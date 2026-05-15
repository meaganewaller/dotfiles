#!/usr/bin/env bash
# PreToolUse hook: warns before running destructive Rails/DB commands
# Reads tool input JSON from stdin

set -euo pipefail

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
if [[ "$TOOL_NAME" != "Bash" ]]; then
  exit 0
fi

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Patterns for destructive operations
DESTRUCTIVE_PATTERNS=(
  "db:drop"
  "db:reset"
  "db:schema:load"
  "db:migrate:reset"
  "rails destroy"
  "rake db:drop"
  "rake db:reset"
  "DROP TABLE"
  "DROP DATABASE"
  "TRUNCATE"
  "redis-cli FLUSHALL"
  "redis-cli FLUSHDB"
  "rm -rf"
)

for PATTERN in "${DESTRUCTIVE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$PATTERN" 2>/dev/null; then
    # Check if this looks like it could be production
    if echo "$COMMAND" | grep -qiE "RAILS_ENV=production|--environment=production|_production"; then
      echo "🚨 BLOCKED: Destructive command targeting production environment detected."
      echo "Command: $COMMAND"
      echo "Matched pattern: $PATTERN"
      exit 2  # Hard block for production
    fi

    # For non-production, warn but allow user to proceed
    echo "⚠️  Destructive command detected: $PATTERN"
    echo "Command: $COMMAND"
    echo ""
    echo "This will modify or destroy data. Proceed only if you're sure."
    echo "(To suppress this warning, add a comment: # confirmed-destructive)"
    # Exit 0 allows it through with the warning printed
    exit 0
  fi
done

exit 0
