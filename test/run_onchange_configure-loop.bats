#!/usr/bin/env bats

load test_helper

@test "loop.yaml is valid YAML with the structure the script expects" {
	local data_file="home/.chezmoidata/loop.yaml"

	[ -f "$data_file" ] || fail "assertion did not hold"
	assert_valid_yaml "$data_file"

	# The script reads .loop.trigger, .loop.side_dependent_trigger_key and
	# .loop.double_click_to_trigger; a rename would render an empty trigger.
	run yq '.loop.trigger' "$data_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run yq '.loop.side_dependent_trigger_key' "$data_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run yq '.loop.double_click_to_trigger' "$data_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "the declared trigger is not a key another tool already owns" {
	local data_file="home/.chezmoidata/loop.yaml"

	# 56 was the old trigger (left Shift) and is Minecraft's sneak; 57 and 54
	# are consumed by Karabiner (caps_lock -> left_control, right_command ->
	# f18). Re-declaring any of them silently reintroduces a collision.
	run yq -r '.loop.trigger | .[]' "$data_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local code
	while IFS= read -r code; do
		[ -n "$code" ] || continue
		case "$code" in
		56) fail "trigger $code is left Shift — Minecraft sneak, the collision this replaced" ;;
		57) fail "trigger $code is Caps Lock — Karabiner remaps it to left_control" ;;
		54) fail "trigger $code is right Command — Karabiner remaps it to f18" ;;
		esac
	done < <(printf '%s\n' "$output")
}

@test "renders on darwin with the declared trigger" {
	local script_file="home/.chezmoiscripts/run_onchange_configure-loop.sh.tmpl"

	cat >"$TEST_TMPDIR/loop-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    loop = { trigger = [61], side_dependent_trigger_key = true, double_click_to_trigger = true }
EOF

	run env -u CI -u GITHUB_ACTIONS chezmoi --source home execute-template --config "$TEST_TMPDIR/loop-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	assert_script_structure "$output"

	# Keycodes must reach `defaults` as integers; -array alone would write strings.
	[[ "$output" == *'defaults write com.MrKai77.Loop trigger -array -int 61'* ]] || fail "output was: $output"

	# Guard against clobbering a machine where Loop was never installed.
	[[ "$output" == *"/Applications/Loop.app"* ]] || fail "output was: $output"

	# A write without a restart leaves the old trigger live until next login.
	[[ "$output" == *"killall Loop"* ]] || fail "output was: $output"
}

@test "renders a multi-key trigger as repeated -int arguments" {
	local script_file="home/.chezmoiscripts/run_onchange_configure-loop.sh.tmpl"

	cat >"$TEST_TMPDIR/multi-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    loop = { trigger = [61, 62], side_dependent_trigger_key = true, double_click_to_trigger = false }
EOF

	run env -u CI -u GITHUB_ACTIONS chezmoi --source home execute-template --config "$TEST_TMPDIR/multi-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	[[ "$output" == *'trigger -array -int 61 -int 62'* ]] || fail "output was: $output"

	# The comparison string must concatenate in the same order the array is
	# written, or the idempotency check rewrites on every apply.
	[[ "$output" == *'desired_trigger="6162"'* ]] || fail "output was: $output"

	# A false value must render 0, not the empty string.
	[[ "$output" == *"desired_double=0"* ]] || fail "output was: $output"
}

@test "does not render on non-darwin systems" {
	local script_file="home/.chezmoiscripts/run_onchange_configure-loop.sh.tmpl"

	cat >"$TEST_TMPDIR/linux-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    loop = { trigger = [61], side_dependent_trigger_key = true, double_click_to_trigger = true }
EOF

	run chezmoi --source home execute-template --config "$TEST_TMPDIR/linux-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" = "" ] || fail "output was: $output"
}

@test "produces valid shell syntax" {
	local script_file="home/.chezmoiscripts/run_onchange_configure-loop.sh.tmpl"

	cat >"$TEST_TMPDIR/syntax-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    loop = { trigger = [61], side_dependent_trigger_key = true, double_click_to_trigger = true }
EOF

	run env -u CI -u GITHUB_ACTIONS chezmoi --source home execute-template --config "$TEST_TMPDIR/syntax-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	assert_valid_shell "$output"
}
