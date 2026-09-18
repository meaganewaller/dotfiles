#!/usr/bin/env bats

load test_helper

# The gh credential helper in home/dot_config/git/config.tmpl.
#
# git runs the helper by absolute path, so whatever path is baked in at render
# time has to survive gh upgrades. `lookPath "gh"` resolved to mise's versioned
# install dir (…/installs/aqua-cli-cli/latest/gh_2.97.0_macOS_arm64/bin/gh), so
# the next gh bump moved the binary and git auth broke until the next apply.
# See dotfiles-3ik.

repo_root() {
	cd "${BATS_TEST_DIRNAME}/.." && pwd
}

render_git_config() {
	local repo
	repo="$(repo_root)"
	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
sourceDir = "$repo"

[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR" }

[data.git]
name = "Test User"
email = "personal@example.com"
username = "testuser"

[data.git.identity_local.testdouble]
email = ""
signing_key = ""

[data.git.identity_local.gifthealth]
email = ""
signing_key = ""
EOF
	chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$repo/home/dot_config/git/config.tmpl"
}

# Every `helper = !<path> auth git-credential` line's path, one per line.
helper_paths() {
	printf '%s\n' "$1" | sed -n 's/^[[:space:]]*helper = !\(.*\) auth git-credential$/\1/p'
}

@test "the credential helper does not bake in a version-specific gh path" {
	run render_git_config
	[ "$status" -eq 0 ] || fail "render failed: $output"

	local paths
	paths="$(helper_paths "$output")"
	[ -n "$paths" ] || fail "no credential helper rendered; output was: $output"

	local path
	while IFS= read -r path; do
		[ -n "$path" ] || continue
		# A version in the path is the bug: mise installs gh under a directory
		# named for its version, so the path dies on the next bump.
		case "$path" in
		*/installs/*) fail "helper points into a mise install dir, which is version-specific: $path" ;;
		esac
		# `if`, not `grep && fail`: a non-matching grep would make the loop's
		# last command non-zero and bats would report the passing case as a
		# failure. See the note in test_helper.bash.
		if printf '%s\n' "$path" | grep -qE '[0-9]+\.[0-9]+\.[0-9]+'; then
			fail "helper path contains a version number, so a gh upgrade breaks it: $path"
		fi
	done < <(printf '%s\n' "$paths")
}

@test "both credential blocks resolve gh the same way" {
	run render_git_config
	[ "$status" -eq 0 ] || fail "render failed: $output"

	local unique
	unique="$(helper_paths "$output" | sort -u | wc -l | tr -d ' ')"
	[ "$unique" = "1" ] || fail "github.com and gist.github.com disagree: $(helper_paths "$output")"
}

@test "the helper is reachable without relying on the caller's PATH" {
	# git may be invoked by a GUI client whose PATH is minimal, so the helper is
	# an absolute path — or a bare `gh` only if nothing stable was found.
	run render_git_config
	[ "$status" -eq 0 ] || fail "render failed: $output"

	local path
	path="$(helper_paths "$output" | head -1)"
	case "$path" in
	/*) : ;;
	gh) : ;;
	*) fail "helper is neither an absolute path nor a bare gh: $path" ;;
	esac
}
