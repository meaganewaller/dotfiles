# AGENTS.md

Coding agents (and humans) use this file as the **entry map** for this repository. **`CLAUDE.md` is a symlink here**—one source of truth.

- **Why this repo exists** — [Vision](docs/vision.md), [Core principles](docs/core-principles.md), [README](README.md).
- **How to change dotfiles safely** — [Chezmoi operations](docs/agents/chezmoi.md) (edit → diff → apply → status; never write managed paths in `~` directly).

---

## Operating rules (short)

1. **Truth in the tree** — Durable config lives under `home/` (and related roots below); machines should match what is committed after `chezmoi apply` (see [Chezmoi doc](docs/agents/chezmoi.md)).
2. **Progressive disclosure** — This file inventories components; deep procedures live in `docs/` and skills.
3. **Packages** — New tools: **`/install <package>`** (pinned manifests, repo conventions). **Package Manager subagent** for sensitive or bulk changes (list below)—not ad-hoc version bumps in those files.
4. **Hooks** — In this repo, `.claude/hooks/` may enforce source-only edits; still follow the rules even when hooks are off.

---

## Component inventory

| Area | Location | Notes |
| --- | --- | --- |
| **Chezmoi source** | `home/` | `dot_*` → `~`; templates `.tmpl`; `run_onchange_*`; [detail](docs/agents/chezmoi.md) |
| **Template / package data** | `home/.chezmoidata/` | Brew lists, aliases, etc. consumed by templates |
| **Chezmoi externals** | `home/.chezmoiexternal.toml.tmpl` | Third-party snippets; Renovate-sensitive |
| **Global Claude Code config (managed)** | `home/dot_claude/` | Skills, agents, commands → `~/.claude/` via Chezmoi |
| **Repo-local Claude overrides** | `.claude/` (this repo only) | Hooks, extra skills—not necessarily synced to `~` |
| **Installer** | `./install` | Chezmoi bootstrap; env vars in [README](README.md) |
| **Dev scripts** | `bin/` | e.g. `bin/setup` (mise dev tools), `bin/test` (BATS) |
| **Tests** | `test/*.bats` | Run via `./bin/test` after `./bin/setup` |
| **CI** | `.github/workflows/` | ShellCheck, install matrix, BATS |
| **Automation** | `renovate.json5` | [Renovate](docs/renovate.md) |
| **ADRs** | `docs/adrs/` | Architecture decisions index: [README](docs/adrs/README.md) |
| **Docs** | `docs/` | Vision, principles, zsh, package management, agents |

---

## Where to read next

| Task | Go to |
| --- | --- |
| Edit / apply dotfiles | [docs/agents/chezmoi.md](docs/agents/chezmoi.md) |
| Pins, Renovate, digests | [docs/renovate.md](docs/renovate.md), [docs/package-management.md](docs/package-management.md) |
| Shell, agent-minimal zsh | [docs/zsh.md](docs/zsh.md) |
| Install / env vars | [README.md](README.md) |
| Add a CLI with correct pins | `/install` skill; then Chezmoi workflow above |

---

## Package installation and review

**Routine install:** `/install <package-name>` — prefers mise, pins versions, follows repo conventions.

**Package Manager subagent** (not `/install`) for:

- Version conflicts or upgrade policy calls
- **Docker Compose** image tags/digests
- **Devcontainer** images and features
- **Security-sensitive** or bulk manifest edits
- **Renovate** config churn
- **GitHub Actions** action versions/digests
- **Chezmoi externals** (`home/.chezmoiexternal.toml.tmpl`)

Rationale: immutable pins and Renovate compatibility—see [docs/renovate.md](docs/renovate.md).

---

## Security (summary)

- **`./install`** — Optional release verification (e.g. cosign); see installer and [README](README.md).
- **`private_*`** — Secrets / machine-local; Chezmoi encryption; do not leak into public artifacts.

Details and troubleshooting commands: [docs/agents/chezmoi.md](docs/agents/chezmoi.md).
