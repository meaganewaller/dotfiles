#!/usr/bin/env bats

load test_helper

# The Sigstore trusted root pinned at share/sigstore/trusted_root.json.
#
# ./install verifies chezmoi's release with `cosign verify-blob --key`, which
# still needs Sigstore's trusted root to check the bundle's transparency-log
# material. cosign fetches that live from tuf-repo-cdn.sigstore.dev, which 403s
# from GitHub Actions runners — so the Docker build died with "trusted root is
# required when using new bundle format" (dotfiles-adz). The installer now
# falls back to this pinned copy when the live fetch fails.
#
# These tests run cosign with a proxy pointed at a dead port and an empty TUF
# cache, which is what "the CDN is unreachable" looks like from cosign.

ROOT="share/sigstore/trusted_root.json"
FIXTURES="test/fixtures/cosign"
BLOB="chezmoi_2.72.2_checksums.txt"

setup_offline() {
	export TUF_ROOT="$TEST_TMPDIR/empty-tuf-cache"
	export HTTPS_PROXY="http://127.0.0.1:1"
	export HTTP_PROXY="http://127.0.0.1:1"
}

verify_offline() {
	cosign verify-blob \
		--bundle "$FIXTURES/$BLOB.sigstore.json" \
		--key "$FIXTURES/chezmoi_cosign.pub" \
		--trusted-root "$ROOT" \
		"$1"
}

@test "the pinned trusted root is valid JSON with the material cosign needs" {
	[ -f "$ROOT" ] || fail "no pinned trusted root at $ROOT"

	run jq -e '.certificateAuthorities and .tlogs' "$ROOT"
	[ "$status" -eq 0 ] || fail "missing certificateAuthorities or tlogs: $output"
}

@test "the pinned root verifies a real chezmoi signature with the CDN unreachable" {
	command -v cosign >/dev/null 2>&1 || skip "cosign not installed"
	setup_offline

	run verify_offline "$FIXTURES/$BLOB"
	[ "$status" -eq 0 ] || fail "verification failed offline: $output"
	[[ "$output" == *"Verified OK"* ]] || fail "output was: $output"
}

@test "the pinned root still rejects a tampered blob" {
	command -v cosign >/dev/null 2>&1 || skip "cosign not installed"
	setup_offline

	# A fix that verifies nothing would be worse than the bug it replaces.
	cp "$FIXTURES/$BLOB" "$TEST_TMPDIR/tampered.txt"
	printf 'deadbeef  chezmoi_evil.tar.gz\n' >>"$TEST_TMPDIR/tampered.txt"

	run verify_offline "$TEST_TMPDIR/tampered.txt"
	[ "$status" -ne 0 ] || fail "tampered blob verified as OK: $output"
}

@test "install falls back to the pinned root instead of failing" {
	# The installer must reach for the pinned copy when the live TUF fetch
	# fails; without this it aborts the whole bootstrap on a CDN hiccup.
	run grep -n "trusted-root" install
	[ "$status" -eq 0 ] || fail "install never passes --trusted-root"

	run grep -c "cosign verify-blob" install
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ "$output" -ge 2 ] || fail "expected a live attempt and a pinned retry, found $output verify-blob calls"
}

@test "the pinned root is referenced by the path install expects" {
	run grep -n "share/sigstore/trusted_root.json" install
	[ "$status" -eq 0 ] || fail "install does not reference $ROOT"
}
