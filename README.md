# dotfiles

> There's no place like `~`

This repository is a **Chezmoi-managed developer environment** with a deliberate goal: **coding agents should be able to run and reconcile most day-to-day maintenance**, while **humans supply intent, tradeoffs, taste, and aesthetic judgment**. The repo stays the source of truth; machines converge to what is committed here.

Read **[Vision](docs/vision.md)** for the full picture and **[Core principles](docs/core-principles.md)** for decision filters (reproducibility, security, human-gated taste, when to write ADRs).

Practical layout, package policy, and workflows for agents and humans live in **`AGENTS.md`** (and **`CLAUDE.md`**, which points to the same content).

---

## Installation

### Quick start

```bash
git clone https://github.com/meaganewaller/dotfiles.git && cd dotfiles && ./install
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
| [docs/adrs/README.md](docs/adrs/README.md) | Architecture decision records index |
| [AGENTS.md](AGENTS.md) | Agent and human workflow for this tree |

---

## Philosophy in one line

**Automate the environment faithfully; keep humans in the loop for meaning, beauty, and risk.**
