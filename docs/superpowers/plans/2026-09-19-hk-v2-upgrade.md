# hk v2 Upgrade Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move hk from 1.58.1 to 2.0.1, bring both hk configs onto the v2.0.1 schema, and put the home config under Renovate so it stops drifting.

**Architecture:** Two PRs. The first upgrades `mise.lock` from format 0 to format 2 and changes nothing else — this is a prerequisite, because `mise lock --bump hk` is a no-op on a format 0 lockfile. The second bumps the binary, reshapes `hk.pkl` around v2's top-level `steps` map, bumps the home config's `amends`, and extends Renovate's custom manager. Correctness is demonstrated by diffing hk's machine-readable execution plan before and after, not by eyeballing config.

**Tech Stack:** hk 2.0.1 (Pkl config), mise 2026.9.11, chezmoi, BATS, Renovate.

**Spec:** `docs/superpowers/specs/2026-09-19-hk-v2-upgrade-design.md`

## Global Constraints

- Every command runs from the repository root: `/Users/meaganwaller/src/github.com/meaganewaller/dotfiles`.
- Prefix every `hk`, `bats`, and `yq` invocation with `mise x --`. A bare `./bin/test` fails 36 tests with `yq: command not found` because mise is not activated in a non-interactive shell.
- `mise.lock` and `renovate.json5` are pinned, Renovate-sensitive manifests. Per `AGENTS.md` those edits route through the **Package Manager subagent**, not ad hoc.
- Never edit files under `~` directly. Chezmoi source lives in `home/`; changes reach `~` only via `chezmoi apply`.
- All commits go through the `/git-workflow:commit` skill. All PRs go through `/git-workflow:pr` and must fill `.github/PULL_REQUEST_TEMPLATE.md` honestly — tick only Scope items actually touched and Verification items actually run.
- American English in all commits, docs, and comments.
- Test baseline is **267 passing, 0 failing** (as of #320). Any drop is a regression.
- `hk check --all` has two **pre-existing** failures unrelated to this work: a missing trailing newline in `home/private_dot_copilot/private_plugins.json.tmpl`, and SC2016 in `home/dot_local/libexec/dotfiles/theme.d/executable_starship`. Use `hk check --pr` to scope to changed files. Do not fix these here.
- Escape hatch if hooks break mid-work: `HK=0 git commit ...`. The beads shim honors it.

---

## Phase 1 — PR 1: lockfile format upgrade (`dotfiles-low`)

### Task 1: Capture the pre-upgrade baseline

**Files:**
- Create: `/tmp/hk-baseline/check.json`, `/tmp/hk-baseline/pre-commit.json`, `/tmp/hk-baseline/lockfacts.txt`

**Interfaces:**
- Produces: the three baseline files above. Tasks 2, 6, and 9 diff against them.

- [ ] **Step 1: Claim the issue**

```bash
bd update dotfiles-low --claim
```

- [ ] **Step 2: Capture hk's execution plans under hk 1.58.1**

These are the reference for "nothing changed". `-P` prints the plan instead of running it; `-J` makes it JSON.

```bash
mkdir -p /tmp/hk-baseline
mise x -- hk check --all -P -J 2>/dev/null > /tmp/hk-baseline/check.json
mise x -- hk run pre-commit --all -P -J 2>/dev/null > /tmp/hk-baseline/pre-commit.json
```

- [ ] **Step 3: Confirm the baselines are real JSON and non-empty**

```bash
python3 -c "import json;d=json.load(open('/tmp/hk-baseline/check.json'));print(d['hook'], len(d['steps']), 'steps')"
python3 -c "import json;d=json.load(open('/tmp/hk-baseline/pre-commit.json'));print(d['hook'], len(d['steps']), 'steps')"
```

Expected: `check 14 steps` and `pre-commit 16 steps` or similar non-zero counts. If either prints 0 steps or throws, stop — the baseline is worthless and every later comparison is meaningless.

- [ ] **Step 4: Record the lockfile facts**

```bash
{
  echo "lines: $(wc -l < mise.lock)"
  echo "signers: $(grep -c 'signer = ' mise.lock)"
  echo "hk_version: $(grep -A2 '^\[tools\.hk\]' mise.lock | head -5)"
  grep -c '^\[tools\.' mise.lock | sed 's/^/tool_entries: /'
} > /tmp/hk-baseline/lockfacts.txt
cat /tmp/hk-baseline/lockfacts.txt
```

Expected: `signers: 6`, `lines: 453`.

- [ ] **Step 5: Record the test baseline**

```bash
mise exec -- ./bin/test 2>&1 | grep -cE '^ok '
```

Expected: `267`.

---

### Task 2: Upgrade the lockfile format

**Files:**
- Modify: `mise.lock`

**Interfaces:**
- Consumes: `/tmp/hk-baseline/*` from Task 1.
- Produces: `mise.lock` at `lockfile_version = 2` with hk still at 1.58.1.

> **Route this task through the Package Manager subagent** — `mise.lock` is a pinned manifest.

- [ ] **Step 1: Confirm mise is new enough**

```bash
command mise --version
```

Expected: `2026.9.11` or newer. On 2026.8.5 this step **silently strips all six sigstore `signer` lines** (that was `dotfiles-127`). If the version is older, stop and upgrade with `brew upgrade mise` first.

- [ ] **Step 2: Confirm mise.toml is untouched**

```bash
grep '^hk' mise.toml
```

Expected: `hk = "1.58.1"`. If it already says 2.0.1, you are in the wrong phase — this PR must not move the binary.

- [ ] **Step 3: Run the format upgrade**

```bash
GITHUB_TOKEN="$(gh auth token)" mise lock --upgrade
```

Expected output includes `Upgraded ... to lockfile version 2` and `Updated 75 platform entries (9 skipped)`.

- [ ] **Step 4: Verify the invariants**

```bash
echo "lockfile_version: $(grep -m1 lockfile_version mise.lock)"
echo "signers: $(grep -c 'signer = ' mise.lock)"
awk '/^\[\[tools\.hk\]\]/,/^$/' mise.lock
```

Expected, exactly:
- `lockfile_version = 2`
- `signers: 6` — if this is 0, mise was too old; `git checkout -- mise.lock` and go back to Step 1.
- The hk block reads `version = "1.58.1"` and `backend = "aqua:jdx/hk"`. **hk must not have moved in this PR.**

- [ ] **Step 5: Account for the 9 skipped entries**

```bash
python3 - <<'PY'
import re, collections
per = collections.defaultdict(set)
for line in open('mise.lock'):
    m = re.match(r'^\[tools\.(.+?)\.(?:"platforms\.(.+?)"|platforms\.(.+?))\]$', line)
    if m:
        per[m.group(1).strip('"')].add(m.group(2) or m.group(3))
allp = {"linux-arm64","linux-arm64-musl","linux-x64","linux-x64-musl","macos-arm64","macos-x64","windows-x64"}
for t in sorted(per):
    missing = allp - per[t]
    if missing: print(t, 'missing:', ', '.join(sorted(missing)))
PY
```

Expected: `aqua:bats-core/bats-core missing: windows-x64` and `hk missing: macos-x64`. Those two plus `npm:markdownlint-cli` (7 platforms, npm artifacts are not per-platform) account for all 9. Put this in the PR body.

- [ ] **Step 6: Verify hk still behaves identically**

```bash
mise x -- hk check --all -P -J 2>/dev/null > /tmp/hk-after-fmt.json
diff <(python3 -m json.tool /tmp/hk-baseline/check.json) <(python3 -m json.tool /tmp/hk-after-fmt.json) && echo "IDENTICAL PLAN"
```

Expected: `IDENTICAL PLAN`. The lockfile format has no business changing hk's behavior; if the plan moved, something else did too.

- [ ] **Step 7: Run the test suite**

```bash
mise exec -- ./bin/test 2>&1 | grep -cE '^ok '
```

Expected: `267`.

- [ ] **Step 8: Commit**

Use the `/git-workflow:commit` skill. Stage only `mise.lock`. Suggested subject:

```text
chore(mise): upgrade the lockfile to format 2 :lock:
```

Body must say **why**: format 0 blocks `mise lock --bump`, which blocks the hk v2 upgrade; and that all six sigstore signer lines survived.

---

### Task 3: Land PR 1

**Files:** none

- [ ] **Step 1: Open the PR**

Use the `/git-workflow:pr` skill. In the template, tick Scope → *Pinned manifests / Renovate*, and Verification → `./bin/test` green. Note in the body that the plan diff was identical and that the 9 skipped entries are accounted for.

- [ ] **Step 2: Wait for CI**

```bash
gh pr checks --watch
```

Expected: `lint` and `test-cached` both green. This is the point of PR 1 — it proves `jdx/mise-action@v4.3.0` accepts `lockfile_version = 2`.

- [ ] **Step 3: After merge, sync and close**

```bash
git switch main && git pull --ff-only
bd close dotfiles-low --reason="mise lock --upgrade to format 2; hk held at 1.58.1; all six signer lines intact; CI green on mise install --locked."
bd export -o .beads/issues.jsonl
```

- [ ] **Step 4: Confirm q8j is now unblocked**

```bash
bd ready | grep q8j
```

Expected: `dotfiles-q8j` appears. If it does not, the dependency did not clear — check `bd show dotfiles-q8j`.

---

## Phase 2 — PR 2: hk v2 (`dotfiles-q8j`)

### Task 4: Move the binary to 2.0.1

**Files:**
- Modify: `mise.toml:9`
- Modify: `mise.lock`

**Interfaces:**
- Consumes: `mise.lock` at format 2 from Phase 1.
- Produces: hk 2.0.1 on the `packslip:github.com/jdx/hk` backend, available to every later task.

> **Route the `mise.lock` edit through the Package Manager subagent.**

- [ ] **Step 1: Claim the issue and branch**

```bash
bd update dotfiles-q8j --claim
git switch -c chore/hk-v2
```

- [ ] **Step 2: Bump the pin**

Change line 9 of `mise.toml`:

```diff
-hk = "1.58.1"
+hk = "2.0.1"
```

- [ ] **Step 3: Re-resolve the lockfile entry**

```bash
GITHUB_TOKEN="$(gh auth token)" mise lock --bump hk
```

- [ ] **Step 4: Verify the backend switched**

```bash
awk '/^\[\[tools\.hk\]\]/,/^$/' mise.lock
echo "signers: $(grep -c 'signer = ' mise.lock)"
```

Expected: `version = "2.0.1"`, `backend = "packslip:github.com/jdx/hk"`, and `signers: 6` still.

- [ ] **Step 5: Confirm the binary actually runs**

```bash
mise x -- hk --version
```

Expected: `hk 2.0.1`.

- [ ] **Step 6: Confirm the existing config still evaluates under 2.0.1**

`hk.pkl` already amends the v2.0.1 `Config.pkl` (since #282), so 2.0.1 should read it as-is even before the reshape. Verify rather than assume, because the next step commits.

```bash
mise x -- hk check --pr && echo "SAFE TO COMMIT"
```

If this fails with a Pkl schema error, **do not commit**. The binary and the config must then move together: skip to Task 6, make both changes, and commit them as one. Record that deviation in the report file.

- [ ] **Step 7: Commit**

Commit via the `/git-workflow:commit` skill (or, as a subagent without it, mirror its contract: `<type>(<scope>): <subject> :emoji:`, American English, why-focused body). Stage only `mise.toml` and `mise.lock`. Suggested subject:

```text
chore(hk): move the binary to 2.0.1 :arrow_up:
```

The pre-commit hook runs under the new binary, so a green commit is itself evidence that 2.0.1 reads the current config.

---

### Task 5: Establish v2's real behavior before relying on it

**Files:**
- Create: `/tmp/hk-v2-facts.md`

**Interfaces:**
- Produces: recorded answers to three questions that Tasks 6 and 7 depend on.

This task writes no config. It exists because two documented claims disagree and one is undocumented, and Task 6 should not be built on a guess.

- [ ] **Step 1: Resolve the `fix` default contradiction**

`Config.pkl` line 231 says `fix` defaults to `false` (`true` for the `fix` hook). The migration guide says pre-commit "fixes and stages by default." Both cannot be right.

```bash
mise x -- hk run pre-commit --all -P -J 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);print('runType:', d['runType'])"
```

Expected: `fix` if pre-commit fixes by default, `check` if it does not. Record the answer in `/tmp/hk-v2-facts.md`.

- [ ] **Step 2: Determine how the home config merges with the repo config**

This is undocumented. Both `~/.config/hk/config.pkl` and `hk.pkl` declare a `pre-commit` hook.

```bash
mise x -- hk run pre-commit --all -P -J 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
names=[s['name'] for s in d['steps']]
print('steps:', names)
print('gitleaks present:', 'gitleaks' in names)
print('bd-pre-commit present:', 'bd-pre-commit' in names)
"
```

Expected: **both** `gitleaks` (home config) and `bd-pre-commit` (repo config) appear. If `gitleaks` is missing, the home config is being shadowed rather than merged — record that, and raise it before continuing, because it changes Task 7.

- [ ] **Step 3: Check whether the v1.36.0 home config still evaluates under hk 2.0.1**

If Steps 1-2 ran without a Pkl error, it does. If they failed with a schema error naming `~/.config/hk/config.pkl`, then the home config must be migrated *before* anything else works — do Task 7 first, then return here.

- [ ] **Step 4: Write the findings down**

Replace each `<...>` with what the previous steps actually printed.

```bash
cat > /tmp/hk-v2-facts.md <<EOF
# hk 2.0.1 observed behavior

- pre-commit runType: <fix|check>            # Step 1
- home + repo hooks merge: <yes|no>          # Step 2, gitleaks AND bd-pre-commit both present
- v1.36.0 home config evaluates under 2.0.1: <yes|no>   # Step 3
EOF
cat /tmp/hk-v2-facts.md
```

If "pre-commit runType" is `check`, v2 does **not** fix by default and the explicit `fix = true` in Task 6 is what preserves current behavior — do not drop it. If "home + repo hooks merge" is `no`, stop and raise it: Task 7 assumes merging, and shadowing would mean gitleaks silently stops running in this repository.

---

### Task 6: Reshape `hk.pkl` around top-level `steps`

**Files:**
- Modify: `hk.pkl` (whole file)

**Interfaces:**
- Consumes: `/tmp/hk-v2-facts.md` from Task 5, `/tmp/hk-baseline/*` from Task 1.
- Produces: an `hk.pkl` whose execution plan matches the Task 1 baseline step-for-step.

- [ ] **Step 1: Replace the file**

The change is mechanical: `local linters = new Mapping<String, Step|Group> { ... }` becomes the top-level `steps { ... }` with identical contents, the explicit `check` and `fix` hooks are deleted (v2 generates them), and `pre-commit` keeps only what it adds. Every comment about exclusions is preserved verbatim — they record why each exclusion exists.

```pkl
amends "package://github.com/jdx/hk/releases/download/v2.0.1/hk@2.0.1#/Config.pkl"
import "package://github.com/jdx/hk/releases/download/v2.0.1/hk@2.0.1#/Builtins.pkl"

// Shared by the implicit `check`, `fix`, and `pre-commit` hooks that v2 creates
// from this map. The bd steps are deliberately NOT here: `check` and `fix` run
// in CI (hk check) on machines that don't have the `bd` CLI installed -- it is
// not a project mise tool. They are contributed per-hook below instead.
steps {
  // Essential
  ["check-merge-conflict"] = Builtins.check_merge_conflict
  ["check-executables-have-shebangs"] = Builtins.check_executables_have_shebangs
  ["check-symlinks"] = Builtins.check_symlinks
  ["detect-private-key"] = (Builtins.detect_private_key) {
    exclude = "docs/reference/**"
  }
  // Whitespace fixers skip test/fixtures/** for the same reason jq does below:
  // those files are upstream artifacts and have to stay byte-identical. The
  // end-of-file fixer appended a newline to a Sigstore bundle that upstream
  // publishes without one.
  ["mixed-line-ending"] = (Builtins.mixed_line_ending) {
    exclude = "test/fixtures/**"
  }
  ["trailing-whitespace"] = (Builtins.trailing_whitespace) {
    exclude = "test/fixtures/**"
  }
  ["newlines"] = (Builtins.newlines) {
    exclude = "test/fixtures/**"
  }
  // VS Code and Cursor read their User config as JSONC -- comments and trailing
  // commas are valid there and jq cannot parse them, so it would either fail or
  // strip the comments. Excluded by editor directory, not by current contents:
  // settings.json is comment-free today only by accident.
  // test/fixtures/** is upstream material -- signed release artifacts and the
  // like -- and must stay byte-identical to what upstream published. jq's fix
  // step reformatted a Sigstore bundle here; cosign still accepted it, but a
  // fixture whose bytes are what's under test would break with no obvious
  // cause.
  ["jq"] = (Builtins.jq) {
    exclude = List(
      "**/private_Code/User/*.json",
      "**/private_Cursor/User/*.json",
      "test/fixtures/**"
    )
  }
  ["markdown-lint"] = (Builtins.markdown_lint) {
    exclude = "docs/reference/**"
  }
  ["mise"] = Builtins.mise

  // Shell — exclude chezmoi templates. Two patterns, because chezmoi has two
  // kinds: target templates carry a .tmpl suffix, while named templates under
  // .chezmoitemplates/ carry none (chezmoi keys those by bare filename). Both
  // are Go text/template and neither parses as shell -- a {{ range }} inside a
  // for loop is a syntax error to shellcheck, not a lint finding.
  ["shellcheck"] = (Builtins.shellcheck) {
    exclude = List("**/*.tmpl", "**/.chezmoitemplates/**")
  }
  ["shfmt"] = (Builtins.shfmt) {
    exclude = List("**/*.tmpl", "**/.chezmoitemplates/**")
  }

  // GitHub Actions
  ["ghalint-workflow"] = Builtins.ghalint_workflow

  // Lua
  ["stylua"] = Builtins.stylua
}

hooks {
  ["pre-commit"] {
    // v2 defaults `stash` to "none" on every hook, so this must stay explicit
    // or unstaged changes stop being stashed before fix steps run.
    fix = true
    stash = "git"
    steps {
      ["bd-pre-commit"] {
        check = "bd hooks run pre-commit"
      }
    }
  }
  // v2 creates no implicit pre-push hook, so this stays explicit.
  ["pre-push"] {
    steps {
      ["bd-pre-push"] {
        check = "bd hooks run pre-push \"$@\""
      }
    }
  }
  ["commit-msg"] {
    steps {
      ["check-conventional-commit"] = Builtins.check_conventional_commit
    }
  }
  ["post-merge"] {
    steps {
      ["bd-post-merge"] {
        check = "bd hooks run post-merge"
      }
    }
  }
}
```

- [ ] **Step 2: Confirm it evaluates at all**

```bash
mise x -- hk check --all -P >/dev/null && echo "CONFIG EVALUATES"
```

Expected: `CONFIG EVALUATES`. A Pkl error here names the offending property — fix it before going on.

- [ ] **Step 3: Diff the check plan against the baseline**

This is the load-bearing verification of the whole PR.

```bash
mise x -- hk check --all -P -J 2>/dev/null > /tmp/hk-after-v2-check.json
python3 - <<'PY'
import json
def steps(p):
    d=json.load(open(p))
    return {s['name']: (s['status'], s.get('fileCount')) for s in d['steps']}
a=steps('/tmp/hk-baseline/check.json'); b=steps('/tmp/hk-after-v2-check.json')
print('only before:', sorted(set(a)-set(b)))
print('only after :', sorted(set(b)-set(a)))
for k in sorted(set(a)&set(b)):
    if a[k]!=b[k]: print('CHANGED', k, a[k], '->', b[k])
print('OK' if a==b else 'DIFFERENCES ABOVE')
PY
```

Expected: `OK`, with both "only" lists empty. Any step that appears, disappears, or changes its file count is a regression — the exclusions or the steps map did not carry over.

- [ ] **Step 4: Diff the pre-commit plan the same way**

```bash
mise x -- hk run pre-commit --all -P -J 2>/dev/null > /tmp/hk-after-v2-pc.json
python3 - <<'PY'
import json
def steps(p):
    d=json.load(open(p))
    return {s['name']: (s['status'], s.get('fileCount')) for s in d['steps']}
a=steps('/tmp/hk-baseline/pre-commit.json'); b=steps('/tmp/hk-after-v2-pc.json')
print('only before:', sorted(set(a)-set(b)))
print('only after :', sorted(set(b)-set(a)))
print('OK' if a==b else 'DIFFERENCES ABOVE')
PY
```

Expected: `OK`. In particular `bd-pre-commit` and `gitleaks` must both still be present.

- [ ] **Step 5: Confirm bd steps did NOT leak into check or fix**

This is the property the deleted `local linters` workaround existed to guarantee. CI has no `bd` binary, so a leak turns every CI lint run red.

```bash
for hook in check fix; do
  echo -n "$hook: "
  mise x -- hk run "$hook" --all -P -J 2>/dev/null \
    | python3 -c "import json,sys;n=[s['name'] for s in json.load(sys.stdin)['steps']];print('LEAK', [x for x in n if x.startswith('bd-')]) if any(x.startswith('bd-') for x in n) else print('clean')"
done
```

Expected: `check: clean` and `fix: clean`. Anything else must be fixed before committing.

- [ ] **Step 6: Confirm the chezmoi template exclusion survived**

```bash
mise x -- hk check --all -S shellcheck -S shfmt -g 'home/.chezmoitemplates/**' -P 2>&1 | grep -E 'no files matched|shellcheck|shfmt'
```

Expected: both steps report `(no files matched filters)`. If `beads-shim` matches, the `**/.chezmoitemplates/**` exclusion was lost and commits will start failing.

- [ ] **Step 7: Run the test suite**

```bash
mise exec -- ./bin/test 2>&1 | grep -cE '^ok '
```

Expected: `267`. `test/beads-policy.bats` asserts shims never `exec` hk and that hk is guarded on `hk.pkl`; those must still hold.

- [ ] **Step 8: Commit**

Commit via the `/git-workflow:commit` skill (or mirror its contract). Stage only `hk.pkl`. Suggested subject:

```text
refactor(hk): move the linters map to top-level steps :recycle:
```

The body should say why the `local linters` workaround is gone: v2 lets an explicit hook contribute a step while still inheriting the shared map, which is exactly what the workaround was emulating.

---

### Task 7: Migrate the home config

**Files:**
- Modify: `home/dot_config/hk/config.pkl:1`

**Interfaces:**
- Consumes: Task 5's finding on whether home and repo hooks merge.
- Produces: a v2.0.1-schema home config deployed to `~/.config/hk/config.pkl`.

This config reaches **every repository on this machine**, client work included. Treat it accordingly.

- [ ] **Step 1: Bump the amends line**

Only line 1 changes. The three hooks stay as they are: gitleaks runs a different command per hook, so a shared top-level `steps` map does not fit, and `Builtins.gitleaks` is not a drop-in — its `scan = "dir"` variant scans the working tree, while this config's `check` hook scans git history.

```diff
-amends "package://github.com/jdx/hk/releases/download/v1.36.0/hk@1.36.0#/Config.pkl"
+amends "package://github.com/jdx/hk/releases/download/v2.0.1/hk@2.0.1#/Config.pkl"
```

Leave `gitleaks protect --staged` in the `pre-push` hook exactly as it is. It is a known no-op tracked as `dotfiles-6c6` and is deliberately out of scope here.

- [ ] **Step 2: Confirm `check` as a plain string is still legal**

v2's `Config.Step.check` is typed `(String | Script | Command | CommandSpec)?`, so the raw command strings remain valid. Verify rather than trust:

```bash
mise x -- hk check --all -P >/dev/null && echo "HOME CONFIG EVALUATES"
```

Expected: `HOME CONFIG EVALUATES`.

- [ ] **Step 3: Preview the chezmoi change**

```bash
chezmoi diff "$HOME/.config/hk/config.pkl"
```

Expected: exactly one changed line, the `amends` URL. Anything else means an unrelated edit crept in.

- [ ] **Step 4: Check that an older hk still tolerates the v2 home config**

Another repository on this machine may pin an older hk and will read this file.

```bash
mise x -- hk --version
for d in ~/src/github.com/meaganewaller/marketplace ~/src/github.com/onlooker-community/onlooker; do
  [ -d "$d" ] && echo "=== $d ===" && (cd "$d" && mise x -- hk --version 2>/dev/null || echo "no hk pinned here")
done
```

If any repository pins hk 1.x, run `hk check -P` there **after** Step 5 and confirm it still evaluates. If it errors, stop and raise it — a broken home config breaks hooks everywhere, including client repositories.

- [ ] **Step 5: Apply**

```bash
chezmoi apply "$HOME/.config/hk/config.pkl"
diff home/dot_config/hk/config.pkl ~/.config/hk/config.pkl && echo "DEPLOYED"
```

Expected: `DEPLOYED`.

- [ ] **Step 6: Confirm gitleaks still runs in all three hooks**

```bash
for hook in pre-commit pre-push check; do
  echo -n "$hook: "
  mise x -- hk run "$hook" --all -P -J 2>/dev/null \
    | python3 -c "import json,sys;print('gitleaks present' if 'gitleaks' in [s['name'] for s in json.load(sys.stdin)['steps']] else 'MISSING')"
done
```

Expected: `gitleaks present` three times.

- [ ] **Step 7: Commit**

Commit via the `/git-workflow:commit` skill (or mirror its contract). Stage only `home/dot_config/hk/config.pkl`. Suggested subject:

```text
chore(hk): bring the home config onto the v2 schema :arrow_up:
```

The body should note that this config reaches every repository on the machine, and that the pre-push gitleaks no-op is knowingly left alone under `dotfiles-6c6`.

---

### Task 8: Put the home config under Renovate

**Files:**
- Modify: `renovate.json5:143-145`

**Interfaces:**
- Produces: a Renovate manager that bumps both hk configs.

> **Route this task through the Package Manager subagent** — Renovate config churn.

- [ ] **Step 1: Widen the file pattern**

The existing manager at `renovate.json5:133-153` already solves the hard part: the version appears twice per import (release tag and `hk@<version>.zip` asset), and capturing only the tag produced 404s like `.../download/v2.0.1/hk@1.45.0.zip`. That logic is reused unchanged; only the file list grows.

```diff
       managerFilePatterns: [
         '/^hk\\.pkl$/',
+        '/^home/dot_config/hk/config\\.pkl$/',
       ],
```

- [ ] **Step 2: Validate the config**

```bash
mise x -- npx --yes --package renovate -- renovate-config-validator renovate.json5
```

Expected: no errors. If `npx` is unavailable, `python3 -c "import json5"` is not a substitute — the validator checks Renovate semantics, not just syntax. Report that it could not be run rather than ticking it.

- [ ] **Step 3: Confirm the regex matches the home config**

```bash
python3 - <<'PY'
import re
rx = re.compile(r'github\.com/jdx/hk/releases/download/v(?P<currentValue>[^/]+)/hk@[^#"]+')
line = open('home/dot_config/hk/config.pkl').readline()
m = rx.search(line)
print('MATCH', m.group('currentValue')) if m else print('NO MATCH -- manager will not bump this file')
PY
```

Expected: `MATCH 2.0.1`.

- [ ] **Step 4: Commit**

Commit via the `/git-workflow:commit` skill (or mirror its contract). Stage only `renovate.json5`. Suggested subject:

```text
chore(renovate): manage the home hk config too :satellite:
```

The body should say why: the home config sat at v1.36.0 for three months precisely because no manager matched it.

---

### Task 9: Verify the whole change and land PR 2

**Files:** none

- [ ] **Step 1: Run the scoped lint**

```bash
mise x -- hk check --pr
```

Expected: every step green. Use `--pr`, not `--all` — `--all` has the two pre-existing failures listed in Global Constraints.

- [ ] **Step 2: Run the full test suite**

```bash
mise exec -- ./bin/test 2>&1 | tee /tmp/final-test.out | grep -cE '^ok '
grep -c '^not ok ' /tmp/final-test.out
```

Expected: `267` and `0`.

- [ ] **Step 3: Confirm the lockfile kept its signatures**

```bash
grep -c 'signer = ' mise.lock
```

Expected: `6`. If this is 0, an older mise rewrote the file somewhere along the way — restore with `git checkout -- mise.lock` and redo Task 4.

- [ ] **Step 4: Confirm nothing is left uncommitted**

Tasks 4, 6, 7, and 8 each committed their own change, and every one of those commits ran the live pre-commit hook under hk 2.0.1 — that is the integration evidence.

```bash
git status --porcelain
git log --oneline origin/main..HEAD
```

Expected: a clean tree, and four commits covering `mise.toml` + `mise.lock`, `hk.pkl`, `home/dot_config/hk/config.pkl`, and `renovate.json5`. If anything is still unstaged, an earlier task's commit step was skipped — commit it now with the subject that task specified.

- [ ] **Step 5: Commit the beads export separately**

```bash
bd close dotfiles-q8j --reason="hk 2.0.1 on the packslip backend; hk.pkl reshaped around top-level steps; home config bumped from v1.36.0 to v2.0.1; Renovate manager widened to cover it. Plan diffs identical for check and pre-commit; bd steps confirmed absent from check and fix."
bd export -o .beads/issues.jsonl
```

Then a second commit staging only `.beads/issues.jsonl`.

- [ ] **Step 6: Open the PR**

Use `/git-workflow:pr`. Tick Scope → *Chezmoi source*, *Pinned manifests / Renovate*, *Repo tooling*. Tick Verification → `hk check` clean (noting it was `--pr`-scoped and why), `./bin/test` green, `chezmoi diff` previewed. In the body, include the plan-diff result and the Task 5 findings on `fix` defaults and home/repo hook merging — those are the parts a reviewer cannot check by reading the diff.

- [ ] **Step 7: Watch CI**

```bash
gh pr checks --watch
```

Expected: `lint` and `test-cached` green. `lint` is the one that matters — it runs `hk check` with no `bd` installed, which is the real test of Step 5 in Task 6.

- [ ] **Step 8: After merge, sync and push beads**

```bash
git switch main && git pull --ff-only
git branch -d chore/hk-v2
bd dolt push
```

---

## Rollback

If PR 2 goes wrong after `chezmoi apply`, the home config is the dangerous part — it affects every repository on this machine.

```bash
git checkout -- home/dot_config/hk/config.pkl
chezmoi apply "$HOME/.config/hk/config.pkl"
```

If commits are blocked in this repository while you debug, `HK=0 git commit ...` skips hk without skipping beads.
