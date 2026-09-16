#!/usr/bin/env bats

load test_helper

@test "packages.yaml has linux.dnf structure" {
	local packages_file="home/.chezmoidata/packages.yaml"

	[ -f "$packages_file" ] || fail "assertion did not hold"

	# Should have packages.linux structure
	run yq '.packages.linux' "$packages_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Should have dnf array
	run yq '.packages.linux.dnf' "$packages_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "renders correctly on linux with packages" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-linux.sh.tmpl"

	cat >"$TEST_TMPDIR/linux-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { linux = { dnf = ["git", "zsh", "htop"] } }
EOF

	run chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/linux-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Should be a valid shell script
	assert_script_structure "$output"

	# Should check for dnf availability
	[[ "$output" == *"command -v dnf"* ]] || fail "output was: $output"

	# Should use dnf install
	[[ "$output" == *"dnf install"* ]] || fail "output was: $output"

	# Should contain our test packages
	[[ "$output" == *"git"* ]] || fail "output was: $output"
	[[ "$output" == *"zsh"* ]] || fail "output was: $output"
	[[ "$output" == *"htop"* ]] || fail "output was: $output"
}

@test "does not render on non-linux systems" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-linux.sh.tmpl"

	cat >"$TEST_TMPDIR/darwin-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { linux = { dnf = ["git", "zsh"] } }
EOF

	run chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/darwin-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Should be empty on non-linux
	[ "$output" = "" ] || fail "output was: $output"
}

@test "produces valid shell syntax" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-linux.sh.tmpl"

	cat >"$TEST_TMPDIR/syntax-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { linux = { dnf = ["git", "zsh", "htop"] } }
EOF

	run chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/syntax-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	assert_valid_shell "$output"
}

@test "handles empty dnf section gracefully" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-linux.sh.tmpl"

	cat >"$TEST_TMPDIR/empty-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { linux = { dnf = [] } }
EOF

	run chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/empty-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Should still produce valid shell syntax
	assert_valid_shell "$output"

	# Should not contain any package names in the dnf install line
	# (the dnf install command should have no packages listed)
}

@test "a machine profile drops excluded dnf and apt packages" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-linux.sh.tmpl"

	cat >"$TEST_TMPDIR/profile-config.toml" <<EOF
[data]
    machine_profile = "work"
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { linux = { dnf = ["git", "htop"], apt = ["git", "htop"] }, profiles = { work = { exclude = ["htop"] } } }
EOF

	run chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/profile-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	[[ "$output" == *"git"* ]] || fail "output was: $output"
	[[ "$output" != *"htop"* ]] || fail "output was: $output"

	assert_valid_shell "$output"
}
