# fnox `~/.secrets` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Materialize `~/.secrets` from a committed, chezmoi-managed fnox manifest of 1Password references, so coding agents and dotenv-only tools have API keys on disk at `0600`.

**Architecture:** A global fnox manifest at `home/dot_config/fnox/config.toml` holds `op://` pointers only. A global mise task (`mise run secrets`) exports them through the 1Password CLI into `~/.secrets`, guarded against four silent failure modes. Interactive shells are unaffected — they already receive these vars natively through the `_.fnox-env` mise plugin.

**Tech Stack:** fnox 1.24.0, `op` 2.38.1, chezmoi, mise, BATS, `yq` (TOML parsing), shellcheck.

**Spec:** [`docs/superpowers/specs/2026-09-20-fnox-secrets-design.md`](../specs/2026-09-20-fnox-secrets-design.md)
**Beads:** `dotfiles-4zt`

## Global Constraints

- **Never edit managed paths in `~` directly.** All changes go in the chezmoi source tree under `home/`, then `chezmoi apply`. See `docs/agents/chezmoi.md`.
- **American English** in all commits, comments, and docs.
- **Every commit routes through `/git-workflow:commit`.** Do not craft `git commit -m` by hand.
- **The manifest holds `op://` pointers only — never a literal secret value.** It is committed to a public repository.
- **BATS assertions must be guarded with `|| fail "..."`.** Bats only checks the exit status of a test's *last* command; a bare `[[ ... ]]` earlier in the body is silently ignored. See the comment on `fail()` in `test/test_helper.bash`.
- **BATS files use tabs**, matching every existing file in `test/`.
- **`./bin/test` ignores its arguments** (it runs `exec bats ./**/*.bats`). Run a single file with `bats test/<name>.bats`.
- **`yq` needs an explicit `-o y`** when reading TOML, or it emits a deprecation warning to stderr that bats folds into `$output` and breaks assertions.

## Verified Facts

Established empirically on 2026-09-20 before this plan was written. Do not re-derive; do not assume otherwise.

| Fact | Evidence |
| --- | --- |
| `{ type = "1password" }` needs no `vault`/`account` key | `fnox get` resolved a fully-qualified `op://` URI, item name containing spaces |
| The real Linear reference is `op://Automation/Linear Onlooker API Key/credential` | Live value hashed and matched against every candidate item/field |
| `--format env` emits `export KEY='value'` under a 4-line header | direct output inspection |
| A `'` in any value makes the **whole file** unsourceable | `bash: unexpected EOF while looking for matching '` |
| `--output` respects the caller's umask | `umask 022` → `-rw-r--r--`; `umask 077` → `-rw-------` |
| fnox merges **every** ancestor `fnox.toml`; `--config` fully isolates | nested dirs: bare export leaked both, `--config` emitted one |
| Global mise tasks are visible and runnable from any cwd, and execute with `$PWD` = `$HOME` | `MISE_GLOBAL_CONFIG_FILE` probe |
| `.chezmoiignore` does not exclude `.config/fnox/` | grep |
| The task body is shellcheck-clean with a shebang prepended | `shellcheck 0.11.0` |

---

### Task 1: fnox manifest

**Files:**
- Create: `home/dot_config/fnox/config.toml`
- Test: `test/fnox-config.bats`

**Interfaces:**
- Consumes: nothing.
- Produces: `~/.config/fnox/config.toml` after apply, declaring provider `onepassword` and secret `LINEAR_API_KEY`. Task 2's mise task reads it by absolute path.

- [ ] **Step 1: Write the failing test**

Create `test/fnox-config.bats` (tabs, not spaces):

```bash
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
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bats test/fnox-config.bats`
Expected: FAIL — `manifest not found at home/dot_config/fnox/config.toml`

- [ ] **Step 3: Create the manifest**

Create `home/dot_config/fnox/config.toml`:

