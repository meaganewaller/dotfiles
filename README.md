# dotfiles

[![CI](https://github.com/meaganewaller/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/meaganewaller/dotfiles/actions/workflows/ci.yml)

> There's no place like `~`

This repository is a **Chezmoi-managed developer environment** with a deliberate goal: **coding agents should be able to run and reconcile most day-to-day maintenance**, while **humans supply intent, tradeoffs, taste, and aesthetic judgment**. The repo stays the source of truth; machines converge to what is committed here.

Read **[Vision](docs/vision.md)** for the full picture and **[Core principles](docs/core-principles.md)** for decision filters (reproducibility, security, human-gated taste, when to write ADRs).

Practical layout, package policy, and workflows for agents and humans live in **`AGENTS.md`** (and **`CLAUDE.md`**, which points to the same content).

---

## Installation

### Quick start

```bash
# Clone to the expected path
mkdir -p ~/src/github.com/meaganewaller
git clone https://github.com/meaganewaller/dotfiles.git ~/src/github.com/meaganewaller/dotfiles
cd ~/src/github.com/meaganewaller/dotfiles
```

### Advanced usage

The installer supports options and can pass arguments through to `chezmoi init`:

```bash
# Force reinstall tools (if already installed)
REINSTALL_TOOLS=true ./install

# Pass args to chezmoi init
./install -- --force         # Force chezmoi to overwrite existing files
./install -- --one-shot      # Use chezmoi's one-shot mode

# Combine options
REINSTALL_TOOLS=true ./install -- --force
```

#### Environment variables

- `REINSTALL_TOOLS=true` — Force reinstallation of tools even if already present
- `BIN_DIR=/custom/path` — Install binaries to a custom directory (default: `~/.local/bin`)
- `DEBUG=1` — Enable debug output during installation
- `VERIFY_SIGNATURES=false` — Disable signature verification (not recommended)

For a full list of installer options, run `./install --help`.

#### Non-interactive installation

For CI/CD or environments without a TTY, set:

- `GIT_USER_NAME="Your Name"` — Git user name for commits
- `GIT_USER_EMAIL="your.email@example.com"` — Git user email for commits

Example:

```bash
GIT_USER_NAME="CI User" GIT_USER_EMAIL="ci@example.com" ./install
```

---

## Documentation map

| Doc | Purpose |
| --- | --- |
| [docs/vision.md](docs/vision.md) | Why this repo exists; humans vs. agents |
| [docs/core-principles.md](docs/core-principles.md) | Decision filters for changes and automation |
| [docs/renovate.md](docs/renovate.md) | Pins, Renovate, and version manifests |
| [docs/zsh.md](docs/zsh.md) | Shell layout and agent-aware zsh behavior |
| [docs/fish.md](docs/fish.md) | Fish as alternative shell (no agent branching) |
| [docs/adrs/README.md](docs/adrs/README.md) | Architecture decision records index |
| [docs/agents/chezmoi.md](docs/agents/chezmoi.md) | Chezmoi edit / diff / apply workflow and troubleshooting |
| [AGENTS.md](AGENTS.md) | Component inventory and navigation (start here for agents) |

---

## Tech stack

How the pieces fit together in **this** repository (not an exhaustive list of every CLI pin—see `home/dot_config/mise/config.toml` and `home/.chezmoidata/` for those).

| Concern | What this repo uses |
| --- | --- |
| **Dotfile delivery** | [Chezmoi](https://chezmoi.io/) — `sourceDir` is the working tree; `home/dot_*` → `~`; `.tmpl` for Go `text/template` |
| **Pinned CLIs & runtimes** | [mise](https://mise.jdx.dev/) — aqua / GitHub / pipx / npm / cargo backends; user tools in `home/dot_config/mise/config.toml` |
| **Dev-only test tools** | Root [`.mise.toml`](.mise.toml) — BATS, ShellCheck, yq, shfmt (`./bin/setup` → `mise install`) |
| **macOS system packages** | [Homebrew](https://brew.sh/) — `brew bundle` from Chezmoi-rendered data (`run_onchange_install-packages-darwin.sh.tmpl`) |
| **Bootstrap / trust** | `./install` — prefers OS package managers, otherwise GitHub releases; optional [cosign](https://docs.sigstore.dev/cosign/overview/) verification for downloads |
| **CI** | [GitHub Actions](https://github.com/features/actions) — ShellCheck on scripts, matrix install + [BATS](https://github.com/bats-core/bats-core) via `./bin/test`, [jdx/mise-action](https://github.com/jdx/mise-action) |
| **Dependency PRs** | [Renovate](https://github.com/renovatebot/renovate) — `renovate.json5`, labels `deps` / `automated` ([docs](docs/renovate.md)) |
| **Shell** | zsh (primary) — [Oh My Zsh](https://ohmyz.sh/), [Starship](https://starship.rs/), (see [docs/zsh.md](docs/zsh.md); agent-minimal path in `home/dot_zshrc.tmpl` per [ADR 0001](docs/adrs/0001-specialized-agent-shell.md)). [Fish](https://fishshell.com/) (alternative) — see [docs/fish.md](docs/fish.md). |
| **Editor** | [Neovim](https://neovim.io/) — [LazyVim](https://www.lazyvim.org/) / [lazy.nvim](https://github.com/folke/lazy.nvim) (`home/dot_config/nvim/`) |
| **Terminal multiplexer** | [tmux](https://github.com/tmux/tmux) — `home/dot_config/tmux/tmux.conf` |
| **Repo & PRs** | git, [GitHub CLI](https://cli.github.com/) (`gh`) |

---

## Philosophy in one line

**Automate the environment faithfully; keep humans in the loop for meaning, beauty, and risk.**
