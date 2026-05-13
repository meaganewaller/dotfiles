# Zsh Configuration

This document describes the zsh shell configuration in this dotfiles repository.

## Design Philosophy

The configuration follows a minimalist approach:
- Uses Oh My Zsh for base functionality but doesn't over-customize
- Implements standard specifications (XDG Base Directory)
- Provides robust utility functions with comprehensive fallbacks
- Keeps most Oh My Zsh options as commented examples for reference

## Key Features

- **XDG Compliance**: Proper directory structure following standards
- **Clean PATH Management**: Safely adds user bin directory
- **Vi Mode**: Familiar vi keybindings for command editing
- **Tool Integration**: Modern tools (mise, starship) integrated via plugins
- **Fast Reload**: Custom `reload!` function for quick shell restarts
- **Smart Project Navigation**: Intelligent repository discovery with the `e` function

## Configuration Files

The zsh configuration is split across two files:

- `home/dot_zshenv` - Environment setup and PATH configuration
- `home/dot_zshrc` - Interactive shell configuration

## Environment Setup (dot_zshenv)

### XDG Base Directory Specification

The configuration implements the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) for standardized directory locations:

```bash
# User directories
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# System directories
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
```

### PATH Management

The configuration adds `~/.local/bin` to the front of PATH if it exists and isn't already present, following the XDG pattern for user binaries.

## Interactive Shell Configuration (dot_zshrc)

When AI coding agents (Claude Code, Cursor agent, CI, etc.) run commands through your zsh, they need standard command behavior and fast startup. `home/dot_zshrc.tmpl` therefore branches at the top: if the shell is classified as an **agent shell**, it skips Oh My Zsh, autosuggestions, syntax highlighting, and human-centric aliases (such as `cat` → `bat`), while still activating **mise**, keeping **fpath** / `autoload` for shared functions like `c`, prepending the git-safe `bin` PATH entry, and using a simple `PROMPT`.

**Detection (single place in the template):** `_dotfiles_is_agent_shell` returns true when any of these hold:

| Signal | Meaning |
| --- | --- |
| `DOTFILES_AGENT_SHELL=1` | Explicit opt-in (unknown agents, sandboxes, scripts). |
| `DOTFILES_AGENT_SHELL=0` (or `false` / `no` / `off`) | Explicit opt-out: always use the full interactive profile, even if a vendor fingerprint is set. |
| `CLAUDECODE=1` | Shell spawned by [Claude Code](https://code.claude.com/docs/en/env-vars). |
| Non-empty `CURSOR_AGENT` | Cursor agent–driven terminal (see [ADR 0001](adrs/0001-specialized-agent-shell.md); `CURSOR_CLI` is intentionally not used because it is often set for any Cursor integrated terminal). |

Details and rejected alternatives: [docs/adrs/0001-specialized-agent-shell.md](adrs/0001-specialized-agent-shell.md).

### Oh My Zsh Framework

The configuration uses [Oh My Zsh](https://ohmyz.sh/) framework with:
- Installation path: `$HOME/.oh-my-zsh`
- No custom theme (commented out default)
- Standard configuration options left as comments for reference

### Vi Mode

Vi keybindings are enabled for command line editing:
```bash
bindkey -v
```

### Custom Functions

The configuration includes a function autoloading system that follows zsh best practices. Functions are stored in `$XDG_CONFIG_HOME/zsh/functions/` and autoloaded on demand for better performance.

#### reload! Function

A shell reload function for fast configuration reloads. Simply run `reload!` to restart your shell session with updated configuration.

#### c Function

A project navigation function for quickly changing to project directories. Unlike the `e` command which launches Claude Code, `c` simply navigates to the project directory in the current shell session.

**Usage:**
```bash
c                    # Use fzf to select from available projects
c REPO              # Navigate to REPO across configured organizations  
c ORG/REPO          # Navigate to specific ORG/REPO
```

#### e Function

A project navigation and Claude Code launcher script. The `e` command intelligently finds, clones, or creates repositories and opens them in Claude Code.

**Usage:**
```bash
e                    # Use fzf to select from available projects
e REPO              # Search for REPO across configured organizations
e ORG/REPO          # Open specific ORG/REPO
```

**Environment Variables:**
- `PROJECTS_DIR` - Base directory for projects (default: `$HOME/src/github.com`)
- `GITHUB_USER` - Primary GitHub username 
- `GITHUB_ORGS` - Comma-delimited list of GitHub organizations to search (e.g., `"myorg,company,another-org"`)

**Smart Repository Discovery:**
When you specify just a repository name (e.g., `e dotfiles`), the function:
1. Searches locally across all configured organizations
2. If not found locally, tries cloning from each organization in order
3. Only creates a new repository if none are found and you confirm

**Organization Priority:**
The function checks organizations in this order:
1. `GITHUB_USER` environment variable
2. User from `gh config get user` (GitHub CLI)
3. Organizations from `GITHUB_ORGS` (comma-delimited)
4. System username as final fallback