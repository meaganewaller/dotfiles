#!/usr/bin/env bats

load test_helper

# Beads durability policy.
#
# .chezmoidata/beads.yaml declares which org directories are mine. Beads runs
# in durable mode there (committed lean set, dolt push) and local-only mode
# everywhere else (.git/info/exclude, no sync.remote).
#
# personal_dirs and git.identities[].dirs must stay disjoint: a client org
# classified as personal would commit client issue data to a public history.
# ADR 0013's lesson -- two lists describing one identity will drift -- applies,
# so this asserts they cannot overlap instead of merging them.

repo_root() {
	cd "${BATS_TEST_DIRNAME}/.." && pwd
}

@test "beads.yaml is valid YAML" {
	assert_valid_yaml "$(repo_root)/home/.chezmoidata/beads.yaml"
}

@test "personal_dirs is non-empty" {
	local repo count
	repo="$(repo_root)"
	count="$(yq '.beads.personal_dirs | length' "$repo/home/.chezmoidata/beads.yaml")"
	[[ "$count" -gt 0 ]] || fail "beads.personal_dirs is empty"
}

@test "personal_dirs entries carry no trailing slash" {
	local repo
	repo="$(repo_root)"
	while read -r dir; do
		[[ "$dir" != */ ]] || fail "trailing slash on personal_dirs entry: $dir"
	done < <(yq -r '.beads.personal_dirs[]' "$repo/home/.chezmoidata/beads.yaml")
}

@test "no personal_dirs entry equals, contains, or is contained by a client identity dir" {
	local repo
	repo="$(repo_root)"

	# Fold case: the checkout is ~/src/github.com/Gifthealth, config says
	# gifthealth. A case-sensitive comparison would miss the collision.
	#
	# Exact-string disjointness is not enough: a parent directory such as
	# ~/src/github.com would pass an exact-match check while silently
	# swallowing every client repo underneath it into "personal". Containment
	# is checked on a "/" boundary so ~/src/github.com/gift does not "contain"
	# ~/src/github.com/gifthealth.
	local personal identity p i bad
	personal="$(yq -r '.beads.personal_dirs[]' "$repo/home/.chezmoidata/beads.yaml" | tr '[:upper:]' '[:lower:]')"
	identity="$(yq -r '.git.identities[].dirs[]' "$repo/home/.chezmoidata/git.yaml" | tr '[:upper:]' '[:lower:]')"

	bad=""
	while IFS= read -r p; do
		[ -n "$p" ] || continue
		while IFS= read -r i; do
			[ -n "$i" ] || continue
			if [[ "$p" == "$i" || "$i" == "$p"/* || "$p" == "$i"/* ]]; then
				bad+="$p <-> $i"$'\n'
			fi
		done <<<"$identity"
	done <<<"$personal"

	[ -z "$bad" ] || fail "personal_dirs overlaps a client identity dir: $bad"
}
