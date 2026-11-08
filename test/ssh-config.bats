#!/usr/bin/env bats

load test_helper

CONFIG_FILE="home/private_dot_ssh/private_config.tmpl"

# The template reads .work_profile, and chezmoi renders with missingkey=error,
# so every config here must define it or rendering fails outright.
render() {
	local os="$1" work_profile="${2:-false}"
	cat >"$TEST_TMPDIR/$os-$work_profile.toml" <<EOF
[data]
    work_profile = $work_profile
    chezmoi = { os = "$os", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF
	chezmoi execute-template --config "$TEST_TMPDIR/$os-$work_profile.toml" --file "$CONFIG_FILE"
}

@test "renders macOS 1Password agent on darwin" {
	run render darwin
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"* ]] || fail "output was: $output"
}

@test "renders Linux 1Password agent on linux" {
	run render linux
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *".1password/agent.sock"* ]] || fail "output was: $output"
}

@test "does not leak macOS paths to linux" {
	run render linux
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *"Library/Group Containers"* ]] || fail "output was: $output"
}

@test "does not leak Linux paths to darwin" {
	run render darwin
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *".1password/agent.sock"* ]] || fail "output was: $output"
}

@test "includes work.config only on a work profile" {
	run render darwin true
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"Include ~/.ssh/work.config"* ]] || fail "output was: $output"

	run render darwin false
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *"work.config"* ]] || fail "output was: $output"
}

# OrbStack's 'orb' host only works when its Include comes before any Host block.
@test "includes OrbStack's ssh config on darwin, before any Host block" {
	run render darwin
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	include_line=$(grep -n '^Include ~/.orbstack/ssh/config$' <<<"$output" | cut -d: -f1)
	host_line=$(grep -n '^Host ' <<<"$output" | head -1 | cut -d: -f1)
	[[ -n "$include_line" ]] || fail "no OrbStack Include, output was: $output"
	((include_line < host_line)) || fail "Include at $include_line after first Host at $host_line"
}

@test "does not include OrbStack's ssh config on linux" {
	run render linux
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" != *"orbstack"* ]] || fail "output was: $output"
}
