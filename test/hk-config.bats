#!/usr/bin/env bats

load test_helper

# The HOME hk config.
#
# home/dot_config/hk/config.pkl deploys via chezmoi to ~/.config/hk/config.pkl,
# and hk reads it in EVERY repository on this machine, client work included.
# Nothing else exercises it: hk.pkl (the project's own config) gets evaluated
# for free whenever `hk check` runs in CI, but this file was hand-edited until
# Renovate started managing it too (renovate.json5), and `chezmoi apply` never
# evaluates Pkl. A schema bump that breaks this file would go unnoticed until
# a real `git commit` fails in every repo on the machine.

CONFIG_FILE="home/dot_config/hk/config.pkl"

repo_root() {
	cd "${BATS_TEST_DIRNAME}/.." && pwd
}

@test "the HOME hk config evaluates against its declared schema" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"

	run pkl eval "$(repo_root)/$CONFIG_FILE"
	[ "$status" -eq 0 ] || fail "pkl eval failed: $output"
	[[ "$output" == *"gitleaks"* ]] || fail "eval succeeded but output looks empty: $output"
}
