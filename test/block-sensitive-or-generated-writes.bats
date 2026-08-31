#!/usr/bin/env bats

load test_helper

GUARD="home/dot_local/libexec/executable_block-sensitive-or-generated-writes"

run_guard() {
	local tool_name="$1"
	local file_path="$2"
	local payload
	payload="$(jq -cn --arg t "$tool_name" --arg p "$file_path" '{tool_name: $t, tool_input: {file_path: $p}}')"
	bash "$GUARD" <<<"$payload"
}

assert_blocked() {
	run run_guard "$1" "$2"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "expected block but guard allowed: $1 $2"
	echo "$output" | jq -e '.hookSpecificOutput.permissionDecision == "deny"' >/dev/null
}

assert_allowed() {
	run run_guard "$1" "$2"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -z "$output" ] || fail "expected allow but guard blocked: $1 $2 -> $output"
}

@test "blocks sensitive file paths" {
	assert_blocked "Edit" "$HOME/.ssh/config"
	assert_blocked "Write" "$HOME/.aws/credentials"
	assert_blocked "MultiEdit" "$HOME/.env"
	assert_blocked "Write" "$HOME/.config/private_Library/token.json"
	assert_blocked "Write" "$HOME/project/credentials.yaml"
}

@test "blocks generated/build artifact paths" {
	assert_blocked "Write" "$HOME/project/dist/app.js"
	assert_blocked "Edit" "$HOME/project/node_modules/pkg/index.js"
	assert_blocked "Write" "$HOME/project/generated/client.generated.ts"
	assert_blocked "MultiEdit" "$HOME/project/proto/user.pb.go"
}

@test "allows normal source files" {
	assert_allowed "Write" "$HOME/project/src/main.ts"
	assert_allowed "Edit" "$HOME/project/README.md"
}

@test "ignores unrelated tools" {
	assert_allowed "Read" "$HOME/.ssh/config"
	assert_allowed "Bash" "$HOME/project/dist/app.js"
}

@test "supports human bypass env var" {
	export CLAUDE_ALLOW_SENSITIVE_WRITES=1
	run run_guard "Write" "$HOME/.ssh/config"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -z "$output" ] || fail "output was: $output"
}