```toml
# Machine-wide fnox manifest -> ~/.config/fnox/config.toml
#
# Holds 1Password *references*, never values: this repository is public. A
# reference names a vault and an item, which is a pointer, not a credential.
#
# Two consumers, by two different routes:
#   - Interactive shells get these as env vars natively, via the `_.fnox-env`
#     plugin in ~/.config/mise/config.toml. Nothing sources ~/.secrets.
#   - Agents and dotenv-only tools read ~/.secrets, materialized on demand by
#     `mise run secrets`.
#
# A bare `1password` provider is sufficient because every value below is a
# fully-qualified op:// URI; no vault or account key is needed. Authentication
# rides on the 1Password desktop app's session (`op account list` to check).
#
# Keys shared by every machine go in [secrets]. fnox merges [secrets] into
# whichever profile mise selects, so a work-only key would go in a
# [profiles.work.secrets] block -- there is no such key yet.

[providers]
onepassword = { type = "1password" }

[secrets]
LINEAR_API_KEY = { provider = "onepassword", value = "op://Automation/Linear Onlooker API Key/credential" }
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bats test/fnox-config.bats`
Expected: PASS, 4 tests

- [ ] **Step 5: Verify the manifest actually resolves against 1Password**

Run: `fnox get LINEAR_API_KEY --config home/dot_config/fnox/config.toml | wc -c`
Expected: `49` (48 characters plus a trailing newline). **Do not print the value.**

If this returns an error rather than a length, 1Password is locked — unlock it and retry. Do not change the reference: it was confirmed correct by hash comparison against the live value.

- [ ] **Step 6: Commit**

Invoke `/git-workflow:commit` with the manifest and its test staged. Do not write the commit by hand.

---

### Task 2: `mise run secrets` task

**Files:**
- Modify: `home/dot_config/mise/config.toml.tmpl`
- Test: `test/mise-secrets-task.bats`

**Interfaces:**
- Consumes: `~/.config/fnox/config.toml` from Task 1, by absolute path.
- Produces: a `secrets` mise task, invocable from any directory, that writes `~/.secrets` at `0600`.

**Why each guard exists** — all four are load-bearing, and all four fail silently without the guard:

| Failure | Guard |
| --- | --- |
| A `'` in any value corrupts every key in the file | `bash -n` on the temp file, before `mv` |
| Export fails partway, stranding live keys in `$HOME` | `trap … EXIT` |
| The file is world-readable, even briefly | `umask 077`, same-filesystem `mktemp`, atomic `mv` |
| A project's `fnox.toml` leaks into the machine-wide file | `--config` pins the manifest |

- [ ] **Step 1: Write the failing test**

Create `test/mise-secrets-task.bats` (tabs, not spaces):

