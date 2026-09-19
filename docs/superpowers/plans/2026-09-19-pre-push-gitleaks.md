# Pre-push Gitleaks Fix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the pre-push secret scan scan the commits being pushed, and add tests that would catch it doing nothing again.

**Architecture:** Two of the three gitleaks steps in the chezmoi-managed HOME hk config change command. The tests do not hardcode those commands — they extract them from the config with `pkl eval -x` and run what is actually declared, so a test cannot pass while the config is broken. That property is the whole point: this bug survived because the command exited 0 while scanning nothing.

**Tech Stack:** hk 2.0.1 (Pkl config), gitleaks 8.30.1, chezmoi, BATS.

**Spec:** `docs/superpowers/specs/2026-09-19-pre-push-gitleaks-design.md`

## Global Constraints

- Work from the repository root: `/Users/meaganwaller/src/github.com/meaganewaller/dotfiles`, on branch `fix/pre-push-gitleaks` (already created; its first commit is the spec).
- Prefix `hk`, `bats`, `pkl`, `yq` and `gitleaks` invocations with `mise x --`. Run the suite with `mise exec -- ./bin/test`; a bare `./bin/test` fails 36 tests on `yq: command not found` because mise is not activated in a non-interactive shell.
- **Never edit `~/.config/hk/config.pkl` directly.** The chezmoi source is `home/dot_config/hk/config.pkl`; changes reach `~` only via `chezmoi apply`.
- This config deploys machine-wide and hk reads it in **every repository on this machine, client work included**. Treat mistakes here as affecting other people's repos.
- Test baseline is **268 passing / 0 failing**. Each task states its own expected count.
- Conventional commits: `<type>(<scope>): <subject> :emoji:`, American English, why-focused body, subject **≤72 characters including the emoji** — count it with `printf '%s' "<subject>" | wc -m`, because `hk util check-conventional-commit` exits 0 at 74 and will not catch it.
- Do NOT stage `.beads/issues.jsonl`; it is handled separately.
- The pre-commit hook is live and runs hk. If it rejects a commit, fix the cause; never `--no-verify`.

---

### Task 1: Make the pre-push scan actually scan

