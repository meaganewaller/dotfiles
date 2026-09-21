#!/usr/bin/env bats

load test_helper

MANIFEST="home/dot_config/fnox/config.toml"

@test "fnox manifest is valid TOML" {
	[ -f "$MANIFEST" ] || fail "manifest not found at $MANIFEST"

	run yq -p toml -o y '.' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "every secret references a declared provider" {
	local declared
	declared="$(yq -p toml -o y '.providers | keys | .[]' "$MANIFEST")"
	[ -n "$declared" ] || fail "no providers declared in $MANIFEST"

	run yq -p toml -o y '[.. | select(has("provider")) | .provider] | unique | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "no secrets declare a provider"

	while IFS= read -r used; do
		[ -n "$used" ] || continue
		grep -qx -- "$used" <<<"$declared" || fail "secret uses undeclared provider: $used"
	done <<<"$output"
}

@test "every secret value is an op:// reference, never a literal" {
	run yq -p toml -o y '[.. | select(has("value")) | .value] | .[]' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "no secret values found in $MANIFEST"

	while IFS= read -r value; do
		[ -n "$value" ] || continue
		[[ "$value" == op://* ]] || fail "value is not an op:// reference: $value"
	done <<<"$output"
}

@test "manifest declares the 1password provider type" {
	run yq -p toml -o y '.providers.onepassword.type' "$MANIFEST"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" = "1password" ] || fail "expected provider type 1password, got: $output"
}
