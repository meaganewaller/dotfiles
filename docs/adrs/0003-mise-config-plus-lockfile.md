---
status: "proposed"
date: 2026-05-13
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Mise “latest” (and ranges) in config + committed lockfiles for exact pins

## Context and Problem Statement

Today, tool versions in this repo are mostly **pinned as exact strings** in `mise.toml` (repo dev tools) and `home/dot_config/mise/config.toml` (user global tools). Renovate’s **mise** manager bumps those TOML pins, and `home/run_onchange_00-install-mise-tools.sh.tmpl` re-runs `mise install` when the **config file content hash** changes.

That model is clear but has tradeoffs:

- **Config churn** — Every bump edits the same file humans read for intent; diffs mix “what tool” with “exact micro version.”
- **Rate limits / tokens** — `mise install` often hits registries; the dotfiles script already prefers `GITHUB_TOKEN` from `gh` when present.
- **Reproducibility vs. flexibility** — Teams often want **fuzzy specifiers** in config (`latest`, `22`, semver ranges) while still shipping **one exact resolved artifact per platform** (version + checksum + download URL) for CI and new machines.

[mise lockfiles](https://mise.jdx.dev/) (`mise.lock`) address the second and third bullets: they record **resolved versions**, **checksums** (where backends support it), **sizes**, and **URLs** so installs can avoid repeated registry traffic and verify integrity. Lockfiles are **not** created automatically; operators run `mise lock` (or `mise install` / `mise use` with `lockfile = true`) to generate or refresh them.

This ADR proposes a **split responsibility**:

| Layer | Role |
| --- | --- |
| **`mise.toml` / `config.toml`** | Human/agent intent: allowed ranges, `latest`, or coarse pins where policy allows. |
| **`mise.lock` (committed)** | Machine truth: exact versions, checksums, URLs per platform; updated by intentional `mise lock` / upgrade flows and by **Renovate PRs** that touch the lockfile. |
| **Chezmoi `run_onchange_*`** | Re-run `mise install` when **either** the config **or** the lockfile changes (hash both into the script template). |

## Decision Drivers

- **Reproducibility**: Same commit → same binaries (especially with `MISE_LOCKED=1` / `settings.locked` in CI where appropriate).
- **Automation**: Renovate (or a documented custom manager) should open PRs that update pins **without** hand-editing checksum lines.
- **Operational clarity**: Intent (ranges) stays readable; lockfile holds the heavy artifact metadata.
- **Chezmoi integration**: `mise install` must run after lockfile updates land, not only when `config.toml` changes.
- **Package Manager / security policy**: Lockfile and `locked` mode interact with global vs project config—avoid surprising breakage for tools not present in the lockfile (see mise docs on **strict lockfile** scope).

## Considered Options

1. **Pins only in `mise.toml` / `config.toml` (status quo)** — Simple Renovate path today; no lockfile; more API use and no per-artifact checksum in-repo.
2. **Lockfile only, minimal config** — Maximum reproducibility; config might still list tool names; harder to express “track latest within major” without frequent lock regenerations.
3. **Dual layer: fuzzy / `latest` in config + committed `mise.lock`** — Config expresses policy; lockfile expresses resolved reality; Renovate targets lockfile (and optionally bumps config ranges separately).
4. **Per-environment lockfiles only** (`mise.*.lock`) — Useful for split CI/dev; more files and clearer `MISE_ENV` discipline—optional add-on to (3).

## Decision Outcome (proposed)

**Adopt option (3)** for managed paths in this repository, with optional (4) where a split CI/dev story is needed later.

1. **Enable lockfiles** where this repo owns the config (`[settings] lockfile = true` in the relevant `mise.toml` / `config.toml`, or `mise settings lockfile=true` documented for bootstrap—exact placement is an implementation detail).
2. **Commit `mise.lock`** next to the config it locks (e.g. `mise.lock` beside root `mise.toml`; `mise.lock` beside `home/dot_config/mise/config.toml` **if** mise resolves a single lockfile path for that file—confirm layout against mise’s [environment lockfile rules](https://mise.jdx.dev/) before implementing).
3. **Allow fuzzy specifiers** in committed config **only where** Renovate + review policy say that is acceptable; otherwise keep coarse but explicit ranges (e.g. major) and let the lockfile carry the micro version.
4. **Renovate** — Extend or add rules so dependency PRs update **`mise.lock`** (and `mise.*.lock` if used) in addition to—or instead of—micro-bumping every line in `config.toml`, per tool backend support. (Native Renovate `mise` support for lockfiles may require validation in this repo; fallback: **custom regex manager** on lockfile TOML fragments if needed.)
5. **Chezmoi `run_onchange_00-install-mise-tools.sh.tmpl`** — Include **hashes of both** `dot_config/mise/config.toml` and the relevant `mise.lock` (and any additional committed lockfile paths) in the generated script so `chezmoi apply` re-triggers `mise install` when **either** changes. Example pattern (illustrative):

   ```gotemplate
   # mise config hash: {{ include "dot_config/mise/config.toml" | sha256sum }}
   # mise lock hash: {{ include "dot_config/mise/mise.lock" | sha256sum }}
   ```

   Exact paths must match where lockfiles live after `mise lock` is run from the chezmoi source tree.

6. **CI** — Prefer `mise install` with committed lockfile; consider `MISE_LOCKED=1` once every tool in scope has lockfile URLs for CI platforms (see mise **strict lockfile** documentation).

### Consequences

- **Positive**: Fewer noisy “micro version” edits in main config; stronger integrity story; fewer live registry calls once lockfile populated; clearer separation of intent vs. resolution.
- **Positive**: `run_onchange` tracks lockfile changes—no “forgot to run mise after Renovate merged” drift.
- **Negative**: Contributors must learn `mise lock` / merge conflict resolution on `mise.lock`; Renovate config may need a new or tuned rule set.
- **Negative**: Backends without full checksum+URL support still get weaker guarantees—document per-tool expectations in [docs/package-management.md](../package-management.md) when implemented.
- **Negative (managed workstations — `mise lock --global`)**: In mise **2026.5.6** (verify for your installed version), `mise lock --global` builds its scope from every config path where `is_global_config` is true. That set includes **system** config (e.g. `/etc/mise/config.toml` on macOS), not only the user global file under `~/.config/mise/`. mise then tries to write **`/etc/mise/mise.lock`** (via a temp file in the same directory). On a work machine where `/etc/mise` is IT-managed and not user-writable, that step fails with **permission denied** after `~/.config/mise/mise.lock` may already have been updated, so **`mise lock --global` cannot be completed on that host**. This does not negate using lockfiles for repo-owned or user-owned config; it constrains *where* the user-global lockfile can be refreshed (e.g. a personal machine or CI image without a corporate `/etc/mise` layer, or project-only `mise lock` for `mise.toml`). Implicit lockfile updates during `mise install` / `mise use` follow separate rules and do not require writing under `/etc/mise`.

### Confirmation

- Fresh clone + `chezmoi apply` installs tools matching **`mise.lock`** without requiring ad-hoc `GITHUB_TOKEN` for the common case (per lockfile design).
- Merging a Renovate PR that **only** changes `mise.lock` causes the **run_onchange** script to fire on next apply and `mise install` converges.
- Policy doc states when **`latest`** is allowed vs. when config must use tighter specifiers.

## Rejected Options (default)

- **(1) indefinitely** as the *only* mechanism — Rejected as the long-term ceiling for this repo once lockfile workflow is proven; may remain true for specific tools with weak backend lock support until backends catch up.

## More information

- mise lockfile overview: [mise.lock (dev-tools)](https://mise.jdx.dev/dev-tools/mise-lock.html), [`mise lock` CLI](https://mise.jdx.dev/cli/lock.html).
- This repo: `home/dot_config/mise/config.toml`, `mise.toml`, `home/run_onchange_00-install-mise-tools.sh.tmpl`, `renovate.json5` (`mise` manager + custom managers).
- Related: [docs/renovate.md](../renovate.md), Package Manager agent for manifest changes.