**Files:**
- Modify: `test/hk-config.bats` (append; currently 27 lines)
- Modify: `home/dot_config/hk/config.pkl:13` (the `pre-push` hook's `check`)

**Interfaces:**
- Produces: a `make_pushed_repo()` helper and a `scan_command()` helper in `test/hk-config.bats`, both used again by Task 2.

- [ ] **Step 1: Claim the issue**

```bash
bd update dotfiles-6c6 --claim
```

- [ ] **Step 2: Write the failing tests**

Append to `test/hk-config.bats`. Note `--template=` on both `git init` calls: it keeps this machine's own seeded hooks out of the throwaway repos, matching `make_repo()` in `test/beads-policy.bats`. `$TEST_TMPDIR` is created by `setup()` and removed by `teardown()` in `test/test_helper.bash`.

```bash
# The exact command the config declares for <hook>'s gitleaks step, so these
# tests exercise what is configured rather than a copy of it. A copy could
# pass while the config stayed broken -- which is how the pre-push scan ran
# for months without scanning anything.
# Captured by the caller, so it runs in a subshell and `fail` here would not
# end the test. The caller must guard the result with a non-empty check.
scan_command() {
	pkl eval -x "hooks[\"$1\"].steps[\"gitleaks\"].check" "$(repo_root)/$CONFIG_FILE"
}

# A repository at <dir> with a bare origin and one pushed commit, so that
# "HEAD --not --remotes" has a remote to subtract. Created with no template so
# this machine's own hooks stay out of it.
#
# Takes the directory as an argument rather than printing it, matching
# make_repo() in test/beads-policy.bats. That is not just style: a helper whose
# output is captured runs in a subshell, where `fail`'s `exit 1` would end only
# the subshell and let the test carry on with an empty path -- silently
# under-asserting, which is the exact failure test_helper.bash warns about.
make_pushed_repo() {
	local work="$1" remote="$1.remote.git"
	git init -q --bare --template= "$remote" || fail "git init --bare failed"
	git init -q --template= "$work" || fail "git init failed"
	git -C "$work" config user.email "test@example.com"
	git -C "$work" config user.name "Test"
	git -C "$work" remote add origin "$remote"
	printf 'clean\n' >"$work/a.txt"
	git -C "$work" add a.txt
	git -C "$work" commit -qm "clean commit" || fail "commit failed"
	git -C "$work" push -q origin HEAD:refs/heads/main || fail "push failed"
	git -C "$work" fetch -q origin || fail "fetch failed"
}

@test "the pre-push scan rejects an unpushed commit containing a secret" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v gitleaks >/dev/null 2>&1 || skip "gitleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-push)"
	[ -n "$cmd" ] || fail "could not read the pre-push command from $CONFIG_FILE"

	# A secret in a commit that has NOT been pushed. This is exactly what
	# pre-push exists to catch: a commit that never passed pre-commit.
	printf 'awsToken = AKIA%s\n' 'LALEMEL33243OLIA' >"$work/leak.txt"
	git -C "$work" add leak.txt
	git -C "$work" commit -qm "unpushed secret" || fail "commit failed"

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -ne 0 ] || fail "the pre-push scan passed on an unpushed secret; command was: $cmd
output: $output"
}

@test "the pre-push scan passes when nothing is unpushed" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v gitleaks >/dev/null 2>&1 || skip "gitleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-push)"
	[ -n "$cmd" ] || fail "could not read the pre-push command from $CONFIG_FILE"

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -eq 0 ] || fail "the pre-push scan failed with nothing to push; command was: $cmd
output: $output"
}
```

Both cases are required. The first alone would pass against a scan that fails on everything; the second alone is satisfied by the current broken command. Together they show the scan can tell the two states apart.

**Do not join the token back into one literal.** Gitleaks' own test key is a valid AWS key shape, so a literal one in this file is flagged by this repository's `check` hook and blocks the commit — which is exactly what happened the first time this plan was written. `printf` reassembles it at runtime, so the file the test writes contains a real detectable key (verified: `leaks found: 1`) while this document does not.

- [ ] **Step 3: Run them and watch the first one fail**

```bash
mise exec -- bats test/hk-config.bats
```

Expected: the "rejects an unpushed commit" test **FAILS**, and "passes when nothing is unpushed" passes. The failure message will show `command was: gitleaks protect --staged`.

That failure **is** the bug: `protect --staged` finds nothing staged at push time, exits 0, and the assertion that it should have exited non-zero fires. If this test passes before you change the config, stop — the test is not exercising what you think it is.

- [ ] **Step 4: Fix the pre-push command**

In `home/dot_config/hk/config.pkl`, change only the `pre-push` hook's `check`:

```diff
   ["pre-push"] {
     steps {
       ["gitleaks"] {
-        check = "gitleaks protect --staged"
+        check = "gitleaks git --no-banner --redact --verbose --log-opts=\"HEAD --not --remotes\""
       }
     }
   }
```

`HEAD --not --remotes` is the commits no remote has — what is about to leave the machine. It needs no fallback for a branch that has never been pushed, where `@{push}` would fail to resolve. `--redact` keeps a detected secret out of terminal output.

- [ ] **Step 5: Run them again and watch both pass**

```bash
mise exec -- bats test/hk-config.bats
```

Expected: 3 passing, 0 failing (the pre-existing schema test plus these two).

- [ ] **Step 6: Run the full suite**

```bash
mise exec -- ./bin/test 2>&1 | grep -cE '^ok '
```

Expected: **270** (268 baseline plus the two new tests).

- [ ] **Step 7: Commit**

Stage `test/hk-config.bats` and `home/dot_config/hk/config.pkl`. Suggested subject (63 characters — verify with `printf '%s' "<subject>" | wc -m`):

```text
fix(hk): make the pre-push secret scan scan something :lock:
```

The body should say that `protect --staged` finds nothing staged at push time so the scan exited 0 while reading an empty set, and that the tests run the command extracted from the config rather than a copy, so they cannot pass while the config is broken.

---

### Task 2: Move pre-commit off the deprecated command

**Files:**
- Modify: `test/hk-config.bats` (append one test)
- Modify: `home/dot_config/hk/config.pkl:6` (the `pre-commit` hook's `check`)

**Interfaces:**
- Consumes: `make_pushed_repo()` and `scan_command()` from Task 1.

`gitleaks protect` is the deprecated spelling; `gitleaks git` replaced it, and hk's own v2 builtin emits `gitleaks git --pre-commit --redact --staged --verbose --no-banner`. This step works today, so this is not a bug fix — it is removing the deprecated command that made the broken pre-push line look plausible, and adding `--redact`.

- [ ] **Step 1: Write the test**

Append to `test/hk-config.bats`:

```bash
@test "the pre-commit scan rejects a staged secret" {
	command -v pkl >/dev/null 2>&1 || skip "pkl not installed"
	command -v gitleaks >/dev/null 2>&1 || skip "gitleaks not installed"

	local work="$TEST_TMPDIR/work" cmd
	make_pushed_repo "$work"
	cmd="$(scan_command pre-commit)"
	[ -n "$cmd" ] || fail "could not read the pre-commit command from $CONFIG_FILE"

	# Staged but not committed -- what pre-commit sees.
	printf 'awsToken = AKIA%s\n' 'LALEMEL33243OLIA' >"$work/leak.txt"
	git -C "$work" add leak.txt

	cd "$work" || fail "cd failed"
	run eval "$cmd"
	[ "$status" -ne 0 ] || fail "the pre-commit scan passed on a staged secret; command was: $cmd
output: $output"
}
```

Only the "fires" case is needed here, unlike pre-push. The inverse — that it stays quiet on clean content — is exercised constantly: this hook runs on every commit in this repository, so a scan that failed on everything would block all work immediately. Pre-push had no such natural coverage, which is why it needed both.

- [ ] **Step 2: Run it against the current command**

```bash
mise exec -- bats test/hk-config.bats
```

Expected: **PASSES** against the existing `gitleaks protect --staged`, because that command works correctly for pre-commit. This test is a regression guard for the change you are about to make, not a demonstration of a bug.

- [ ] **Step 3: Update the pre-commit command**

```diff
   ["pre-commit"] {
     steps {
       ["gitleaks"] {
-        check = "gitleaks protect --staged"
+        check = "gitleaks git --pre-commit --redact --staged --verbose --no-banner"
       }
     }
   }
```

- [ ] **Step 4: Run it again**

```bash
mise exec -- bats test/hk-config.bats
```

Expected: 4 passing, 0 failing. The test passing both before and after is the point — it shows the new command has the same behavior on the case that matters.

- [ ] **Step 5: Run the full suite**

```bash
mise exec -- ./bin/test 2>&1 | grep -cE '^ok '
```

Expected: **271**.

- [ ] **Step 6: Commit**

Stage `test/hk-config.bats` and `home/dot_config/hk/config.pkl`. Suggested subject (60 characters):

```text
chore(hk): drop the deprecated gitleaks protect :broom:
```

---

### Task 3: Deploy and verify the live hooks

**Files:** none modified.

**Interfaces:**
- Consumes: the committed config from Tasks 1 and 2.

Until `chezmoi apply` runs, the tests prove the *committed source* is correct while the machine still runs the old commands.

- [ ] **Step 1: Preview the change**

```bash
chezmoi diff "$HOME/.config/hk/config.pkl"
```

Expected: exactly two changed lines, the `pre-commit` and `pre-push` `check` values. Anything else means an unrelated edit crept in — stop and investigate.

- [ ] **Step 2: Apply**

```bash
chezmoi apply "$HOME/.config/hk/config.pkl"
diff home/dot_config/hk/config.pkl ~/.config/hk/config.pkl && echo "DEPLOYED"
```

Expected: `DEPLOYED`.

- [ ] **Step 3: Confirm gitleaks still resolves in all three hooks**

```bash
for hook in pre-commit pre-push check; do
  printf '  %-11s ' "$hook"
  mise x -- hk run "$hook" --all -P -J 2>/dev/null \
    | python3 -c "import json,sys;print('gitleaks present' if 'gitleaks' in [s['name'] for s in json.load(sys.stdin)['steps']] else 'MISSING')"
done
```

Expected: `gitleaks present` three times. A `MISSING` means the config stopped being merged in and secret scanning has silently stopped — stop and report.

- [ ] **Step 4: Prove the live pre-push hook blocks a real push**

This is the acceptance criterion from `dotfiles-6c6`, run end to end rather than through the extracted command.

**A plain `mktemp -d` repo does not work — do not use one.** It was tried first and returned `push exit: 0` with no gitleaks output at all, on a correctly deployed config. The seeded pre-push hook (`home/.chezmoitemplates/git-hooks/beads-shim`) only chains into `hk` when the repo's toplevel is under a `beads.personal_dirs` prefix — `$HOME/src/github.com/meaganewaller` or `$HOME/src/github.com/onlooker-community` (`docs/beads.md`). `mktemp -d` lands under `/var/folders/.../T` (or `/tmp`), which matches neither prefix, so the shim's `_hk_mine` guard stays empty and `mise x -- hk run pre-push --from-hook` is never invoked — confirmed with `sh -x` on the hook itself. The push then succeeds trivially, regardless of whether the config is correct.

Putting the repo under a `personal_dirs` prefix clears that gate but exposes three more requirements this script needs that the BATS tests (which deliberately stay outside those prefixes to keep hk out) never had to satisfy:

1. **A valid `hk.pkl`, not just an empty touched file.** The shim's `[ -f hk.pkl ]` check only cares that the file exists, but once `_hk_mine` is set, `hk` loads and merges that file as real Pkl — it must actually parse. The minimal working content is the one-line `amends` this repo's own `hk.pkl` uses.
2. **`pkl` declared in the throwaway repo's own `mise.toml`.** `hk` shells out to the `pkl` CLI to read its config, and `mise x --` only resolves tools some `mise.toml` in the directory hierarchy declares. With none present, `hk` panics with `Failed to load configuration: failed to analyze pkl ... install pkl cli to use pkl config files` before it ever reaches gitleaks — this is a second, unrelated failure mode, not a scan result.
3. **`gitleaks` declared too**, for the same reason. Omit it and the push still fails, but with `mise ERROR No version is set for shim: gitleaks`, not a gitleaks finding — this failure mode is real, fails closed rather than open, and is pre-existing (not a regression from this fix); it is tracked separately in beads rather than fixed here.

```bash
export PATH="$HOME/.local/share/mise/shims:$PATH"   # a non-interactive shell lacks this; without it gitleaks resolves as "command not found" inside the hook, which can look like a pass

T="$HOME/src/github.com/meaganewaller/tmp-prepush-verify"   # must sit under a personal_dirs prefix -- see above
rm -rf "$T"
mkdir -p "$T"
git init -q --bare --template= "$T/remote.git"
git init -q "$T/work"                 # NOTE: no --template=, so the real hooks are seeded
cd "$T/work"
git config user.email test@example.com && git config user.name Test

cat >hk.pkl <<'EOF'
amends "package://github.com/jdx/hk/releases/download/v2.0.1/hk@2.0.1#/Config.pkl"
EOF

cat >mise.toml <<'EOF'
[tools]
pkl = "0.32.1"
"aqua:gitleaks/gitleaks" = "v8.30.1"
EOF

git remote add origin "$T/remote.git"
printf 'clean\n' >a.txt && git add a.txt hk.pkl mise.toml && git commit -qm clean

# Scaffolding push. --no-verify here is not simulating anything -- it works
# around a chicken-and-egg problem: hk's pre-push run needs the remote's
# tracking refs to know what "HEAD --not --remotes" is relative to, and
# nothing exists on the remote yet for it to resolve against.
git push -q --no-verify origin HEAD:refs/heads/main
git fetch -q origin
git remote set-head origin -a

# Real push #1: clean commit, hooks enabled. Confirms hk/gitleaks actually
# ran -- not just that the scaffolding above worked.
printf 'more clean\n' >b.txt && git add b.txt && git commit -qm "more clean"
git push origin HEAD:refs/heads/main; echo "clean push exit: $?"

# Real push #2: the acceptance case. --no-verify on this commit is
# deliberate -- it simulates the exact scenario pre-push exists to catch,
# a commit that never passed pre-commit.
printf 'awsToken = AKIA%s\n' 'LALEMEL33243OLIA' >leak.txt
git add leak.txt && git commit -qm "planted secret" --no-verify
git push origin HEAD:refs/heads/main; echo "secret push exit: $?"

cd - >/dev/null && rm -rf "$T"
```

Expected: `clean push exit: 0` (gitleaks ran and reported "no leaks found"), then `secret push exit: 1` with a gitleaks finding (`RuleID: aws-access-token`, `File: leak.txt`, `Line: 1`; `Finding`/`Secret` shown as `REDACTED`).

If the push succeeds when it shouldn't, or fails with an `mise`/`pkl` error instead of a gitleaks finding, work back through the three requirements above before concluding the config itself is broken. Verified end to end on 2026-09-19: both push results matched exactly, and the throwaway repo was deleted afterward.

- [ ] **Step 5: Run the final gates**

```bash
mise x -- hk check --pr
mise exec -- ./bin/test 2>&1 | grep -cE '^ok '
```

Expected: `hk check --pr` green; **271** tests passing.

- [ ] **Step 6: Close the issue and commit the export**

```bash
bd close dotfiles-6c6 --reason="pre-push now runs gitleaks git with --log-opts='HEAD --not --remotes', scanning the commits no remote has. Verified end to end: a push carrying a planted secret in a commit made with --no-verify is rejected by the live hook. Tests extract the command from the config rather than copying it, so they cannot pass while the config is broken."
bd export -o .beads/issues.jsonl
git add .beads/issues.jsonl
```

Commit the export on its own, subject (54 characters):

```text
chore(beads): close the pre-push scan bug :clipboard:
```

- [ ] **Step 7: Open the PR**

Use the `/git-workflow:pr` skill and fill `.github/PULL_REQUEST_TEMPLATE.md` honestly. Tick Scope → *Chezmoi source* and *Repo tooling*; Verification → `hk check` clean, `./bin/test` green, `chezmoi diff` previewed. In the body, include the end-to-end push rejection from Step 4 — that is the evidence a reviewer cannot get from reading the diff.

---

## Rollback

The HOME config reaches every repository on this machine, so if the live hooks misbehave:

```bash
git checkout -- home/dot_config/hk/config.pkl
chezmoi apply "$HOME/.config/hk/config.pkl"
```

If hooks block work while you debug, `HK=0 git commit ...` and `HK=0 git push ...` skip hk without skipping beads.
