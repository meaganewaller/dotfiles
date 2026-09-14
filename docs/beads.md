# Beads: Which Repos, What to Commit

How Beads (`bd`) is used across repositories: which ones get a durable issue tracker, what of `.beads/` is committed, how to adopt beads in a repository, and how the git hooks stay wired. The reasoning lives in the [design spec](superpowers/specs/2026-09-04-beads-policy-design.md); this page is the operating manual.

The code blocks on this page were extracted and run against `bd` 1.2.2 (Homebrew) in throwaway repositories with a sandboxed `HOME` on 2026-09-11; any block, or part of one, that was not says so. Those runs were non-interactive, which bd detects when stdin is not a terminal; in a terminal, `bd init` may prompt first (for a role, for example).

## TL;DR

- Repositories under a `beads.personal_dirs` entry are **durable**: commit the lean `.beads/` set and push dolt data.
- Everywhere else is **local-only**: `bd init --stealth`, nothing committed, no push target.
- Hooks come from `init.templateDir`. `core.hooksPath` stays unset, except in [husky repos](#husky-repos).
- Durability is `bd dolt push`. The JSONL export is a readable record, not a backup.

---

## The two modes

`home/.chezmoidata/beads.yaml` → `beads.personal_dirs` lists the org directories whose repositories are mine. Read the list there, not from a copy: it is the source of truth, and `test/beads-policy.bats` fails if any entry equals, contains, or sits inside a client directory from `git.identities`. Compare paths case-insensitively, since a checkout on disk can differ in case from the org name.

| | Durable | Local-only |
| --- | --- | --- |
| Applies to | Repositories under a `personal_dirs` entry | Everything else: client organizations, open-source clones |
| Initialize with | `bd init --skip-hooks` | `bd init --stealth` |
| Committed | The lean `.beads/` set ([below](#what-is-committed)) | Nothing; `.beads/` sits in `.git/info/exclude` |
| `sync.remote` and Dolt remote | Derived from `origin` | Neither, so `bd dolt push` has no target |
| `export.auto` | `true` | Off (the default) |
| Survives a reclone | Yes | No; treat it as a scratchpad |

---

## Durable mode: adopting beads

From the repository root:

```bash
# Keep the derived paths out of the commit bd init makes on its own.
printf '%s\n' \
  '# Derived from the database and conflict-prone; see docs/beads.md.' \
  '.beads/interactions.jsonl' \
  '# Generated per-project; hooks come from init.templateDir instead.' \
  '.beads/hooks/' >>.gitignore
git init .                      # seed the five hooks from init.templateDir first
bd init --skip-hooks            # creates .beads/ and commits it; see below
bd config get sync.remote       # expect git+ssh://git@github.com/<org>/<repo>.git
bd dolt remote list             # expect origin at the same URL
bd config set export.auto true
chmod 700 .beads                # bd 1.2.2 already creates it 0700; older inits made it 0755
git rev-parse --git-path hooks  # expect .git/hooks, or .husky/_ in a husky repo
bd hooks list                   # expect five "installed (shim 1.2.2)"
```

Commit `.beads/config.yaml`, which now carries `export.auto`, and `.beads/issues.jsonl` once the first issue exists. Then push the Dolt data, which is the step that makes the tracker durable:

```bash
bd dolt push
git ls-remote origin 'refs/dolt/*'   # expect refs/dolt/data
```

What the checklist works around:

- **`bd init` commits.** It makes its own commit, `bd init: initialize beads issue tracking`, holding `.beads/`'s lean files, the root `.gitignore`, and its agent integration: an `AGENTS.md` section, `CLAUDE.md`, `.claude/settings.json`, `.agents/skills/beads/`, and `.codex/`. `--skip-agents` leaves the agent files out. The ignore lines have to be in place before `bd init`, or that commit includes `.beads/interactions.jsonl`.
- **bd's agent block and markdownlint.** bd re-renders its block in `AGENTS.md` and `CLAUDE.md`, from `<!-- BEGIN BEADS INTEGRATION … -->` to `<!-- END BEADS INTEGRATION -->`, by the hash in the BEGIN marker. Its rendering drops the blank lines around fences and lists, which markdownlint reports as MD031 and MD032. In a repository that runs markdownlint, fix nothing inside the markers, since bd undoes it. Wrap the block from outside instead: `<!-- markdownlint-disable <rules> -->` on its own line immediately before BEGIN, and `<!-- markdownlint-enable <rules> -->` immediately after END, naming only the rules markdownlint actually reports. That bd keeps the wrappers across a re-render is an assumption, not confirmed; if it drops the disable line, lint fails loudly rather than passing silently. `marketplace`'s `CLAUDE.md` is the worked example.
- **Hooks first, then `--skip-hooks`.** In a clone that has no hooks yet, plain `bd init` writes its own shims to `.beads/hooks/` and sets `core.hooksPath` to point there. Git then ignores `.git/hooks/`, and `bd hooks list` still reports all five installed. `git rev-parse --git-path hooks` is the check that shows which directory git actually runs.
- **Husky repositories need one more step.** Installing a husky v9 repository's dependencies sets `core.hooksPath` to `.husky/_`, so `git rev-parse --git-path hooks` prints that instead, and git never runs the seeded hooks. Leave it set, and chain beads from husky as [Husky repos](#husky-repos) describes.
- **`sync.remote` comes from `origin`.** `bd init` sets `sync.remote`, and a Dolt remote named `origin`, from the repository's git `origin`. An scp-style origin (`git@github.com:<org>/<repo>.git`) becomes `git+ssh://…`; an https origin becomes `git+https://…`.
- **The export is throttled.** With `export.auto` on, bd rewrites `.beads/issues.jsonl` after write commands at most once per 60 seconds, and the pre-commit hook refreshes it as well. A burst of writes can leave the file briefly behind the database.

For the ssh form when `origin` is https, set both. `bd config set sync.remote` does not touch the Dolt remote:

```bash
bd config set sync.remote "git+ssh://git@github.com/<org>/<repo>.git"
bd dolt remote remove origin
bd dolt remote add origin "git+ssh://git@github.com/<org>/<repo>.git"
```

Not exercised in the throwaway checks: `bd dolt push` and the `ls-remote` check, since those checks never push; and `bd init`'s own commit in a repository that has `hk.pkl` or commit signing turned on.

---

## Local-only mode

For any repository that is not mine:

```bash
git init .                                      # seed the hooks; a no-op if they are already there
bd init --stealth
bd config set no-git-ops true                   # keep --stealth's setting, scoped to this repository
chezmoi apply --force ~/.config/bd/config.yaml  # and remove the machine-wide copy --stealth wrote
git status --porcelain                          # expect no output
if bd config get --json sync.remote | jq -e '.value == ""' >/dev/null &&
  [ "$(bd dolt remote list --json | jq length)" = 0 ]; then
  echo "correct: no push target"
else
  echo "FIX: bd config unset sync.remote; bd dolt remote remove origin"
fi
```

- **`--stealth` keeps the tree clean.** It writes `.beads/`, `.claude/settings.local.json`, and bd's Dolt patterns to `.git/info/exclude`, which is per clone and never committed. It edits no tracked file, writes no agent files, makes no commit, leaves existing hooks alone, and never sets `core.hooksPath`. In the throwaway check the tree stayed clean through `bd create`, a commit through the seeded hooks, and a branch checkout; the commit held only the tracked change, and bd added no trailers to its message.
- **No push target.** `--stealth` sets neither `sync.remote` nor a Dolt remote, and leaves `export.auto` off.
- **Its global side effect.** `--stealth` also appends `no-git-ops: true` to `~/.config/bd/config.yaml`. That file is chezmoi-managed (`home/dot_config/bd/private_config.yaml`), and the setting reaches every repository: bd describes it as "no git commands in session close protocol", and `bd prime` everywhere, durable repositories included, switches to "Git workflow: stealth mode (no git ops)". Despite `bd init --help`'s mention of global gitattributes and gitignore, it leaves `~/.config/git/attributes`, `~/.config/git/ignore`, and the global git config untouched. Setting `no-git-ops` inside the repository writes it to `.beads/config.yaml`, which is already excluded, even while the global copy is still in place; `chezmoi apply --force ~/.config/bd/config.yaml` then puts the global file back. The `--force` matters: bd changed a chezmoi-managed file, so without it chezmoi stops to ask before overwriting, and with no TTY it fails with `could not open a new TTY`. It is safe because it restores only that one target's committed source; keep the target on the command line, since without one `--force` applies every pending change on the machine, scripts included. (The throwaway check restored the file by copying the chezmoi source over it; the `--force` revert itself was verified against the real global file with no TTY: it removed `no-git-ops`, `chezmoi diff` came back empty, and the file was byte-identical to its original, mode 0600.)
- **Why the check tests two things.** `bd config get sync.remote` exits 0 whether or not the key is set; unset, it prints `sync.remote (not set in config.yaml)`. And `bd dolt push` pushes to the Dolt remote, not to `sync.remote`, so `bd config unset sync.remote` alone leaves a Dolt `origin` behind. The check reads both through `--json` and fails closed: if either bd call errors or prints nothing, it reports FIX, in zsh as well as bash.
- **The mistake this prevents.** Plain `bd init` in someone else's repository sets `sync.remote` and a Dolt `origin` from that repository's own origin, writes agent files, and commits all of it. If that happens, the FIX commands remove the push target; bd's commit still has to be dropped before anything is pushed.

---

## What is committed

In a durable repository, commit:

| Path | Why |
| --- | --- |
| `.beads/issues.jsonl` | Readable, diffable record of issue state. Not a backup (bd says so explicitly), but the artifact that makes reconstruction possible when the database is gone. |
| `.beads/config.yaml` | Shared project configuration — carries `sync.remote` and `export.auto`. |
| `.beads/metadata.json` | Issue prefix and project identity. |
| `.beads/.gitignore` | bd-managed; required for correct ignore behavior. |
| `.beads/README.md` | Static, generated once. |

And ignore:

| Path | Why |
| --- | --- |
| `.beads/interactions.jsonl` | Append-only audit log, derived from the database, conflicts on every concurrent branch. In `marketplace` it is 9 lines describing issues that no longer exist — the less valuable half of the record. |
| `.beads/hooks/` | Generated per project and per toolchain. `marketplace` has 14 because beads mirrored that repository's husky hooks; `dotfiles` has 6. |

The two ignore lines go in the repository-root `.gitignore`, not in `.beads/.gitignore`, which bd manages and warns against editing. bd's own `.beads/.gitignore` already covers the rest of `.beads/`: the Dolt database, locks, and export state. An ignore rule does not untrack a file git already tracks; that takes `git rm --cached`.

The durable checklist above ends with exactly these five paths tracked.

---

## Retrofit

`init.templateDir` only seeds repositories created after it was set. For an older clone, re-running `git init` in place is the retrofit: git copies the template hooks that are missing and never overwrites a hook that exists.

```bash
git init .
git rev-parse --git-path hooks   # expect .git/hooks, or .husky/_ in a husky repo
bd hooks list                    # expect five "installed (shim 1.2.2)"
```

`bd hooks list` works in a repository without beads, too.

The template also seeds repositories that tools create for their own use. Dolt's git-remote-cache is one: a bare repository under `.beads/embeddeddolt/<db>/.dolt/git-remote-cache/…/repo.git/`, which Dolt creates with git itself on the first `bd dolt push` to a git remote. `marketplace`'s, created by its first push after `init.templateDir` was set, holds all five shims in `hooks/`; a cache created before the template was set has none. These paths are ignored and untracked. Whether the seeded hooks fire during `bd dolt push`, and what they do there, is unverified; two real pushes in `marketplace` completed normally with them present.

The no-clobber rule cuts both ways: `git init .` will not replace a stale shim either. After a [shim resync](#shim-resync), or in a clone that already has older hooks, delete the hooks this policy owns, then reseed:

```bash
for h in pre-commit post-merge pre-push post-checkout prepare-commit-msg; do
  grep -qE 'BEADS INTEGRATION|hk run' ".git/hooks/$h" 2>/dev/null && rm -f ".git/hooks/$h"
done
git init .
```

The loop deletes a hook only if it carries a beads block or runs hk: an older shim, bd's own hook, or one `hk install` wrote, which is fine to replace because the shim runs hk itself when `hk.pkl` is present. A hook from any other tool in those slots, such as the pre-commit framework, lefthook, or husky v4, stays as it is, and beads does not run for that slot. The loop runs in zsh and bash.

If `git rev-parse --git-path hooks` prints anything other than `.git/hooks`, `core.hooksPath` is set and git ignores `.git/hooks/` entirely. When it points at `.beads/hooks`, which plain `bd init` does in a hookless clone, remove it:

```bash
git config --unset core.hooksPath
```

Unset it only for `.beads/hooks`. When it is `.husky/_`, husky set it: leave it, and chain beads from husky as [Husky repos](#husky-repos) describes.

---

## Husky repos

Husky v9 takes `core.hooksPath` for itself. Its `prepare` script, `husky`, sets it to `.husky/_` on every dependency install, so git ignores `.git/hooks/` and the template shims never run. Husky runs only the hooks that have a `.husky/<name>` script, and runs each one with `sh -e`.

So each of the five bd hooks, `pre-commit`, `pre-push`, `post-merge`, `post-checkout`, and `prepare-commit-msg`, gets a `.husky/<hook>` script that ends by handing off to the shim. `marketplace` is the worked example. Its `.husky/pre-push` is exactly these two lines, and its other four end with the same two, each with its own hook name in the path:

```sh
shim="${XDG_CONFIG_HOME:-$HOME/.config}/git/template/hooks/pre-push"
if [ -x "$shim" ]; then "$shim" "$@"; fi
```

- **Why the `if` form.** As a script's last line, `[ -x "$shim" ] && "$shim" "$@"` exits 1 whenever the shim is absent, and husky hands that status to git, so every commit and push would fail in CI and in any other clone without the shim. The `if` form exits 0 there, and passes the shim's own status through when it runs.
- **Appending to an existing script.** Make sure it ends with a newline first, or the first appended line joins its last line; `marketplace`'s `pre-commit` did not end with one.
- **Only the bd slots.** Leave husky's other hooks alone, such as a `commit-msg` that runs commitlint.
- **The shim stays the one copy.** `.husky/` holds no beads logic of its own, so a [shim resync](#shim-resync) reaches the repository with no edit there.

This block was not part of the 2026-09-11 runs; it was verified on 2026-09-14 in a throwaway clone of `marketplace`. To check a husky repository the same way:

1. Clone it into a scratch bare repository, then clone that, so the throwaway's `origin` has no path back to the real remote.
2. Install dependencies in the throwaway, never in the real repository just to test, and confirm `git rev-parse --git-path hooks` prints `.husky/_`.
3. Put a stub `bd` first on `PATH` that logs its arguments and exits 3, as bd does when there is no database.
4. Commit, switch branches, merge, and push to the scratch remote. The log should show all five hooks calling `bd hooks run <hook>` with their arguments.
5. Point `HOME` and `XDG_CONFIG_HOME` at an empty directory and repeat, with the project's tools on `PATH` directly and a git identity in the environment, since mise's shims need the real `HOME` and git reads its identity from there. Every hook should exit 0, and the log should stay empty.

**Never run `bd init` in a throwaway of a durable repository.** There, `bd init` takes its Dolt remote from the committed `.beads/config.yaml` `sync.remote`, not from the clone's `origin`, so `bd dolt push`, or the pre-push hook, in that throwaway can write `refs/dolt/data` to the real remote. Test the hooks as above instead: no beads database, which bd answers with exit 3, and a stub `bd`.

---

## Shim resync

The five hooks render from one template, `home/.chezmoitemplates/git-hooks/beads-shim`. Its beads block mirrors what `bd hooks install` writes, between markers pinned at **`v1.2.2`**.

bd stamps its own CLI version into those markers, so the label moves with every bd release even when the block's logic does not; from 1.1.0 to 1.2.2 only the indentation changed. bd is installed with Homebrew here, not mise, so upgrades, and the label churn that comes with them, arrive unpinned. `bd hooks list` prints each hook's label, as `(shim 1.2.2)`, but does not flag one that lags bd.

After a bd upgrade, compare the logic, not the label. From the dotfiles repository root:

```bash
norm() {
  sed -n '/BEGIN BEADS INTEGRATION/,/END BEADS INTEGRATION/p' |
    sed -E -e 's/v[0-9]+(\.[0-9]+)+/vX/' -e 's/^[[:space:]]+//' \
      -e 's/pre-commit|\{\{ \.hook \}\}/HOOK/g' \
      -e 's/"(\$_bd_[a-z_]+)"/\1/g' -e '/^# /d' -e '/database not initialized/d'
}
if tmp=$(mktemp -d) && [ -d "$tmp" ]; then
  git -C "$tmp" init -q
  rm -f "$tmp"/.git/hooks/*
  (cd "$tmp" && bd hooks install >/dev/null)
  grep -m1 -o 'BEADS INTEGRATION v[0-9.]*' "$tmp/.git/hooks/pre-commit"
  grep -m1 -o 'BEADS INTEGRATION v[0-9.]*' home/.chezmoitemplates/git-hooks/beads-shim
  diff <(norm <"$tmp/.git/hooks/pre-commit") <(norm <home/.chezmoitemplates/git-hooks/beads-shim) &&
    echo "no logic change"
  rm -rf "$tmp"
fi
```

The `if` guard stops the block when `mktemp` fails, so `bd hooks install` can never land in the current repository's hooks. The `rm -f` drops the shims `init.templateDir` seeded, so bd writes fresh files. The two `grep` lines print bd's current label and the pinned one; when they differ, it is time to resync. `norm` reduces each block to its logic: it normalizes the hook name, the version, and leading whitespace, and drops the shim's three deliberate divergences listed below (comments, the added quoting, and bd's exit-3 message).

- **`no logic change`:** the change is label-only. Bump the pin: both markers in `beads-shim`, the expected version in the "shims carry the pinned beads integration markers" test in `test/beads-policy.bats`, and this page's pin mentions, which are the two `bd hooks list` expectations (in the durable checklist and the retrofit), the pinned version at the top of this section, and the `(shim …)` example after it.
- **Any `diff` output:** bd changed the logic. Re-mirror its block into `beads-shim`, keep the three divergences, then bump the pin the same way.

Then run `./bin/test` and `chezmoi apply ~/.config/git/template`, and reseed each existing clone with the [retrofit](#retrofit) loop, since `git init .` never replaces a hook that exists.

### How the shim differs from bd's own hooks

Every difference between an installed bd hook and this shim is one of the following. Inside the markers there are three, and `norm` drops all of them:

1. **Header comment.** bd writes "This section is managed by beads"; the shim points here instead, because bd does not manage this copy.
2. **Quoting.** `$_bd_exit` and `$_bd_used_perl` are quoted, because `test/beads-policy.bats` runs shellcheck over every rendered hook. Behavior is unchanged.
3. **Silent exit 3.** When a repository has no beads database, bd's block prints `beads: database not initialized — skipping hook '<hook>'` to stderr. The shim stays silent: installed machine-wide, it would otherwise print that on every commit in every repository without beads.

Outside the markers, the shim **chains** hk instead of exec'ing it: `mise x -- hk run <hook> --from-hook "$@" || exit $?`, guarded on `hk.pkl` being present and `HK` not being `0`. When `bd hooks install` finds hk's hook already in place, it keeps hk's line, `test "${HK:-1}" = "0" || exec mise x -- hk run <hook> --from-hook "$@"`, above its own block. `exec` replaces the shell, so the beads block below it never runs. The `pre-commit` and `pre-push` hooks bd installed in this repository have exactly that shape.

---

## Why

`marketplace` lost 9 issues. Its committed interactions log records changes to 9 distinct issue IDs, the earliest from 2026-08-08, but it has no database on disk, no `refs/dolt/data` on its remote, and no JSONL export. Those issues are unrecoverable. Three things failed at once:

- **The hooks never ran.** bd wrote its shims into `.beads/hooks/`, as `bd hooks install --beads` does, and git reads that directory only when `core.hooksPath` points at it. It never did in either repository, and `bd hooks list` reported all five hooks "not installed". The same shims chained hk, so hk was not running on commit or push either.
- **`export.auto` was never set,** so no `.beads/issues.jsonl` was ever written. `dotfiles` had it set, committed the export by hand, and survived.
- **Nobody pushed dolt data by hand.** `sync.remote` was configured correctly in both repositories; nothing acted on it. `dotfiles` has `refs/dolt/data` on its remote because someone ran `bd dolt push` there.

The JSONL export is **not a backup**, and bd says so. `bd config --help` calls it "Useful for viewers (bv), interchange, and issue-level migration; not a backup. It is not cross-machine sync; use bd dolt push/pull with a Dolt remote." Durability is `bd dolt push`. The policy keeps both for different reasons: the push for durability, and the committed export for a diffable, human-readable record that survives in git even when the Dolt remote is unreachable.

That is also why hooks come from a git template directory instead of a per-repository install step: the step was forgotten once already, and a template makes every new clone correct by default. The full reasoning, including why `personal_dirs` is a separate list from `git.identities`, is in the [design spec](superpowers/specs/2026-09-04-beads-policy-design.md).
