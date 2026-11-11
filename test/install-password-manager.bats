#!/usr/bin/env bats
#
# bin/install-password-manager runs as chezmoi's read-source-state.pre hook, so
# a failure there stops every chezmoi command. On Linux it installs the
# 1Password CLI from 1Password's signed apt or dnf repository, trusting only
# the key committed at share/1password/1password.asc (dotfiles-3ub).
#
# Every system tool the script reaches for is a stub on a PATH that holds
# nothing else, so a test can't touch the real package manager, and "apt-get
# is missing" is just a stub that isn't there. SYSROOT redirects the files the
# script writes under /etc.

load test_helper

SCRIPT="bin/install-password-manager"
KEY="share/1password/1password.asc"
FINGERPRINT="3FEF9748469ADBE15DA7CA80AC2D62742012EA22"

# Stub <name> [body]: an executable on the test PATH that logs its argv and
# then runs body (default: succeed silently).
stub() {
	local name="$1" body="${2:-}"
	cat >"$TEST_TMPDIR/bin/$name" <<EOF
#!/bin/sh
echo "$name \$*" >>"$TEST_TMPDIR/calls.log"
$body
EOF
	chmod +x "$TEST_TMPDIR/bin/$name"
}

# A PATH with the real coreutils the script needs and no package manager.
make_path() {
	local tool
	mkdir -p "$TEST_TMPDIR/bin" "$TEST_TMPDIR/root"
	: >"$TEST_TMPDIR/calls.log"
	for tool in cat dirname install mkdir tee; do
		ln -s "$(command -v "$tool")" "$TEST_TMPDIR/bin/$tool"
	done
	# sudo just runs the command: SYSROOT keeps the writes inside the test dir.
	cat >"$TEST_TMPDIR/bin/sudo" <<EOF
#!/bin/sh
echo "sudo \$*" >>"$TEST_TMPDIR/calls.log"
exec "\$@"
EOF
	chmod +x "$TEST_TMPDIR/bin/sudo"
	stub uname 'case "$1" in -s) echo Linux ;; *) echo x86_64 ;; esac'
}

run_script() {
	run env -i PATH="$TEST_TMPDIR/bin" SYSROOT="$TEST_TMPDIR/root" /bin/sh "$SCRIPT"
}

@test "is valid POSIX shell" {
	run /bin/sh -n "$SCRIPT"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
}

@test "does nothing when op is already installed" {
	make_path
	stub op
	stub apt-get

	run_script
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	run cat "$TEST_TMPDIR/calls.log"
	[[ "$output" != *"apt-get"* && "$output" != *"sudo"* ]] || fail "calls: $output"
}

@test "apt: trusts only the committed key and installs from 1Password's repo" {
	make_path
	stub dpkg 'echo arm64'
	stub apt-get

	run_script
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	cmp -s "$KEY" "$TEST_TMPDIR/root/etc/apt/keyrings/1password.asc" || fail "keyring is not the committed key"

	local sources="$TEST_TMPDIR/root/etc/apt/sources.list.d/1password.sources"
	run cat "$sources"
	[ "$status" -eq 0 ] || fail "no sources file at $sources"
	[[ "$output" == *"URIs: https://downloads.1password.com/linux/debian/arm64"* ]] || fail "sources: $output"
	# The path apt reads at run time, not the SYSROOT one.
	[[ "$output" == *"Signed-By: /etc/apt/keyrings/1password.asc"* ]] || fail "sources: $output"

	run cat "$TEST_TMPDIR/calls.log"
	[[ "$output" == *"apt-get update"* ]] || fail "calls: $output"
	[[ "$output" == *"apt-get install -y 1password-cli"* ]] || fail "calls: $output"
	# Nothing reaches for a version lookup or a bare download any more.
	[[ "$output" != *"curl"* && "$output" != *"unzip"* ]] || fail "calls: $output"
}

@test "apt: refuses an architecture 1Password has no repo for, before writing anything" {
	make_path
	stub dpkg 'echo armhf'
	stub apt-get

	run_script
	[ "$status" -ne 0 ] || fail "expected failure, got status=$status output=$output"
	[[ "$output" == *"armhf"* ]] || fail "output: $output"
	[ ! -e "$TEST_TMPDIR/root/etc" ] || fail "wrote under /etc anyway"
	run cat "$TEST_TMPDIR/calls.log"
	[[ "$output" != *"apt-get"* ]] || fail "calls: $output"
}

@test "dnf: used when apt-get is absent, with package and metadata signatures checked" {
	make_path
	stub dnf

	run_script
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	cmp -s "$KEY" "$TEST_TMPDIR/root/etc/pki/rpm-gpg/1password.asc" || fail "rpm key is not the committed key"

	run cat "$TEST_TMPDIR/root/etc/yum.repos.d/1password.repo"
	[ "$status" -eq 0 ] || fail "no repo file"
	[[ "$output" == *'baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch'* ]] || fail "repo: $output"
	[[ "$output" == *"gpgcheck=1"* && "$output" == *"repo_gpgcheck=1"* ]] || fail "repo: $output"
	[[ "$output" == *"gpgkey=file:///etc/pki/rpm-gpg/1password.asc"* ]] || fail "repo: $output"

	run cat "$TEST_TMPDIR/calls.log"
	[[ "$output" == *"dnf install -y 1password-cli"* ]] || fail "calls: $output"
}

@test "fails with a pointer when there is no apt-get or dnf" {
	make_path

	run_script
	[ "$status" -ne 0 ] || fail "expected failure, got status=$status output=$output"
	[[ "$output" == *"developer.1password.com"* ]] || fail "output: $output"
}

@test "the committed key is 1Password's signing key and not close to expiring" {
	command -v gpg >/dev/null 2>&1 || skip "gpg not installed"

	run gpg --show-keys --with-colons "$KEY"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"

	# Exactly one primary key, with the fingerprint 1Password publishes.
	[ "$(printf '%s\n' "$output" | grep -c '^pub:')" -eq 1 ] || fail "expected one primary key: $output"
	printf '%s\n' "$output" | grep -q "^fpr:::::::::$FINGERPRINT:" || fail "fingerprint is not $FINGERPRINT: $output"

	# Field 7 of the pub line is the expiry (epoch seconds). Fail half a year
	# out, so there's time to refresh it (docs/renovate.md) before apt and dnf
	# start rejecting the repo.
	local expires
	expires=$(printf '%s\n' "$output" | awk -F: '/^pub:/ { print $7 }')
	[ -n "$expires" ] || fail "key has no expiry recorded: $output"
	[ "$expires" -gt $(($(date +%s) + 180 * 86400)) ] || fail "key expires $(date -r "$expires" 2>/dev/null || date -d "@$expires")"
}
