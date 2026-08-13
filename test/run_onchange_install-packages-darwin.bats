#!/usr/bin/env bats

load test_helper

@test "packages.yaml file is valid YAML" {
	# Test that our actual packages.yaml file is valid YAML
	local packages_file="home/.chezmoidata/packages.yaml"

	# Check if the file exists
	[ -f "$packages_file" ] || fail "assertion did not hold"

	# Test YAML syntax validity
	assert_valid_yaml "$packages_file"
}

@test "packages.yaml has the structure our script expects" {
	# Test that our packages.yaml has the structure our script needs
	local packages_file="home/.chezmoidata/packages.yaml"

	# Check if the file exists
	[ -f "$packages_file" ] || fail "assertion did not hold"

	# Test that it has the structure our script expects
	# Should have packages.darwin structure (our script references .packages.darwin.brews)
	run yq '.packages.darwin' "$packages_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Should have brews array (our script references .packages.darwin.brews)
	run yq '.packages.darwin.brews' "$packages_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Should have casks array (our script references .packages.darwin.casks)
	run yq '.packages.darwin.casks' "$packages_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "renders correctly on darwin with packages" {
	# Test our ACTUAL script with our ACTUAL packages data
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-darwin.sh.tmpl"

	# Create config with our actual data
	cat >"$TEST_TMPDIR/real-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { darwin = { brews = [], casks = ["font-maple-mono-nf-cn"] } }
EOF

	# Render our actual script. The template branches on $CI / $GITHUB_ACTIONS
	# at render time; clear them so this test exercises the dev-machine path
	# (brews + casks). The CI-only path is covered by a separate test below.
	run env -u CI -u GITHUB_ACTIONS chezmoi execute-template --config "$TEST_TMPDIR/real-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Test our script's behavior:
	# 1. Should be a valid shell script
	assert_script_structure "$output"

	# 2. Should check for Homebrew availability
	[[ "$output" == *"command -v brew"* ]] || fail "output was: $output"

	# 3. Should use brew bundle to install packages
	[[ "$output" == *"brew bundle"* ]] || fail "output was: $output"

	# 4. Should contain our actual package
	[[ "$output" == *"font-maple-mono-nf-cn"* ]] || fail "output was: $output"

	# 5. Should handle missing Homebrew gracefully
	[[ "$output" == *"Homebrew not found"* ]] || fail "output was: $output"
	[[ "$output" == *"exit 0"* ]] || fail "output was: $output"
}

@test "skips casks when CI env is set" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-darwin.sh.tmpl"

	cat >"$TEST_TMPDIR/ci-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { darwin = { brews = ["jq"], casks = ["font-maple-mono-nf-cn"] } }
EOF

	CI=true run env -u GITHUB_ACTIONS chezmoi execute-template --config "$TEST_TMPDIR/ci-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Brews still installed (catches bundle drift in CI)
	[[ "$output" == *'brew "jq"'* ]] || fail "output was: $output"

	# Casks omitted from the rendered bundle
	[[ "$output" != *"font-maple-mono-nf-cn"* ]] || fail "output was: $output"
	[[ "$output" != *'cask "'* ]] || fail "output was: $output"
}

@test "emits a tap line for every tap-qualified brew" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-darwin.sh.tmpl"

	cat >"$TEST_TMPDIR/taps-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { darwin = { brews = ["jq", "FelixKratz/formulae/sketchybar", "steipete/tap/remindctl", "steipete/tap/second"], casks = [] } }
