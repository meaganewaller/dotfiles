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
	local REPO_ROOT WRAPPER
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	WRAPPER="$REPO_ROOT/home/dot_config/shell/bd.sh.tmpl"

	# Guards the opposite mistake: taking 1Password out of shell startup must
	# not leave zero routes to a secret.
	#
	# This used to name `mise run secrets`, which wrote ~/.secrets. That file
	# turned out to have one writer and no readers -- see dotfiles-ogz -- so the
	# assertion now names the route that actually carries a key to a consumer.
	# What matters is that *a* route exists, not which one.
	grep -q "fnox exec" "$WRAPPER" ||
		fail "no per-invocation route to a secret is left; nothing can reach LINEAR_API_KEY"
}

@test "no route materializes a plaintext secret on disk" {
	local REPO_ROOT MISE_CONFIG hits
	REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
	MISE_CONFIG="$REPO_ROOT/home/dot_config/mise/config.toml.tmpl"

	# ~/.secrets was a generated plaintext credential that nothing read: exactly
	# one writer, zero readers, and the key sitting in the clear for anything
	# running as this user to pick up. `fnox exec` hands a key to one process
	# and leaves nothing behind, which is the property worth keeping.
	#
	# Match the assignment, not the prose: the [env] comment explains at length
	# why the export is gone and necessarily names it.
	hits="$(grep -n "^\[tasks\.secrets\]" "$MISE_CONFIG" || true)"
	[ -z "$hits" ] || fail "the secrets export task is back; it writes a plaintext key nothing reads: $hits"

	hits="$(grep -n "fnox export" "$MISE_CONFIG" | grep -vE ":[[:space:]]*#" || true)"
	[ -z "$hits" ] || fail "something exports fnox secrets to a file again: $hits"
}
