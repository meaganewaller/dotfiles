#!/usr/bin/env bats

load test_helper

# Machine package profiles.
#
# .chezmoidata/packages.yaml declares named profiles
# (packages.profiles.<name>.exclude) and the destination paths each package
# owns (packages.configs). A machine picks one with machine_profile in
# ~/.config/chezmoi/chezmoi.toml; blank means every package.
# .chezmoitemplates/package-excludes resolves the active profile to the names
# it excludes, and every consumer (both install scripts, .chezmoiignore,
# configure-loop) filters through that one template.

PACKAGES_FILE="home/.chezmoidata/packages.yaml"

# render_excludes <machine_profile line, or empty for a config without the key>
render_excludes() {
	cat >"$TEST_TMPDIR/config.toml" <<EOF
[data]
    $1
    packages = { profiles = { work = { exclude = ["loop", "nikitabobko/tap/aerospace"] }, bare = {} } }
EOF
	chezmoi --source "$TEST_SOURCE_DIR" execute-template --config "$TEST_TMPDIR/config.toml" \
		'{{ includeTemplate "package-excludes" . }}'
}

# undeclared_refs <packages.yaml> -- prints every profile exclusion and every
# configs key that does not name a declared package, one per line.
undeclared_refs() {
	local declared
	declared="$(yq -r '[(.packages.darwin.brews // [])[], (.packages.darwin.casks // [])[], (.packages.linux.dnf // [])[], (.packages.linux.apt // [])[]] | .[]' "$1")"
	yq -r '(.packages.profiles // {} | .[] | .exclude // [] | .[]), (.packages.configs // {} | keys | .[])' "$1" |
		while IFS= read -r name; do
			[ -n "$name" ] || continue
			printf '%s\n' "$declared" | grep -qxF -- "$name" || printf '%s\n' "$name"
		done
}

# ── .chezmoitemplates/package-excludes ───────────────────────────────────────

@test "a named profile resolves to the packages it excludes, one per line" {
	run render_excludes 'machine_profile = "work"'
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local names
	names="$(printf '%s\n' "$output" | sed '/^[[:space:]]*$/d')"
	[ "$names" = "$(printf '%s\n' loop nikitabobko/tap/aerospace)" ] || fail "output was: $output"
}

@test "a blank machine profile excludes nothing" {
	run render_excludes 'machine_profile = ""'
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -z "$(printf '%s' "$output" | tr -d '[:space:]')" ] || fail "output was: $output"
}

@test "a config that predates machine profiles excludes nothing" {
	run render_excludes ""
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -z "$(printf '%s' "$output" | tr -d '[:space:]')" ] || fail "output was: $output"
}

@test "a profile without an exclude list excludes nothing" {
	run render_excludes 'machine_profile = "bare"'
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -z "$(printf '%s' "$output" | tr -d '[:space:]')" ] || fail "output was: $output"
}

@test "an unknown machine profile fails the render and names the known profiles" {
	# Falling back to "install everything" would hide a typo until the
	# unwanted apps showed up.
	run render_excludes 'machine_profile = "wrok"'
	[ "$status" -ne 0 ] || fail "render succeeded with an unknown profile: $output"
	[[ "$output" == *'"wrok"'* ]] || fail "output was: $output"
	[[ "$output" == *"bare, work"* ]] || fail "output was: $output"
}

# ── packages.yaml ────────────────────────────────────────────────────────────

@test "the reference check reports names that are not declared packages" {
	cat >"$TEST_TMPDIR/packages.yaml" <<'EOF'
packages:
  darwin:
    brews: [jq]
    casks: [nikitabobko/tap/aerospace]
  linux:
    dnf: [git]
  configs:
    aerospace: [.config/aerospace]
  profiles:
    work:
      exclude: [jq, loop]
EOF

	run undeclared_refs "$TEST_TMPDIR/packages.yaml"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" = "$(printf '%s\n' loop aerospace)" ] || fail "output was: $output"
}

@test "every profile exclusion and configs entry names a declared package" {
	# Exclusions match list entries exactly, so `aerospace` would silently fail
	# to exclude `nikitabobko/tap/aerospace`.
	run undeclared_refs "$PACKAGES_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -z "$output" ] || fail "not declared as packages: $output"
}

@test "configs paths are relative to the home directory" {
	# .chezmoiignore matches target paths relative to ~; an absolute or
	# ~-prefixed entry never matches anything.
	run yq -r '(.packages.configs // {}) | .[] | .[]' "$PACKAGES_FILE"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	local path
	while IFS= read -r path; do
		[ -n "$path" ] || continue
		case "$path" in
		/* | "~"*) fail "configs path must be relative to ~: $path" ;;
		esac
	done < <(printf '%s\n' "$output")
}

# ── home/.chezmoi.toml.tmpl ──────────────────────────────────────────────────
# Non-interactive path only; promptStringOnce needs a real TTY.

@test ".chezmoi.toml.tmpl records the machine profile from the environment" {
	cp home/.chezmoi.toml.tmpl "$TEST_SOURCE_DIR/"

	run env GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
		MACHINE_PROFILE=gifthealth \
		chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
		--config "$TEST_TMPDIR/config-out.toml" </dev/null
	[ "$status" -eq 0 ] || fail "chezmoi init failed: $output"

	run cat "$TEST_TMPDIR/config-out.toml"
	[[ "$output" == *'machine_profile = "gifthealth"'* ]] || fail "output was: $output"
}

@test ".chezmoi.toml.tmpl leaves the machine profile blank when unset" {
	cp home/.chezmoi.toml.tmpl "$TEST_SOURCE_DIR/"

	run env -u MACHINE_PROFILE GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
		chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
		--config "$TEST_TMPDIR/config-out.toml" </dev/null
	[ "$status" -eq 0 ] || fail "chezmoi init failed: $output"

	run cat "$TEST_TMPDIR/config-out.toml"
	[[ "$output" == *'machine_profile = ""'* ]] || fail "output was: $output"
}
