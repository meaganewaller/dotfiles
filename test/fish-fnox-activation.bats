#!/usr/bin/env bats

load test_helper

# fnox is integrated through mise (`_.fnox-env` in dot_config/mise/config.toml.tmpl),
# which every shell already picks up via `mise activate`. A second, shell-native
# `fnox activate` is not redundant-but-harmless: both resolve secrets from their
# provider, so each one costs a separate 1Password unlock on every new shell.
#
# See docs/fish.md. This guard exists because the duplicate was invisible while
# no fnox manifest existed -- neither path resolved anything, so neither prompted.
@test "no shell config invokes fnox activate; mise owns the integration" {
	local REPO_ROOT hits
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"

	# Match invocations, not prose: .chezmoiremove documents why the fish
	# activation was removed and necessarily names it.
	hits="$(grep -rn "fnox activate" "$REPO_ROOT/home" 2>/dev/null |
		grep -vE ":[[:space:]]*#" || true)"
	[ -z "$hits" ] || fail "shell-native fnox activation found, duplicating the mise integration: $hits"
}

@test "mise still carries the fnox env integration" {
	local REPO_ROOT
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"

	# Guards the opposite mistake: removing the duplicate must not leave zero
	# integrations, which would silently stop injecting secrets into shells.
	grep -q "_.fnox-env" "$REPO_ROOT/home/dot_config/mise/config.toml.tmpl" ||
		fail "mise no longer configures the fnox env plugin"
}
