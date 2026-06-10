#!/usr/bin/env bats

load test_helper

SCRIPT="bin/resolve-bedrock-models"

# A representative `aws bedrock list-foundation-models` payload: one ACTIVE model
# per tier, plus noise that must be filtered out (a context-window variant, a
# non-ACTIVE model, and a non-Claude model).
write_sample() {
  SAMPLE="$TEST_TMPDIR/models.json"
  cat >"$SAMPLE" <<'JSON'
{
  "modelSummaries": [
    {"modelId": "anthropic.claude-opus-4-20250514-v1:0",     "modelLifecycle": {"status": "ACTIVE"}},
    {"modelId": "anthropic.claude-opus-4-20250514-v1:0:200k","modelLifecycle": {"status": "ACTIVE"}},
    {"modelId": "anthropic.claude-opus-3-legacy-v1:0",       "modelLifecycle": {"status": "LEGACY"}},
    {"modelId": "anthropic.claude-sonnet-4-20250514-v1:0",   "modelLifecycle": {"status": "ACTIVE"}},
    {"modelId": "anthropic.claude-3-5-haiku-20241022-v1:0",  "modelLifecycle": {"status": "ACTIVE"}},
    {"modelId": "amazon.titan-text-v1",                      "modelLifecycle": {"status": "ACTIVE"}}
  ]
}
JSON
}

# Stub `aws` on PATH. mode=ok prints the sample; mode=fail exits non-zero.
make_stub_aws() {
  STUBDIR="$TEST_TMPDIR/stub"
  mkdir -p "$STUBDIR"
  if [ "$1" = ok ]; then
    cat >"$STUBDIR/aws" <<EOF
#!/usr/bin/env bash
cat "$SAMPLE"
EOF
  else
    printf '#!/usr/bin/env bash\nexit 1\n' >"$STUBDIR/aws"
  fi
  chmod +x "$STUBDIR/aws"
}

# The pure resolution filter, mirrored from bin/resolve-bedrock-models, so the
# selection logic can be tested without invoking aws.
RESOLVE_FILTER='
  .modelSummaries
  | map(select(
      .modelLifecycle.status == "ACTIVE"
      and (.modelId | startswith("anthropic.claude-"))
      and (.modelId | test(":\\d+k$") | not)
  ))
  | map(.modelId)
  | {
      opus:   map(select(contains("opus")))   | sort | last,
      sonnet: map(select(contains("sonnet"))) | sort | last,
      haiku:  map(select(contains("haiku")))  | sort | last
    }
  | with_entries(select(.value != null))
  | with_entries(.value = "us." + .value)
'

@test "resolution filter picks one active profile per tier, prefixed us." {
  write_sample
  run jq "$RESOLVE_FILTER" "$SAMPLE"
  [ "$status" -eq 0 ]
  echo "$output" | jq -e '.opus   == "us.anthropic.claude-opus-4-20250514-v1:0"'
  echo "$output" | jq -e '.sonnet == "us.anthropic.claude-sonnet-4-20250514-v1:0"'
  echo "$output" | jq -e '.haiku  == "us.anthropic.claude-3-5-haiku-20241022-v1:0"'
}

@test "resolution filter excludes context-window variants and non-ACTIVE models" {
  write_sample
  run jq "$RESOLVE_FILTER" "$SAMPLE"
  [ "$status" -eq 0 ]
  # The :200k variant and the LEGACY model must not leak through.
  [[ "$output" != *":200k"* ]]
  [[ "$output" != *"legacy"* ]]
  [[ "$output" != *"titan"* ]]
}

@test "writes a cache and emits resolved models on a cold run" {
  write_sample
  make_stub_aws ok
  run env PATH="$STUBDIR:$PATH" XDG_DATA_HOME="$TEST_TMPDIR/xdg" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | jq -e '.opus == "us.anthropic.claude-opus-4-20250514-v1:0"'
  [ -f "$TEST_TMPDIR/xdg/dotfiles/bedrock-models.json" ]
}

@test "serves a fresh cache without calling aws" {
  write_sample
  make_stub_aws ok # would emit the sample; a fresh cache must win instead
  mkdir -p "$TEST_TMPDIR/xdg/dotfiles"
  echo '{"opus":"us.FRESH-CACHE"}' >"$TEST_TMPDIR/xdg/dotfiles/bedrock-models.json"

  run env PATH="$STUBDIR:$PATH" XDG_DATA_HOME="$TEST_TMPDIR/xdg" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | jq -e '.opus == "us.FRESH-CACHE"'
}

@test "falls back to a stale cache when refresh fails" {
  write_sample
  make_stub_aws fail
  mkdir -p "$TEST_TMPDIR/xdg/dotfiles"
  echo '{"opus":"us.STALE-CACHE"}' >"$TEST_TMPDIR/xdg/dotfiles/bedrock-models.json"
  touch -t 202001010000 "$TEST_TMPDIR/xdg/dotfiles/bedrock-models.json" # force stale

  run env PATH="$STUBDIR:$PATH" XDG_DATA_HOME="$TEST_TMPDIR/xdg" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  echo "$output" | jq -e '.opus == "us.STALE-CACHE"'
}

@test "emits {} when refresh fails and there is no cache" {
  write_sample
  make_stub_aws fail
  run env PATH="$STUBDIR:$PATH" XDG_DATA_HOME="$TEST_TMPDIR/xdg-empty" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [ "$output" = "{}" ]
}

@test "degrades gracefully when aws is not installed" {
  # Clean PATH with the interpreter + coreutils + jq the script needs, but no aws.
  local clean="$TEST_TMPDIR/clean"
  mkdir -p "$clean"
  local c
  for c in bash jq date stat mkdir cat; do
    ln -s "$(command -v "$c")" "$clean/$c"
  done

  run env -i PATH="$clean" HOME="$TEST_HOME_DIR" XDG_DATA_HOME="$TEST_TMPDIR/xdg" bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"{}"* ]]
}
