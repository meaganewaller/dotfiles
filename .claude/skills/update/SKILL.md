---
name: update
description: "Dotfiles repo only — morning maintenance: merge open Renovate PRs, sync main, rebase local branches, preview and apply chezmoi."
argument-hint: "[--push | --dry-run]"
model: sonnet
context: default
allowed-tools:
  - Read
  - Edit
  - Bash(gh pr list:*)
  - Bash(gh pr view:*)
  - Bash(gh pr checks:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr merge:*)
  - Bash(git fetch:*)
  - Bash(git status:*)
  - Bash(git stash:*)
  - Bash(git add:*)
  - Bash(git checkout:*)
  - Bash(git branch:*)
  - Bash(git symbolic-ref:*)
  - Bash(git rev-parse:*)
  - Bash(git rebase:*)
  - Bash(git merge:*)
  - Bash(git pull:*)
  - Bash(git push:*)
  - Bash(git log:*)
  - Bash(chezmoi diff:*)
  - Bash(chezmoi apply:*)
  - Bash(chezmoi status:*)
---

# Update: Morning maintenance (dotfiles)

Use **only in this repository** (`meaganewaller/dotfiles`): merge Renovate dependency PRs, fast‑forward local `main` from `origin`, rebase other local branches onto updated `main`, then preview and run **chezmoi** so the machine matches the source tree.

For PRs that touch **pinned packages, images, digests, mise, externals, or GitHub Actions** in ways that are not obvious version bumps, follow **AGENTS.md** / **CLAUDE.md**: get Package Manager review before merging when in doubt.

## Arguments

```
$ARGUMENTS
```

| Flag | Meaning |
| --- | --- |
| *(none)* | Merge eligible PRs, sync/rebase, `chezmoi apply`; do **not** push unless you are already clear to push (see step 7). |
| `--push` | After rebases, `git push` the **current branch** to `origin` (and use upstream tracking if already set). |
| `--dry-run` | Inspect only: `git status`, list/filter PRs, show checks and short `gh pr diff` summaries; **no** merge, **no** rebase, **no** `chezmoi apply`, **no** push, **no** stash pop that changes history. |

## Repo facts (do not assume elsewhere)

- **Default branch:** `main` (`origin/main`).
- **Renovate:** Config in `renovate.json5`; PRs are labeled **`deps`** (and usually **`automated`**). Prefer listing with `-l deps` rather than a single global Renovate author string (GitHub login varies, labels are stable here).
- **Automerge:** `mise` manager has **`automerge: false`** — those PRs still merge manually when CI is green and the diff is a straightforward pin; if the diff is large or touches security‑sensitive manifests, **stop and ask** or route to Package Manager per **AGENTS.md**.
- **CI:** Primary signal is `.github/workflows/ci.yml`. Treat **`claude-code-review`** / **`claude`** workflows as **non‑blocking** for routine Renovate bumps (e.g. self‑review on its own bump PR is OK).

## Instructions

### 0. Preconditions

```bash
git rev-parse --is-inside-work-tree
git rev-parse --abbrev-ref HEAD
```

- **Detached `HEAD`:** Stop with a clear error; do not rebase or merge.
- **Dirty tree:** Note `git status --short`; if you will rebase/merge, **stash** (including untracked if needed):  
  `git stash push -u -m "update skill: before maintenance"`  
  Remember **which branch** you started on for step 6.

### 1. List Renovate‑style PRs

```bash
gh pr list --state open -l deps --json number,title,author,statusCheckRollup,headRefName
```

If `--dry-run`, print table of candidates and **stop before any mutating step** after you have shown checks summaries (see step 3).

### 2. Evaluate each PR

For each `number`:

```bash
gh pr checks <number>
```

Optionally skim:

```bash
gh pr diff <number> --stat
```

- **Merge** if: required **`ci`** (or equivalent) checks are green; optional claude workflows may be red/yellow per repo policy above.
- **Skip** if: CI failed on tests/lint, or diff needs human/package review (see **AGENTS.md**).
- **`--dry-run`:** Only describe what you *would* merge.

### 3. Merge passing PRs (unless `--dry-run`)

For each approved PR:

```bash
gh pr merge <number> --squash --delete-branch
```

Collect **number + title** (and one‑line package note from title/diff stat) for the final summary.

### 4. Sync local `main`

```bash
git fetch origin
git checkout main
git pull --rebase origin main
```

If `main` is not the default remote branch name, discover with  
`git symbolic-ref refs/remotes/origin/HEAD` and use that ref instead of `main`.

### 5. Rebase other local branches (if you started elsewhere)

If the saved **original branch** was not `main`:

```bash
git checkout <original-branch>
git rebase origin/main
```

**Conflicts**

1. `Read` conflicted paths; understand “incoming” (upstream) vs local.
2. **Pins / versions:** prefer the **newer pin** when both sides only bump versions; keep **both** additions when they are independent lines in manifests.
3. **Structural / policy uncertainty:** prefer asking the user or documenting a skip over guessing security‑sensitive merges.
4. Resolve, then `git add <paths>` and `git rebase --continue`. If unrecoverable: `git rebase --abort`, restore stash if any, report.

### 6. Stash pop

If you stashed in step 0:

```bash
git stash pop
```

Resolve conflicts the same way; if pop is too messy, stop and tell the user to finish manually.

### 7. Push (only with `--push`)

```bash
git push origin "$(git rev-parse --abbrev-ref HEAD)"
```

If no upstream yet and push is refused, tell the user to set upstream once; do not force‑push unless the user explicitly asks outside this skill.

### 8. Chezmoi

From the repo root (or with explicit `CHEZMOI_*` if this machine uses a non‑default config):

```bash
chezmoi diff
```

Summarize **high‑level** changes (paths / categories), not an unbounded full diff.

If not `--dry-run`:

```bash
chezmoi apply
chezmoi status
```

If `mise` hooks install tools and a download fails, report and continue cleanup/summary; do not pretend apply fully succeeded.

### 9. Summary table

| Area | Details |
| --- | --- |
| PRs merged | e.g. `#121`, `#122` + short titles |
| Skipped / held | PRs with failing CI or needing Package Manager |
| Git | `main` sync, rebases, stash pop outcome |
| Chezmoi | Applied? Drift remaining per `chezmoi status`? |
| Push | Done / skipped (`--push` / not) |

## Examples

```
/update                 # merge green deps PRs, sync main, rebase, chezmoi apply
/update --push          # same, then push current branch
/update --dry-run       # inspection and plan only
```

## Edge cases

| Case | Behavior |
| --- | --- |
| No open `deps` PRs | Skip merges; still fetch/rebase/chezmoi as appropriate. |
| All PRs failing CI | Merge none; report and optionally still sync `main`/chezmoi locally. |
| Detached `HEAD` | Abort immediately. |
| Catastrophic rebase conflicts | `git rebase --abort` after one careful pass; report. |
| Chezmoi template warnings | Often benign after data changes; distinguish from real errors. |
| Not the dotfiles working tree | Do not run destructive steps; tell the user this skill is scoped to this repo. |

## Philosophy (this repo)

Single maintainer, reversible Git history, Renovate does most dependency churn. Prefer **automation and sensible merges** over endless manual review for routine pins—**except** where **AGENTS.md** explicitly requires Package Manager input for version/image/security surfaces.
