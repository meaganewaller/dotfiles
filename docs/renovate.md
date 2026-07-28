# Renovate: How This Repo Manages Versions

This guide explains how Renovate is configured in this repository, how the custom version manifests work, and when/how to add or update pinned versions. It also includes handy `gh`/`gh api` commands to look up latest tags and resolve commit SHAs.

## TL;DR

- Renovate config lives at `renovate.json5` and runs weekly (before 9am Monday), opening labeled PRs (`deps`, `automated`) with low concurrency.
- We pin everything important to immutable versions or digests for reproducibility and supply‑chain safety.
- Standard managers are enabled (pip, mise, docker-compose, actions) and custom regex managers were added for Chezmoi externals and select version files.
- Renovate updates these pins automatically and groups safe updates for fast review/automerge.

---

## Configuration Overview

File: `renovate.json5`

- Extends: `config:recommended`, `:semanticCommits`, `:disableDependencyDashboard`
- Schedule: `before 9am on monday`
- Labels: `deps`, `automated`
- PR limits: `prHourlyLimit: 2`, `prConcurrentLimit: 5`

Enabled managers and file discovery:

- `mise` (native manager): `mise.toml` at the repo root, together with its committed `mise.lock`
- `home/dot_config/mise/config.toml.tmpl`: custom regex managers only — this file is a Chezmoi template, so its Go directives make it invalid TOML and the native `mise` manager cannot parse it. Its sibling `home/dot_config/mise/mise.lock` cannot substitute, because Renovate reads a `mise.lock` only as a companion to a config file it already parsed.
- `docker-compose`: `home/dot_config/docker-compose/*.yml`
- `github-actions`: `.github/workflows/*.yml` (with digest pinning)

Grouping and automerge rules:

- `github-actions`: group by manager, automerge minor/patch/digest
- `docker-compose`: group by manager, automerge digest updates
- `mise`: not grouped; picks up the top-level `automerge: true` / `automergeStrategy: squash` like everything else. A `matchManagers: ['mise']` packageRule applies `extractVersion: '^v?(?<version>.+)$'` so tags such as `v1.2.3` land as `1.2.3`.

Why: high-signal, low-risk updates (actions/digests) are auto‑merged to keep things current; others require review.

---

## Custom Version Manifests

These files purposely centralize versions so Renovate can update them automatically:

- `home/dot_config/dotfiles/cli-versions.toml`
  - Holds pinned CLI versions used by the installer and scripts.
  - Currently: `cosign` (used for signature verification). Renovate updates via GitHub Releases.

- `mise.toml` (repo dev tools) and `home/dot_config/mise/config.toml.tmpl` (user global tools)
  - Define tool versions managed by [mise], across several backends:
    - Native mise tools (e.g., `python = "3.14"`, `node = "24"`)
    - Aqua‑sourced tools (`"aqua:owner/repo" = "vX.Y.Z"`)
    - Github‑sourced tools (`"github:owner/repo" = "vX.Y.Z"`)
    - ubi‑sourced tools (`"ubi:owner/repo" = "X.Y.Z"`)
    - npm packages (`"npm:@scope/package" = "X.Y.Z"`)
    - Python/pipx tools (`"pipx:package" = "X.Y.Z"`)
  - Per [ADR 0003](adrs/0003-mise-config-plus-lockfile.md), these configs hold *intent* and may use `latest` or a coarse major; the exact resolved version lives in the committed `mise.lock` beside each config. Renovate therefore only bumps entries that already carry an explicit version — `latest` entries are refreshed by running `mise install` / `mise lock`, not by a Renovate PR.

- `mise.lock` and `home/dot_config/mise/mise.lock`
  - Machine truth: resolved version, checksum, and download URL per platform.
  - Renovate reads a lockfile only as a companion to a mise config it could parse, so the root `mise.lock` participates but `home/dot_config/mise/mise.lock` does not (its config is a `.tmpl`). Refresh that one with `mise lock` — see the ADR for the `mise lock --global` caveat on managed workstations.

- `home/dot_config/docker-compose/*.yml`
  - Service images pinned with tag+digest (e.g., `image: repo:tag@sha256:...`). Digest updates are auto‑merged.

- `home/.chezmoiexternal.toml.tmpl`
  - All externals pinned to commit SHAs for reproducibility.
  - Tarball archives pinned in the URL with commit SHA; git repo pinned via `revision = "<sha>"`.

---

## Custom Managers (Regex + Datasources)

Using Renovate’s `customManagers` to teach it how to parse and update versions in nonstandard files.

Defined in `renovate.json5`:

1) CLI versions (GitHub Releases)

