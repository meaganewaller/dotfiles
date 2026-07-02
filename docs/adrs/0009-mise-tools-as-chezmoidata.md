---
status: "proposed"
date: 2026-07-02
decision-makers: [Meagan Waller]
consulted: []
informed: []
---

# Mise tools as `.chezmoidata`, rendered into `config.toml`

## Context and Problem Statement

The user-global mise tools live inline in `home/dot_config/mise/config.toml.tmpl` — one long `[tools]` table (~160 entries) carrying, per tool, a backend-qualified key (`aqua:…`, `github:…`, `npm:…`, `go:…`, `pipx:…`, `ubi:…`), a version specifier, occasional option tables (`{ version = "latest", bin = "yt-dlp" }`, `{ version = "latest", minimum_release_age = "2d" }`), an OS conditional or two (`{{ if eq .chezmoi.os "darwin" }}`), and a trailing `#` comment documenting what each tool is for. The same file also holds `[env]`, `[settings]`, `[settings.*]`, and `[plugins]`.

Every other large managed list in this repo has already moved to the `home/.chezmoidata/*.yaml` + template-rendering idiom: brew/cask/dnf packages (`packages.yaml`), tmux plugins (`tmux-plugins.yaml`, ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md)), and Claude marketplaces/plugins/MCP (`claude.yaml`, ADR [0008](0008-claude-config-two-managers.md)). The mise tool list is the last big inline catalog that does *not* follow it.

The question: **should the `[tools]` catalog move into `home/.chezmoidata/tools.yaml` as structured data, with `config.toml.tmpl` ranging over it to emit the `[tools]` table?** The motivations are (a) consistency with the established `.chezmoidata` idiom, (b) richer per-tool metadata (category, description, OS/profile conditions, options) expressed as a clean schema rather than TOML-key gymnastics, (c) cleaner diffs — a version bump or a new tool touches a data row, not the file humans read for prose intent, and (d) a single dataset that could feed more than one output later (a generated tools inventory, or the repo dev-tools config that now lives at `.mise/config.toml`).

The reason this needs an ADR rather than a commit message: the mise story is already governed by ADR [0003](0003-mise-config-plus-lockfile.md) (intent in config, resolved truth in a committed `mise.lock`, Renovate keeping them current, `run_onchange` hashing to re-fire `mise install`). Moving tools out of the TOML touches all four of those seams, and one of them — Renovate — is where this kind of change quietly breaks.

## Decision Drivers

- **Repo idiom.** Data in `.chezmoidata/`, behavior in templates/scripts. ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md) and [0008](0008-claude-config-two-managers.md) both landed here; the tools catalog is the conspicuous holdout.
- **Metadata & reuse.** A YAML schema can carry fields (category, description, os, options) that a TOML key cannot express cleanly, and a structured dataset can drive more than one output.
- **Reviewable diffs.** Separate "what tool at what version" (data) from "how it renders" (template) so bumps and additions read as tidy row edits.
- **Renovate must keep working.** ADR [0003](0003-mise-config-plus-lockfile.md) leans on Renovate to bump pins without hand-editing. Any new source of truth MUST be one Renovate can extract from — reliably, and *provably* so, because a custom manager that silently extracts nothing looks identical to "no updates available."
- **`mise.lock` stays the reproducibility backstop.** Exact resolution lives in the committed lockfile regardless of how intent is authored; the tool-spec layer is intent, not the safety net.
- **Emission fidelity.** Whatever renders `[tools]` MUST produce valid TOML that `mise` parses — including the heterogeneous option tables and OS conditionals. ADR [0008](0008-claude-config-two-managers.md) was explicit about the failure mode of Go-templated structured config: "renders fine, doesn't parse."
- **Apply-time re-trigger.** `chezmoi apply` must still re-run `mise install` when the *tool set* changes, not just when the template file's bytes change.

## Considered Options

1. **Status quo** — keep the `[tools]` table inline in `config.toml.tmpl`.
2. **Move `[tools]` to `tools.yaml`, render via template** (this proposal) — leave `[env]`/`[settings]`/`[plugins]` inline for now.
3. **Move the entire config to data** — render all of `config.toml` (settings, env, plugins, tools) from `.chezmoidata`.
4. **Split the difference** — keep versions/pins inline in TOML (so a manager can read them) but lift only descriptions/categories into YAML metadata.

## Decision Outcome

**Recommended: option (2), with guardrails — move `[tools]` to `home/.chezmoidata/tools.yaml` and render it, keeping `[env]`/`[settings]`/`[plugins]` inline for now (option 3 deferred).** Status is **proposed**: the recommendation is to adopt *provided the three guardrails below are met*, and to fall back to status quo if the Renovate guardrail cannot be satisfied reliably.

The recommendation leans on a finding that inverts the biggest apparent objection. The instinct is that leaving the TOML costs us Renovate's native `mise` manager. It does not — **that manager already does not manage this file**:

