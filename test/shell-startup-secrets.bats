#!/usr/bin/env bats

load test_helper

# Nothing that resolves a secret may sit in the path of opening a shell.
#
# Two integrations have tried. A shell-native `fnox activate` in fish, and
# mise's `_.fnox-env` plugin. Both answer by shelling out to the 1Password CLI
# while the shell is still starting, so each one costs a Touch ID unlock per
# terminal -- and the mise one re-resolves on every shim invocation besides,
# because mise rebuilds its environment for each shim call.
#
# Measured before removal: two unlocks per interactive fish, because Homebrew's
# vendor_conf.d/mise-activate.fish activates mise before ~/.config/fish/conf.d
# and config.fish activates it again.
#
# Secrets reach their consumers on demand instead: ~/.secrets for agents and
# dotenv-only tools via `mise run secrets`, and `fnox exec` for one process.
# See dot_config/fnox/config.toml and
# docs/superpowers/specs/2026-09-20-fnox-secrets-design.md.

@test "no shell config invokes fnox activate" {
	local REPO_ROOT hits
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"

	# Match invocations, not prose: .chezmoiremove documents why the fish
	# activation was removed and necessarily names it.
	hits="$(grep -rn "fnox activate" "$REPO_ROOT/home" 2>/dev/null |
		grep -vE ":[[:space:]]*#" || true)"
	[ -z "$hits" ] || fail "shell-native fnox activation found, costing an unlock per shell: $hits"
}

@test "mise does not resolve fnox secrets while building its environment" {
	local REPO_ROOT MISE_CONFIG hits
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	MISE_CONFIG="$REPO_ROOT/home/dot_config/mise/config.toml.tmpl"

	# Match the assignment, not the prose: the [env] comment explains at length
	# why the plugin is gone and necessarily names it.
	hits="$(grep -n "_\.fnox-env" "$MISE_CONFIG" | grep -vE ":[[:space:]]*#" || true)"
	[ -z "$hits" ] || fail "mise resolves fnox secrets at env setup, costing an unlock per shell: $hits"

	hits="$(grep -n "mise-env-fnox" "$MISE_CONFIG" | grep -vE ":[[:space:]]*#" || true)"
	[ -z "$hits" ] || fail "the fnox env plugin is still installed: $hits"
}

@test "secrets still reach their consumers on demand" {
	local REPO_ROOT MISE_CONFIG
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	MISE_CONFIG="$REPO_ROOT/home/dot_config/mise/config.toml.tmpl"

	# Guards the opposite mistake: taking 1Password out of shell startup must
	# not leave zero routes to a secret. `mise run secrets` is the one that
	# serves agents, which have no shell to inherit from.
	grep -q "^\[tasks\.secrets\]" "$MISE_CONFIG" ||
		fail "the secrets task is gone; nothing materializes ~/.secrets"
	grep -q "fnox export" "$MISE_CONFIG" ||
		fail "the secrets task no longer exports through fnox"
}
