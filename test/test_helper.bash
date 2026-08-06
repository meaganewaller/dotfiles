#!/usr/bin/env bats

# Test helper for chezmoi brew bundle tests
# This file is automatically loaded by bats

# Setup function that runs before each test
setup() {
	# Create temporary directories for testing
	TEST_TMPDIR=$(mktemp -d)
	export TEST_TMPDIR
	export TEST_SOURCE_DIR="$TEST_TMPDIR/source"
	export TEST_HOME_DIR="$TEST_TMPDIR/home"

	mkdir -p "$TEST_SOURCE_DIR"
	mkdir -p "$TEST_HOME_DIR"

	# Set up test environment variables
	export CHEZMOI_SOURCE_DIR="$TEST_SOURCE_DIR"
	export CHEZMOI_HOME_DIR="$TEST_HOME_DIR"
}

# Teardown function that runs after each test
teardown() {
	# Clean up temporary directories
	rm -rf "$TEST_TMPDIR"
}

# Fail the current test immediately with a message.
#
# Bats only checks the exit status of a test's LAST command -- a bare `[[ ... ]]`
# anywhere earlier is silently ignored, so multi-assertion tests under-assert
# without any sign of it. `set -e` in setup() does not propagate into the test
# body either. Guarding each assertion with `|| fail "..."` is what actually
# enforces it, because `exit` does terminate the test.
#
#   [[ "$output" == *"expected"* ]] || fail "missing expected"
fail() {
	printf 'ASSERTION FAILED: %s\n' "$*" >&2
	exit 1
}

# Helper function to assert valid YAML
assert_valid_yaml() {
	local file="$1"

	yq '.' "$file" >/dev/null || fail "not valid YAML: $file"
}

# Helper function to assert valid shell syntax
assert_valid_shell() {
	local script="$1"

	# Write script to temporary file for shellcheck
	local temp_script="$TEST_TMPDIR/temp_script.sh"
	echo "$script" >"$temp_script"

	# Test basic syntax with bash -n
	bash -n "$temp_script" || fail "rendered script is not valid bash"

	# Test with shellcheck if available
	if command -v shellcheck >/dev/null 2>&1; then
		shellcheck "$temp_script" || fail "shellcheck rejected the rendered script"
	fi
}

# Helper function to assert script has proper structure
assert_script_structure() {
	local script="$1"

	# Should start with shebang (accepts both direct and env-indirected forms).
	# Guarded: an unguarded [[ ]] here would be ignored, and the function would
	# return `bash -n`'s status instead -- the shebang check would never fire.
	[[ "$script" == *"#!/bin/bash"* || "$script" == *"#!/bin/sh"* ||
		"$script" == *"#!/usr/bin/env bash"* || "$script" == *"#!/usr/bin/env sh"* ]] ||
		fail "no recognized shebang in rendered script"

	# Should be syntactically valid
	echo "$script" >"$TEST_TMPDIR/temp.sh"
	bash -n "$TEST_TMPDIR/temp.sh" || fail "rendered script is not valid bash"
}
