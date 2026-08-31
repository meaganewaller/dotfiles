#!/usr/bin/env bats

load test_helper

GUARD="home/dot_local/libexec/executable_check-secrets-before-write"

run_write_guard() {
	local payload="$1"
	bash "$GUARD" <<<"$payload"
}

assert_blocked_payload() {
	run run_write_guard "$1"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "expected block but guard allowed"
	echo "$output" | jq -e '.hookSpecificOutput.permissionDecision == "deny"' >/dev/null
}

assert_allowed_payload() {
	run run_write_guard "$1"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -z "$output" ] || fail "expected allow but guard blocked: $output"
}

@test "blocks Write content containing known secret patterns" {
	local payload
	payload="$(jq -cn '{tool_name: "Write", tool_input: {file_path: "src/a.ts", content: "const k = \"sk-abcdefghijklmnopqrstuvwxyz123456\";"}}')"
	assert_blocked_payload "$payload"
}

@test "blocks Edit new_string containing credentials" {
	local payload
	payload="$(jq -cn '{tool_name: "Edit", tool_input: {file_path: "src/b.ts", new_string: "password = \"hunter22\""}}')"
	assert_blocked_payload "$payload"
}

@test "blocks MultiEdit when any replacement contains secret-like token" {
	local payload
	payload="$(jq -cn '{tool_name: "MultiEdit", tool_input: {file_path: "src/c.ts", edits: [{new_string: "const ok = 1"}, {new_string: "const token = \"ghp_abcdefghijklmnopqrstuvwxyz1234567890\""}]}}')"
	assert_blocked_payload "$payload"
}

@test "allows benign content" {
	local payload
	payload="$(jq -cn '{tool_name: "Write", tool_input: {file_path: "src/d.ts", content: "export const answer = 42;"}}')"
	assert_allowed_payload "$payload"
}

@test "ignores non-write tools" {
	local payload
	payload="$(jq -cn '{tool_name: "Read", tool_input: {file_path: "src/e.ts", content: "sk-abcdefghijklmnopqrstuvwxyz123456"}}')"
	assert_allowed_payload "$payload"
}