EOF

	CI=true run env -u GITHUB_ACTIONS chezmoi execute-template --config "$TEST_TMPDIR/taps-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Without these, a cold `brew bundle` fails with "This command requires the
	# tap ..." — the machine that already has the tap never sees it.
	[[ "$output" == *'tap "FelixKratz/formulae"'* ]] || fail "output was: $output"
	[[ "$output" == *'tap "steipete/tap"'* ]] || fail "output was: $output"

	# A plain formula must not produce a tap line.
	[[ "$output" != *'tap "jq"'* ]] || fail "output was: $output"

	# One tap line per tap, however many formulae come from it.
	[ "$(printf '%s\n' "$output" | grep -c '^tap "steipete/tap"$')" -eq 1 ] || fail "output was: $output"

	# Taps must be declared before the formulae that need them.
	local tap_line brew_line
	tap_line=$(printf '%s\n' "$output" | grep -n '^tap "FelixKratz/formulae"$' | cut -d: -f1)
	brew_line=$(printf '%s\n' "$output" | grep -n '^brew "FelixKratz/formulae/sketchybar"$' | cut -d: -f1)
	[ -n "$tap_line" ] || fail "no tap line rendered; output was: $output"
	[ "$tap_line" -lt "$brew_line" ] || fail "tap at line $tap_line must precede brew at line $brew_line; output was: $output"
}

@test "trusts every tap-qualified formula before bundling" {
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-darwin.sh.tmpl"

	cat >"$TEST_TMPDIR/trust-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { darwin = { brews = ["jq", "FelixKratz/formulae/sketchybar", "steipete/tap/remindctl"], casks = [] } }
EOF

	CI=true run env -u GITHUB_ACTIONS chezmoi execute-template --config "$TEST_TMPDIR/trust-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Homebrew 6 refuses to load formulae from untrusted third-party taps:
	# "Refusing to load formula ... from untrusted tap ...".
	[[ "$output" == *'brew trust --formula "FelixKratz/formulae/sketchybar"'* ]] || fail "output was: $output"
	[[ "$output" == *'brew trust --formula "steipete/tap/remindctl"'* ]] || fail "output was: $output"

	# Core formulae are trusted implicitly; never widen scope for them.
	[[ "$output" != *'brew trust --formula "jq"'* ]] || fail "output was: $output"

	# Trust is per formula, not a blanket tap-wide grant.
	[[ "$output" != *'brew trust --tap'* ]] || fail "output was: $output"

	# Trust must be established before the bundle tries to load anything.
	local trust_line bundle_line
	trust_line=$(printf '%s\n' "$output" | grep -n 'brew trust --formula' | head -1 | cut -d: -f1)
	bundle_line=$(printf '%s\n' "$output" | grep -n '^brew bundle' | cut -d: -f1)
	[ -n "$trust_line" ] || fail "no trust line rendered; output was: $output"
	[ "$trust_line" -lt "$bundle_line" ] || fail "trust at line $trust_line must precede bundle at line $bundle_line; output was: $output"
}

@test "does not render on non-darwin systems" {
	# Test our ACTUAL script on non-darwin systems
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-darwin.sh.tmpl"

	# Create config with linux OS
	cat >"$TEST_TMPDIR/linux-config.toml" <<EOF
[data]
    chezmoi = { os = "linux", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
    packages = { darwin = { brews = [], casks = ["font-maple-mono-nf-cn"] } }
EOF

	# Render our actual script on linux
	run chezmoi execute-template --config "$TEST_TMPDIR/linux-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Should be empty on non-darwin
	[ "$output" = "" ] || fail "output was: $output"
}

@test "produces valid shell syntax" {
	# Test that our ACTUAL script renders to valid shell syntax
	local script_file="home/.chezmoiscripts/run_onchange_install-packages-darwin.sh.tmpl"

	# Create config with our actual data
	cat >"$TEST_TMPDIR/syntax-config.toml" <<EOF
[data]
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF

	# Add our actual packages data
	cat >>"$TEST_TMPDIR/syntax-config.toml" <<EOF
    packages = { darwin = { brews = [], casks = ["font-maple-mono-nf-cn"] } }
EOF

	# Render our actual script
	run chezmoi execute-template --config "$TEST_TMPDIR/syntax-config.toml" --file "$script_file"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Test that the rendered script has valid shell syntax
	assert_valid_shell "$output"
}
