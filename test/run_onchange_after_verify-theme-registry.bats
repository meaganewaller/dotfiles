#!/usr/bin/env bats

load test_helper

SCRIPT_FILE="home/.chezmoiscripts/run_onchange_after_verify-theme-registry.sh.tmpl"

# This script cross-checks REAL source-tree files (theme.d appliers vs.
# themes.yaml's default palette), so meaningfully testing it means testing
# against a real (if trimmed) copy of that tree, not a hand-rolled fixture.
# home/dot_config is 28MB and almost entirely irrelevant here, so copy only
# the specific files the template's hash-comment `include`s require.
copy_theme_fixture() {
	mkdir -p "$TEST_SOURCE_DIR/.chezmoidata" \
		"$TEST_SOURCE_DIR/dot_local/bin" \
		"$TEST_SOURCE_DIR/dot_local/libexec/dotfiles/theme.d" \
		"$TEST_SOURCE_DIR/dot_config/sketchybar"

	cp home/.chezmoidata/themes.yaml "$TEST_SOURCE_DIR/.chezmoidata/themes.yaml"
	cp home/dot_local/bin/executable_theme "$TEST_SOURCE_DIR/dot_local/bin/executable_theme"
	cp home/dot_local/libexec/dotfiles/executable_theme-lookup \
		"$TEST_SOURCE_DIR/dot_local/libexec/dotfiles/executable_theme-lookup"
	cp home/dot_local/libexec/dotfiles/theme.d/executable_* \
		"$TEST_SOURCE_DIR/dot_local/libexec/dotfiles/theme.d/"
	cp home/dot_config/starship.toml "$TEST_SOURCE_DIR/dot_config/starship.toml"
	cp home/dot_config/sketchybar/executable_sketchybarrc \
		"$TEST_SOURCE_DIR/dot_config/sketchybar/executable_sketchybarrc"
}

# `include` (used in the hash-comment block) always resolves against the real
# -S/--source flag. `.chezmoi.sourceDir` (used at runtime to compute
# src_theme_d) is just template *data* set via --config, and can be pointed
# elsewhere -- used below to simulate a broken/missing applier directory
# independently of the fixture tree that satisfies `include`.
render() {
	local source_dir_value="${1:-$TEST_SOURCE_DIR}"
	cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$source_dir_value" }
EOF
	chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/config.toml" --file "$SCRIPT_FILE"
}

@test "renders a valid shell script" {
	copy_theme_fixture
	run render
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	assert_script_structure "$output"
	assert_valid_shell "$output"
}

@test "the real repo registry is currently self-consistent (regression canary)" {
	copy_theme_fixture
	local rendered="$TEST_TMPDIR/verify.sh"
	render >"$rendered"

	# XDG_STATE_HOME must not leak from the host: the real dev machine has one
	# set, which would make the script read a live theme state file instead of
	# falling back to the default -- unrelated to what this test checks.
	run env -u XDG_STATE_HOME HOME="$TEST_HOME_DIR" bash "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "fails when the source applier directory is missing" {
	copy_theme_fixture
	local rendered="$TEST_TMPDIR/verify.sh"
	render "$TEST_TMPDIR/nonexistent-source-root" >"$rendered"

	run env -u XDG_STATE_HOME HOME="$TEST_HOME_DIR" bash "$rendered"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"source applier dir missing"* ]] || fail "output was: $output"
}

@test "fails when the applier directory exists but is empty" {
	copy_theme_fixture
	local empty_root="$TEST_TMPDIR/empty-root"
	mkdir -p "$empty_root/dot_local/libexec/dotfiles/theme.d"
	local rendered="$TEST_TMPDIR/verify.sh"
	render "$empty_root" >"$rendered"

	run env -u XDG_STATE_HOME HOME="$TEST_HOME_DIR" bash "$rendered"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"no appliers found"* ]] || fail "output was: $output"
}

@test "fails when the default palette references a tool with no applier" {
	copy_theme_fixture
	yq -i '.themes.palettes.catppuccin-mocha.foobar = "whatever"' "$TEST_SOURCE_DIR/.chezmoidata/themes.yaml"
	local rendered="$TEST_TMPDIR/verify.sh"
	render >"$rendered"

	run env -u XDG_STATE_HOME HOME="$TEST_HOME_DIR" bash "$rendered"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"references tools with no applier"* ]] || fail "output was: $output"
	[[ "$output" == *"foobar"* ]] || fail "output was: $output"
}

@test "fails when an applier has no matching key in the default palette" {
	copy_theme_fixture
	touch "$TEST_SOURCE_DIR/dot_local/libexec/dotfiles/theme.d/executable_extra-tool"
	local rendered="$TEST_TMPDIR/verify.sh"
	render >"$rendered"

	run env -u XDG_STATE_HOME HOME="$TEST_HOME_DIR" bash "$rendered"
	[ "$status" -eq 1 ] || fail "status=$status output=$output"
	[[ "$output" == *"missing from default palette"* ]] || fail "output was: $output"
	[[ "$output" == *"extra-tool"* ]] || fail "output was: $output"
}

@test "seeds the default theme when no state file exists" {
	copy_theme_fixture
	local rendered="$TEST_TMPDIR/verify.sh"
	render >"$rendered"

	local stub="$TEST_TMPDIR/stub"
	mkdir -p "$stub/.local/bin"
	local theme_log="$TEST_TMPDIR/theme.log"
	cat >"$stub/.local/bin/theme" <<EOF
#!/usr/bin/env bash
echo "\$*" >>"$theme_log"
EOF
	chmod +x "$stub/.local/bin/theme"

	run env -u XDG_STATE_HOME HOME="$stub" bash "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"applying theme 'catppuccin-mocha'"* ]] || fail "output was: $output"
	[ "$(cat "$theme_log")" = "catppuccin-mocha" ] || fail "assertion did not hold"
}

@test "applies the theme recorded in the state file" {
	copy_theme_fixture
	local rendered="$TEST_TMPDIR/verify.sh"
	render >"$rendered"

	local stub="$TEST_TMPDIR/stub"
	mkdir -p "$stub/.local/bin" "$stub/.local/state/theme"
	local theme_log="$TEST_TMPDIR/theme.log"
	cat >"$stub/.local/bin/theme" <<EOF
#!/usr/bin/env bash
echo "\$*" >>"$theme_log"
EOF
	chmod +x "$stub/.local/bin/theme"
	echo "catppuccin-latte" >"$stub/.local/state/theme/current"

	run env -u XDG_STATE_HOME HOME="$stub" bash "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[[ "$output" == *"applying theme 'catppuccin-latte'"* ]] || fail "output was: $output"
	[ "$(cat "$theme_log")" = "catppuccin-latte" ] || fail "assertion did not hold"
}