- File: `home/dot_config/dotfiles/cli-versions.toml`
- Pattern: `^cosign\s*=\s*"(?<currentValue>v?[^\"]+)"`
- Datasource: `github-releases`, `depNameTemplate: sigstore/cosign`

2–6) Backend‑prefixed tools in the user mise config

All five share one file — `home/dot_config/mise/config.toml.tmpl` — and two deliberate constraints:

- **Regex, not the native `mise` manager**, because that file is a Chezmoi template and so is not valid TOML.
- **`currentValue` must start with a digit** (optionally after `v`), so `latest` is never matched. `latest` in this config is policy per [ADR 0003](adrs/0003-mise-config-plus-lockfile.md); widening these patterns to match it would open one PR per tool rewriting that policy away. Inline‑table forms (`= { version = "latest", bin = "..." }`) are likewise not matched.

The repo‑root `mise.toml` is intentionally **not** in scope for these five — the native `mise` manager already covers it, and adding it here would double‑report every pinned tool.

| # | Prefix | Pattern | Datasource | Example |
| --- | --- | --- | --- | --- |
| 2 | `aqua:` | `"aqua:(?<depName>[^/"]+/[^/"]+)"\s*=\s*"(?<currentValue>v?\d[^"]*)"` | `github-releases` | `aqua:mikefarah/yq` → `mikefarah/yq` |
| 3 | `github:` | `"github:(?<depName>[^/"]+/[^/"]+)"\s*=\s*"(?<currentValue>v?\d[^"]*)"` | `github-releases` | `github:sst/opencode` → `sst/opencode` |
| 4 | `ubi:` | `"ubi:(?<depName>[^/"]+/[^/"]+)"\s*=\s*"(?<currentValue>v?\d[^"]*)"` | `github-releases` | `ubi:miltonparedes/kitmux` → `miltonparedes/kitmux` |
| 5 | `npm:` | `"npm:(?<depName>[^"]+)"\s*=\s*"(?<currentValue>\d[^"]*)"` | `npm` | `npm:@anthropic-ai/claude-code` |
| 6 | `pipx:` | `"pipx:(?<depName>[^"]+)"\s*=\s*"(?<currentValue>\d[^"]*)"` | `pypi` | `pipx:gitingest` → `gitingest` |

The three `github-releases` managers set `extractVersionTemplate: '^v?(?<version>.+)$'`, mirroring the `extractVersion` packageRule that the native `mise` manager gets.

`depName` for aqua/github/ubi is restricted to exactly `owner/repo`. Multi‑segment aqua paths such as `aqua:Automattic/harper/harper-ls` are skipped on purpose: the extra segment names a sub‑tool, not a GitHub repo, so a lookup would resolve to nothing.

7) Optional Go/Node tool manifests (present if we add these files later)

- Go tools file: `home/dot_config/go-tools/tools.txt`
  - Pattern: `^(?<depName>[^\s@]+)@(?<currentValue>v?[^\s#]+)`
  - Datasource: `go`

- Node tools file: `home/dot_config/node-tools/tools.txt`
  - Pattern: `^(?<depName>[^@\n]+)@(?<currentValue>[^\n#]+)`
  - Datasource: `npm`

8) Chezmoi externals pinned to SHAs (Git Refs)

- File: `home/.chezmoiexternal.toml.tmpl`
- Datasource: `git-refs` with `currentValueTemplate: "master"` (we track the upstream default branch and replace our pinned SHA when the branch moves).

Current rules:

- oh-my-zsh tarball: `ohmyzsh/ohmyzsh/archive/(?<currentDigest>[a-f0-9]{7,40})\.tar\.gz`
- zsh‑autosuggestions tarball: `zsh-users/zsh-autosuggestions/archive/(?<currentDigest>[a-f0-9]{7,40})\.tar\.gz`
- zsh‑syntax‑highlighting tarball: `zsh-users/zsh-syntax-highlighting/archive/(?<currentDigest>[a-f0-9]{7,40})\.tar\.gz`
- gpakosz/.tmux repo revision: `^\s*revision\s*=\s*"(?<currentDigest>[a-f0-9]{7,40})"`

Note: When adding new externals, add a matching regex rule so Renovate can keep their SHAs fresh automatically.

---

## End‑to‑End Flow (What Renovate Updates)

