#!/usr/bin/env bats

load test_helper

@test "dot_zshrc.tmpl renders with chezmoi" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  mkdir -p "$TEST_HOME_DIR/.config"
  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT" }
EOF

  run chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_zshrc.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *"_dotfiles_is_agent_shell"* ]]
}

@test "agent minimal path leaves cat unaliased to bat when full profile would alias" {
  local REPO_ROOT
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
  mkdir -p "$TEST_HOME_DIR/.config/zsh/functions"
  cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$REPO_ROOT" }
EOF

  chezmoi execute-template --config "$TEST_TMPDIR/chezmoi.toml" --file "$REPO_ROOT/home/dot_zshrc.tmpl" >"$TEST_TMPDIR/rendered.zshrc"

  # Skip if rendered profile never defines cat→bat (no bat on template machine)
  if ! grep -q "alias cat='bat'" "$TEST_TMPDIR/rendered.zshrc"; then
    skip "template did not emit bat cat alias (bat not present at render time)"
  fi

  run env HOME="$TEST_HOME_DIR" XDG_CONFIG_HOME="$TEST_HOME_DIR/.config" DOTFILES_AGENT_SHELL=1 \
    zsh --no-rcs -c "source '$TEST_TMPDIR/rendered.zshrc'; whence cat"
  [ "$status" -eq 0 ]
  [[ "$output" != *"alias"* ]]
}