- `renovate.json5` points the `mise` manager at `^home/dot_config/mise/config\.toml$` and `^mise\.toml$`. The real file is `config.toml.**tmpl**`, so the pattern does not match it; and `mise.toml` was removed in this branch (repo dev-tools config now lives under `.mise/`).
- Even if the pattern were widened to the `.tmpl`, the file is **not valid TOML** — it contains Go template directives (`{{ if eq .chezmoi.os "darwin" }}`, `{{ if .work_profile }}…`) that a TOML parser cannot read.

So the global mise config already *requires a custom Renovate manager* by virtue of being a chezmoi template with conditionals — this is true in the status quo too. The real choice is not "native mise vs. custom" but **"a custom regex manager over TOML-interleaved-with-template-directives" vs. "a custom jsonata manager over clean YAML fields."** The latter is the more tractable of the two, which turns Renovate from a cost into a mild point *in favor* of the move — conditioned entirely on getting the manager right.

Getting it right is not free, and the repo already shows why. The existing `custom.jsonata` manager for `tmux-plugins.yaml` queries `tmuxPlugins.{ "depName": repo, "currentValue": ref, "currentDigest": commit }`, but the file's actual shape is `tmux_plugins.extras[]` with `url`/`revision` fields — the query matches nothing in the current structure. Whether that drifted over time or was mis-authored, the lesson is the same: **a custom manager over `.chezmoidata` can extract zero and look exactly like "up to date."** That is the single largest risk this proposal carries, and the reason the recommendation is conditional.

### The shape of the change

**Schema — a list of ordered groups, so grouping and file order survive** (YAML maps do not guarantee order):

```yaml
# home/.chezmoidata/tools.yaml
mise_tools:
  - group: "Runtime & Languages"
    tools:
      - tool: rust
        version: "1"
      - tool: node
        version: "24"
  - group: "Shell"
    tools:
      - tool: "aqua:starship/starship"
        version: latest
        comment: "Shell prompt"
  - group: "Downloaders"
    tools:
      - tool: "github:yt-dlp/yt-dlp"
        version: latest
        options: { bin: yt-dlp }        # renders as a TOML table value
        comment: "Downloader"
      - tool: "aqua:mas-cli/mas"
        version: latest
        os: [darwin]                     # gates emission by chezmoi.os
        comment: "Mac App Store CLI"
```

**Template — `config.toml.tmpl` ranges over the dataset** (mirrors the proven pattern in `home/.chezmoiexternals/tmux.toml.tmpl`, which already emits TOML from `tmux-plugins.yaml`):

```gotemplate
[tools]
{{- range .mise_tools }}

# {{ .group }}
{{- range .tools }}
{{- if or (not .os) (has $.chezmoi.os .os) }}
{{- if .options }}
"{{ .tool }}" = { version = {{ .version | quote }}{{ range $k, $v := .options }}, {{ $k }} = {{ $v | quote }}{{ end }} }{{ with .comment }} # {{ . }}{{ end }}
{{- else }}
"{{ .tool }}" = {{ .version | quote }}{{ with .comment }} # {{ . }}{{ end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
```

**Renovate — a `custom.jsonata` manager over `tools.yaml`.** The hard part is that mise backends map to *different* Renovate datasources, so a single manager cannot use one static `datasourceTemplate`:

| mise backend | Renovate datasource |
| --- | --- |
| `github:owner/repo` | `github-releases` |
| `ubi:owner/repo` | `github-releases` |
| `npm:pkg` | `npm` |
| `go:module` | `go` |
| `pipx:pkg` | `pypi` |
| `aqua:owner/repo` | (aqua registry → typically `github-releases`; verify) |
| bare (`node`, `ruby`, `go`) | mise core / registry mapping |

This likely means one jsonata manager *per backend* (filtered by the `tool` prefix), or a jsonata expression that derives the datasource from the prefix. This is the implementation's center of gravity and its chief risk.

**`run_onchange` — hash the data, not just the template.** `run_onchange_00-install-mise-tools.sh.tmpl` currently embeds `{{ include "dot_config/mise/config.toml.tmpl" | sha256sum }}`, which hashes the *template source*. Once tools move out, editing `tools.yaml` no longer changes that source, so `mise install` would not re-fire — silent drift. Add a third hash line (the "hash all inputs" idiom from ADR [0008](0008-claude-config-two-managers.md) §5):

```gotemplate
# mise tools data hash: {{ include ".chezmoidata/tools.yaml" | sha256sum }}
```

**`mise.lock` is unchanged.** mise reads the *rendered* `config.toml`, so the lockfile keeps recording exact resolution exactly as ADR [0003](0003-mise-config-plus-lockfile.md) describes. It remains the reproducibility backstop, which is what makes the intent-layer authoring format a safe thing to change.

### Guardrails (conditions of adoption)

