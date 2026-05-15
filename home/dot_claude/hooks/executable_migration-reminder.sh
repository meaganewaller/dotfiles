#!/usr/bin/env bash
# PostToolUse hook: after editing a migration file, reminds about related changes needed
# Reads tool input JSON from stdin

set -euo pipefail

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')

# Only fire for migration files
if ! echo "$FILE_PATH" | grep -q "db/migrate/"; then
  exit 0
fi

echo "📋 Migration file edited: $FILE_PATH"
echo ""
echo "Checklist before running this migration:"
echo "  [ ] Run /migration-check to review for safety issues"
echo "  [ ] Does a model need \`ignored_columns\` added before deploy? (if removing a column)"
echo "  [ ] Does schema.rb need to be committed alongside this migration?"
echo "  [ ] Are there corresponding model validations to add/remove?"
echo "  [ ] Does this need a data migration? (separate file, not in schema migration)"
echo ""
echo "Run the migration with: bundle exec rails db:migrate"