```bash
#!/usr/bin/env bats

load test_helper

TEMPLATE="home/dot_config/mise/config.toml.tmpl"

# Render the mise config template into $TEST_TMPDIR/mise.toml and echo the path.
render_mise_config() {
	cp "$BATS_TEST_DIRNAME/../$TEMPLATE" "$TEST_SOURCE_DIR/config.toml.tmpl"

	cat >"$TEST_TMPDIR/chezmoi.toml" <<EOF
[data]
    work_profile = false
    chezmoi = { os = "darwin", homeDir = "$TEST_HOME_DIR", sourceDir = "$TEST_SOURCE_DIR" }
EOF

	chezmoi --source "$TEST_SOURCE_DIR" execute-template \
		--config "$TEST_TMPDIR/chezmoi.toml" \
		--file "$TEST_SOURCE_DIR/config.toml.tmpl" >"$TEST_TMPDIR/mise.toml" ||
		fail "template did not render"

	echo "$TEST_TMPDIR/mise.toml"
}

@test "rendered mise config is valid TOML and defines a secrets task" {
	local rendered
	rendered="$(render_mise_config)"

	run yq -p toml -o y '.tasks.secrets.description' "$rendered"
	[ "$status" -eq 0 ] || fail "status=$status output=$output"
	[ -n "$output" ] || fail "secrets task has no description"
	[ "$output" != "null" ] || fail "no [tasks.secrets] in rendered config"
}

@test "secrets task body is valid shell" {
	local rendered body
	rendered="$(render_mise_config)"
	body="$(yq -p toml -o y '.tasks.secrets.run' "$rendered")"
	[ -n "$body" ] && [ "$body" != "null" ] || fail "secrets task has an empty run body"

	assert_valid_shell "$(printf '#!/usr/bin/env bash\n%s\n' "$body")"
}

@test "secrets task pins the manifest so project configs cannot leak in" {
	local rendered body
	rendered="$(render_mise_config)"
	body="$(yq -p toml -o y '.tasks.secrets.run' "$rendered")"

	# fnox merges every ancestor fnox.toml. Without --config, running this task
	# from inside a project would fold that project's secrets into ~/.secrets.
	[[ "$body" == *"--config"* ]] || fail "export does not pin a config path: $body"
	[[ "$body" == *".config/fnox/config.toml"* ]] || fail "export does not point at the global manifest: $body"
}

@test "secrets task writes atomically, privately, and validated" {
	local rendered body
	rendered="$(render_mise_config)"
	body="$(yq -p toml -o y '.tasks.secrets.run' "$rendered")"

	[[ "$body" == *"umask 077"* ]] || fail "no umask 077: $body"
	[[ "$body" == *"trap "* ]] || fail "no trap to clean up the temp file: $body"
	[[ "$body" == *"bash -n"* ]] || fail "no syntax validation before replace: $body"
	[[ "$body" == *"mv -f"* ]] || fail "no atomic replace: $body"

	# The temp file must be a sibling of the target. $TMPDIR is a different APFS
	# volume from /Users on macOS, which would silently downgrade mv from an
	# atomic rename to copy-then-unlink.
	[[ "$body" == *'mktemp "$HOME/.secrets.'* ]] || fail "temp file is not a sibling of the target: $body"
	[[ "$body" != *'mktemp "${TMPDIR'* ]] || fail "temp file is in TMPDIR, breaking atomic replace: $body"
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bats test/mise-secrets-task.bats`
Expected: FAIL — `no [tasks.secrets] in rendered config`

- [ ] **Step 3: Add the task to the mise template**

Append to `home/dot_config/mise/config.toml.tmpl`. Placement: at the end of the file, after the existing `[tools]` and settings blocks. The body contains no `{{` sequences, so it needs no template escaping.

```toml

# Regenerate ~/.secrets from the machine-wide fnox manifest, on demand.
#
# Deliberately NOT a chezmoi run_onchange_ script: `chezmoi apply` runs
# constantly in the dotfiles repo, and tying it to apply would mean a locked
# 1Password fails an unrelated apply.
#
# Every line below is load-bearing:
#   --config  fnox merges every ancestor fnox.toml, and mise tasks are
#             invocable from anywhere -- without this, running from inside a
#             project folds that project's secrets into the machine-wide file.
#   umask     fnox's --output respects it; 0600 from creation, not after.
#   mktemp    a sibling of the target, so `mv` is a real rename(2). $TMPDIR is
#             a different APFS volume from /Users and would degrade it to
#             copy-then-unlink, reopening the world-readable window.
#   trap      a partial export otherwise strands live keys in $HOME.
#   bash -n   fnox does not escape single quotes, and one `'` in any value
#             makes the whole file unsourceable. Validating the temp file
#             means a corrupt export leaves the previous ~/.secrets intact.
[tasks.secrets]
description = "Regenerate ~/.secrets from the fnox manifest"
run = '''
umask 077
tmp="$(mktemp "$HOME/.secrets.XXXXXX")"
trap 'rm -f "$tmp"' EXIT
fnox export --config "$HOME/.config/fnox/config.toml" --format env --output "$tmp"
bash -n "$tmp"
mv -f "$tmp" "$HOME/.secrets"
'''
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bats test/mise-secrets-task.bats`
Expected: PASS, 4 tests

- [ ] **Step 5: Confirm no regression in the rest of the suite**

Run: `./bin/test`
Expected: PASS. The mise template is rendered by other tests; a TOML syntax error would surface here.

- [ ] **Step 6: Commit**

Invoke `/git-workflow:commit`.

---

### Task 3: Block agent writes to `~/.secrets`

**Files:**
- Modify: `home/dot_local/libexec/executable_block-sensitive-or-generated-writes` (the `sensitive_path_regex` assignment)
- Test: `test/block-sensitive-or-generated-writes.bats`

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces: nothing later tasks read. Independent; orderable anywhere.

`~/.secrets` is generated. A hand-edit disappears at the next `mise run secrets` with no warning, so the guard should refuse it. The current regex matches `secrets.toml` and `secrets.yaml` via its `(credentials|secrets?)\.(json|ya?ml|toml|env)$` branch, but a bare `.secrets` has no extension to match.

The fnox manifest is deliberately **not** blocked: it holds pointers rather than values, and has to stay editable.

- [ ] **Step 1: Add the failing assertions**

In `test/block-sensitive-or-generated-writes.bats`, add to the existing `@test "blocks sensitive file paths"` block, after the `assert_blocked "MultiEdit" "$HOME/.env"` line:

```bash
	assert_blocked "Write" "$HOME/.secrets"
	assert_blocked "Edit" "$HOME/.secrets"