1. **Provable Renovate extraction.** Add a CI check that Renovate's config extracts a non-zero count of dependencies from `tools.yaml` (e.g. `renovate-config-validator` plus an extraction smoke test), so the tmux-manager failure mode cannot recur unnoticed. Do not merge the move until at least one real bump PR has been observed end-to-end.
2. **Emission fidelity.** A spike renders `config.toml` from `tools.yaml` and pipes it through `mise config` (or `mise install --dry-run`) in CI, proving the output parses and matches the pre-move tool set one-for-one (diff the resolved tool list before/after).
3. **Re-trigger correctness.** `tools.yaml` is hashed into the `run_onchange` script; a `bats` test asserts that editing the data changes the generated script hash.

### Consequences

- **Positive**: The tools catalog joins the repo idiom; adding a tool is a data-row edit with structured metadata (category, description, os, options) instead of hand-formatted TOML keys and aligned comments.
- **Positive**: Renovate management of the global config *improves* — a jsonata manager over typed YAML fields is more tractable than regex over TOML interleaved with Go conditionals, which is what a status-quo custom manager would have to be.
- **Positive**: The dataset can drive additional outputs later (a generated tools inventory in docs; shared sourcing with the repo dev-tools config) — the driver behind wanting a single source.
- **Positive**: `mise.lock` and the intent/resolution split from ADR [0003](0003-mise-config-plus-lockfile.md) are preserved unchanged.
- **Negative / accepted**: A Go template now emits structured TOML — the failure mode ADR [0008](0008-claude-config-two-managers.md) called out ("renders fine, doesn't parse"). Guardrail 2 (spike + `mise config` in CI) is the mitigation; the tmux-externals precedent shows the pattern is workable for TOML, though the mise table is more heterogeneous.
- **Negative**: Per-backend datasource mapping is real Renovate complexity (multiple managers or a derivation expression) that the native mise manager would otherwise handle for free — a benefit we cannot use here anyway, given the file is a template.
- **Negative**: Silent-extraction drift is a live hazard in this repo (the tmux jsonata manager). Guardrail 1 is the mitigation, and it is the gating condition.
- **Negative**: Per-tool inline comments become a `comment:` field rendered back — a small amount of template logic and a discipline to keep populated.
- **Neutral**: `[env]`/`[settings]`/`[plugins]` stay inline; a future ADR can revisit moving them (option 3) if the tools move proves out. Settings rarely churn and gain little from datafication, so deferring them is low-cost.

### Confirmation

- `renovate-config-validator` passes and an extraction smoke test reports a non-zero, expected dependency count from `tools.yaml`; a real dependency-bump PR has been observed.
- Rendering `config.toml` from `tools.yaml` and running `mise config` / `mise install --dry-run` in CI parses cleanly and the resolved tool set matches the pre-move set (before/after diff is empty).
- Editing a version in `tools.yaml` changes the generated `run_onchange_00-install-mise-tools.sh.tmpl` hash (covered by a `bats` test), and a fresh `chezmoi apply` re-runs `mise install`.
- `mise.lock` continues to carry exact resolution; a clean clone + apply converges to the locked versions.

## Rejected Options

- **(1) Status quo** — Not rejected outright; it is the explicit fallback if guardrail 1 cannot be met. Its ceiling is that the tools catalog stays outside the repo idiom and the global config *still* needs a custom Renovate manager (being a template), so status quo does not even buy back the "native mise manager" it appears to protect.
- **(3) Move the entire config to data** — Deferred, not rejected. Rendering `[settings]`/`[env]`/`[plugins]` from data multiplies the emission-fidelity surface (guardrail 2) for sections that rarely change and express little structured metadata. Revisit once (2) is proven.
- **(4) Versions inline, metadata in YAML** — Rejected. Splitting a single tool's truth across two files (pin in TOML, description in YAML) is worse for both diffs and Renovate than either whole-hog option, and defeats the "single source" driver.

## Revisit when

- The tools move is proven and stable — reopen for option (3) (settings/env/plugins as data), or to have the repo dev-tools config (`.mise/config.toml`) share the dataset.
- Renovate ships (or the repo adopts) first-class handling for mise tools inside chezmoi templates, which would collapse the custom-manager complexity.
- The custom jsonata manager is found extracting nothing in CI — treat as a regression against guardrail 1, not a reason to abandon the approach.

## More information

- Builds on: ADR [0002](0002-tmux-plugins-via-chezmoi-externals.md) (data in `.chezmoidata`, behavior in templates; externals emit TOML from YAML), ADR [0003](0003-mise-config-plus-lockfile.md) (mise intent vs. lockfile, Renovate, `run_onchange` hashing), ADR [0008](0008-claude-config-two-managers.md) (declarative data realized carefully; caution on Go-templated structured config; hash-all-inputs idiom).
- Code: `home/dot_config/mise/config.toml.tmpl`, `home/dot_config/mise/mise.lock`, `home/.chezmoiscripts/run_onchange_00-install-mise-tools.sh.tmpl`, `home/.chezmoiexternals/tmux.toml.tmpl` (rendering precedent), `renovate.json5` (`mise` manager + `custom.jsonata` for `tmux-plugins.yaml`).
- Related docs: [docs/renovate.md](../renovate.md), [docs/package-management.md](../package-management.md), and the Package Manager subagent for the Renovate manager work.
