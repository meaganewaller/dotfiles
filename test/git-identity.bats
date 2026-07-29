#!/usr/bin/env bats

load test_helper

# .chezmoi.toml.tmpl -- non-interactive (env var) path only. The
# promptStringOnce/promptBoolOnce prompt path needs a real TTY and isn't
# exercised here; CI and this test both hit the `env` branch since stdin
# isn't a TTY.

@test ".chezmoi.toml.tmpl renders work_profile and work_email when WORK_PROFILE=true" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  cp "$REPO_ROOT/home/.chezmoi.toml.tmpl" "$TEST_SOURCE_DIR/"

  run env GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
    WORK_PROFILE=true GIT_WORK_USER_EMAIL="work@example.com" \
    chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
    --config "$TEST_TMPDIR/config-out.toml" </dev/null
  [ "$status" -eq 0 ]

  run cat "$TEST_TMPDIR/config-out.toml"
  [[ "$output" == *"work_profile = true"* ]]
  [[ "$output" == *'email = "personal@example.com"'* ]]
  [[ "$output" == *'work_email = "work@example.com"'* ]]
}

@test ".chezmoi.toml.tmpl leaves work_email empty when WORK_PROFILE is unset" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  cp "$REPO_ROOT/home/.chezmoi.toml.tmpl" "$TEST_SOURCE_DIR/"

  run env GIT_USER_NAME="Test User" GIT_USER_EMAIL="personal@example.com" \
    chezmoi init --source "$TEST_SOURCE_DIR" --destination "$TEST_HOME_DIR" \
    --config "$TEST_TMPDIR/config-out.toml" </dev/null
  [ "$status" -eq 0 ]

  run cat "$TEST_TMPDIR/config-out.toml"
  [[ "$output" == *"work_profile = false"* ]]
  [[ "$output" == *'work_email = ""'* ]]
}

# home/dot_config/git/config.tmpl

@test "config.tmpl pins the personal SSH key and skips the workspace includeIf without a work profile" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT/home" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *"signingkey = ~/.ssh/id_ed25519_personal.pub"* ]]
  [[ "$output" == *"IdentityFile=~/.ssh/id_ed25519_personal.pub"* ]]
  [[ "$output" != *'includeIf "gitdir:~/workspace/"'* ]]
}

@test "config.tmpl adds the workspace includeIf on a work profile" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT/home" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *'includeIf "gitdir:~/workspace/"'* ]]
  [[ "$output" == *"path = ~/.config/git/config-work"* ]]
}

# home/dot_config/git/config-work.tmpl

@test "config-work.tmpl overrides identity with the work email and work SSH key" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT/home" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/config-work.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *"email = work@example.com"* ]]
  [[ "$output" == *"signingkey = ~/.ssh/id_ed25519.pub"* ]]
  [[ "$output" == *"IdentityFile=~/.ssh/id_ed25519.pub"* ]]
  [[ "$output" != *"id_ed25519_personal.pub"* ]]
}

# home/dot_config/git/allowed_signers.tmpl

@test "allowed_signers.tmpl trusts only the personal key without a work profile" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT/home" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *"personal@example.com ssh-ed25519"* ]]
  [[ "$output" != *"work@example.com"* ]]
}

@test "allowed_signers.tmpl trusts both keys on a work profile" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT/home" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *"personal@example.com ssh-ed25519"* ]]
  [[ "$output" == *"work@example.com ssh-ed25519"* ]]
}

# These two guard against the hardcoded key material in allowed_signers.tmpl
# silently drifting from the actual checked-in public keys (e.g. a key
# rotation that updates one file but not the other), which would make git
# quietly stop verifying -- or start "verifying" against the wrong key.

@test "allowed_signers.tmpl personal key matches private_dot_ssh/id_ed25519_personal.pub" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  local personal_key
  personal_key="$(cut -d' ' -f1-2 "$REPO_ROOT/home/private_dot_ssh/id_ed25519_personal.pub")"

  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
work_profile = false
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT/home" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = ""
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *"personal@example.com $personal_key"* ]]
}

@test "allowed_signers.tmpl work key matches private_dot_ssh/id_ed25519.pub" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  local work_key
  work_key="$(cut -d' ' -f1-2 "$REPO_ROOT/home/private_dot_ssh/id_ed25519.pub")"

  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
work_profile = true
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT/home" }

[data.git]
name = "Test User"
email = "personal@example.com"
work_email = "work@example.com"
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_config/git/allowed_signers.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *"work@example.com $work_key"* ]]
}
