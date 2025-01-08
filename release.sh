#!/bin/sh

prerelease_type="$1"

branch="$(git branch --show-current)"
if [ "$branch" != "main" ] && [ "$branch" != "main" ]; then
  echo "Error: Releases must be created from trunk, run $0 in main."
  exit 1
fi

if [ -n "$(git status -s)" ]; then
  echo "Error: Working tree has changes: Stash, commit or reset first"
  exit 1
fi

if [ -n "$prerelease_type" ]; then
  echo "Creating pre-release ($prerelease_type)"
  bunx standard-version --prerelease "$prerelease_type"
  uvx --from commitizen cz bump --prerelease "$prerelease_type"
else
  bunx standard-version
  uvx --from commitizen cz bump
fi