```

Then add a new test after it, pinning the manifest as editable so a future regex tightening does not quietly break Task 1's workflow:

```bash
@test "allows the fnox manifest, which holds op:// pointers not values" {
	assert_allowed "Edit" "$HOME/.config/fnox/config.toml"
	assert_allowed "Write" "$HOME/src/github.com/meaganewaller/dotfiles/home/dot_config/fnox/config.toml"
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bats test/block-sensitive-or-generated-writes.bats`
Expected: FAIL — `expected block but guard allowed: Write /Users/.../.secrets`

The new manifest test should already pass; only the `.secrets` assertions fail.

- [ ] **Step 3: Extend the regex**

In `home/dot_local/libexec/executable_block-sensitive-or-generated-writes`, add `|\.secrets` to the first alternation group of `sensitive_path_regex`.

Before:

```sh
sensitive_path_regex='(^|/)(\.env(\..*)?|\.npmrc|\.pypirc|\.netrc|\.git-credentials)$|...'
```

After — only the first group changes; leave every other branch byte-for-byte identical:

```sh
sensitive_path_regex='(^|/)(\.env(\..*)?|\.npmrc|\.pypirc|\.netrc|\.git-credentials|\.secrets)$|...'
```

The `$` anchor means this matches a file named `.secrets` only. A project directory named `.secrets/` is unaffected — deliberately, to keep the change minimal.

- [ ] **Step 4: Run the test to verify it passes**

Run: `bats test/block-sensitive-or-generated-writes.bats`
Expected: PASS, all tests including the pre-existing ones.

- [ ] **Step 5: Commit**

Invoke `/git-workflow:commit`.

---

### Task 4: Apply, migrate, and verify end to end

**Files:**
- No source changes. This task applies and verifies Tasks 1–3 on the live machine and retires the hand-made file.

**Interfaces:**
- Consumes: everything from Tasks 1–3.
- Produces: a live `~/.secrets` at `0600` and a live `~/.config/fnox/config.toml`.

**Precondition:** 1Password must be unlocked. Check with `op account list` — if it errors, unlock the desktop app before starting. Commit signing also depends on that session, so a locked vault breaks the commit step too.

- [ ] **Step 1: Record the pre-migration state**

```bash
stat -f "%Sp %N" ~/.secrets
grep -c . ~/.secrets
```

Expected: `-rw-r--r--` and `1`. This is the state being fixed: a world-readable file with one hand-written key.

- [ ] **Step 2: Preview the chezmoi changes**

```bash
chezmoi diff --no-pager --recursive ~/.config/fnox ~/.config/mise ~/.local/libexec
```

Expected: the new `fnox/config.toml`, the `[tasks.secrets]` addition to the mise config, and the regex change in the guard.

Note: `chezmoi diff <directory>` does not recurse without `--recursive`, and its pager hides output when there is no TTY. Both flags are required here.

- [ ] **Step 3: Apply**

```bash
chezmoi apply
chezmoi status
```

Expected: `chezmoi status` prints nothing (no drift).

- [ ] **Step 4: Confirm the task is visible from an unrelated directory**

```bash
cd /tmp && mise tasks | grep secrets
```

Expected: a `secrets` row with its description. This is the check that the task is genuinely global rather than repo-local.

- [ ] **Step 5: Regenerate the file**

```bash
cd /tmp && mise run secrets
```

Expected: exit 0, no output beyond mise's own task echo.

- [ ] **Step 6: Verify permissions, content, and cleanliness**

```bash
stat -f "%Sp %N" ~/.secrets
sed -E 's/=.*/=<redacted>/' ~/.secrets
bash -n ~/.secrets && echo "sources cleanly"
ls -a "$HOME" | grep -c '^\.secrets\.' || true
```

Expected, in order: `-rw-------`; a header plus `export LINEAR_API_KEY=<redacted>`; `sources cleanly`; and `0` leftover temp files. **Do not print the unredacted file.**

- [ ] **Step 7: Confirm the key survived the migration unchanged**

```bash
a="$(grep -oE "^export LINEAR_API_KEY='.*'$" ~/.secrets | sed -E "s/^export LINEAR_API_KEY='(.*)'$/\1/")"
b="$(op read "op://Automation/Linear Onlooker API Key/credential")"
[ -n "$a" ] && [ "$a" = "$b" ] && echo "MATCH" || echo "MISMATCH"
```

Expected: `MATCH`. Compares the generated file against 1Password without printing either value.

- [ ] **Step 8: Confirm the project-leak guard actually holds**

```bash
mkdir -p /tmp/leakcheck && printf '[providers]\np = { type = "plain" }\n[secrets]\nLEAKED = { provider = "p", value = "nope" }\n' > /tmp/leakcheck/fnox.toml
cd /tmp/leakcheck && mise run secrets
grep -c LEAKED ~/.secrets || true
rm -rf /tmp/leakcheck
```

Expected: `0`. Without `--config` this would be `1` — this step is what proves the guard, so do not skip it.

- [ ] **Step 9: Confirm shells still get the vars natively**

```bash
cd /tmp && mise env | grep -c LINEAR_API_KEY
```

Expected: `1`. Confirms the `_.fnox-env` plugin picked up the new manifest, which is what covers the interactive-shell consumer without sourcing the file.

- [ ] **Step 10: Close the beads issue**

```bash
bd close dotfiles-4zt --reason="fnox manifest, global mise secrets task, and blocklist entry shipped; ~/.secrets regenerated at 0600 and verified against 1Password"
bd export -o .beads/issues.jsonl
```

- [ ] **Step 11: Commit**

Invoke `/git-workflow:commit` for the beads export.

---

## Out of Scope

Do not do these as part of this plan:

- **Touching the `op read` credential aliases.** `home/.chezmoidata/aliases.yaml`'s `credentials:` list, the `[data.credentials]` prompts in `.chezmoi.toml.tmpl`, and the rendered zshrc aliases stay exactly as they are. Their per-invocation fetch never puts the secret in the environment, which is a stronger property than this plan's. Tracked as `dotfiles-vv3`.
- **Adding more keys to the manifest.** `LINEAR_API_KEY` is the only entry in the current `~/.secrets`, so it is the only one being migrated.
- **Setting up `fnox mcp`.** A different design with a different blast radius.
- **Adding an age provider or any encrypted-in-git secret.**
- **Fixing the unrelated `python.uv_venv_auto` deprecation warning** that mise emits from the global config. Real, but not this change.