- Docker: PRs updating only digests or minor/patch releases; digests grouped and auto‑merged.
- GitHub Actions: digest pinning and minor/patch updates grouped and auto‑merged.
- Mise tools: PRs update explicitly versioned pins in `mise.toml` (native manager, plus its `mise.lock`) and in `home/dot_config/mise/config.toml.tmpl` (regex managers), covering native runtimes, aqua/github/ubi tools, npm packages, and pipx tools. Entries left at `latest` are out of scope by design and move only when `mise install` / `mise lock` re-resolves them.
- CLI versions: PRs update `cli-versions.toml` (e.g., `cosign`).
- Chezmoi externals: PRs replace commit SHAs in tarball URLs or `revision = "..."`.

---

## How to Add or Change Pins

- Add a new mise tool:
  - Native runtime: add to `[tools]` with an exact version (e.g., `node = "24.11.1"`, `python = "3.14.0"`).
  - Aqua‑sourced: use `"aqua:owner/repo" = "vX.Y.Z"` to source releases from GitHub.
  - GitHub‑sourced: use `"github:owner/repo" = "vX.Y.Z"` to source releases from GitHub.
  - npm package: use `"npm:package-name" = "X.Y.Z"` or `"npm:@scope/package" = "X.Y.Z"`.
  - Python/pipx tool: use `"pipx:package-name" = "X.Y.Z"`.
  - Renovate will propose version bumps automatically via custom regex managers.

- Add a new CLI pin managed by scripts:
  - Add an entry to `home/dot_config/dotfiles/cli-versions.toml`.
  - Add code to read it where needed (e.g., `./install` reads `cosign`).
  - Add a `customManagers` regex rule if it’s not a standard ecosystem.

- Add a new Chezmoi external:
  - Pin to a specific commit SHA (tarball URL or `revision = "<sha>"`).
  - Add a matching `customManagers` rule using `git-refs` so Renovate can update it.

- Docker:
  - Keep tag+digest pattern for images and features.
  - Renovate will update digests; human‑readable tag remains for clarity.

---

## Handy gh / gh api Commands

Latest release tag for a repo:

```bash
gh release view -R owner/repo --json tagName,url,publishedAt
# or
gh api repos/owner/repo/releases/latest --jq .tag_name
```

List recent tags:

```bash
gh api repos/owner/repo/tags?per_page=10 --jq '.[].name'
```

Resolve a tag to a commit SHA (works for most tags):

```bash
# 1) Direct ref resolution via commits endpoint
gh api repos/owner/repo/commits/v1.2.3 --jq .sha

# 2) For annotated tags, dereference the tag object to the commit:
tag_obj_sha=$(gh api repos/owner/repo/git/ref/tags/v1.2.3 --jq .object.sha)
gh api repos/owner/repo/git/tags/$tag_obj_sha --jq .object.sha
```

Get the latest commit on a branch (e.g., master/main):

```bash
gh api repos/owner/repo/commits/master --jq .sha
# or
gh api repos/owner/repo/commits/main --jq .sha
```

Show the latest 5 commits on a branch:

```bash
gh api repos/owner/repo/commits --method GET -F sha=master -F per_page=5 --jq '.[].sha'
```

Inspect release assets (e.g., to locate binary names/checksums):

```bash
gh api repos/owner/repo/releases/latest --jq '.assets[].name'
```

Examples (from this repo’s usage):

```bash
# Cosign release tag
gh api repos/sigstore/cosign/releases/latest --jq .tag_name

# Chezmoi externals (current master SHA to pin)
gh api repos/ohmyzsh/ohmyzsh/commits/master --jq .sha
gh api repos/zsh-users/zsh-autosuggestions/commits/master --jq .sha
gh api repos/zsh-users/zsh-syntax-highlighting/commits/master --jq .sha
gh api repos/gpakosz/.tmux/commits/master --jq .sha
```

---

## Config Validation

Always validate Renovate configuration changes before committing:

```bash
# Validate configuration syntax and migrations
renovate-config-validator renovate.json5

# Check for syntax errors and deprecated patterns
npx renovate-config-validator renovate.json5
```

The validator will:
- Check JSON5 syntax and schema compliance
- Identify deprecated configuration patterns (e.g., `fileMatch` → `managerFilePatterns`)
- Suggest automatic migrations for outdated syntax
- Validate regex patterns and datasource configurations

**Important**: Always apply suggested migrations from the validator output to keep the config modern and prevent future breaking changes.

## Maintenance Tips

- Prefer explicit versions over `latest`; let Renovate do the bumping.
- When adding a new external or bespoke versions file, add a matching `customManagers` rule.
- Keep tag+digest for images: readable tag for humans, digest for reproducibility.
- Use the gh commands above to sanity‑check SHAs/tags when reviewing Renovate PRs.
- **Always validate renovate.json5 with `renovate-config-validator` before committing changes.**
