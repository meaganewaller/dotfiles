# Tmux Configuration

This dotfiles repository includes a standalone tmux configuration — explicit,
hand-written settings built on top of [`tmux-sensible`](https://github.com/tmux-plugins/tmux-sensible)
defaults. It previously vendored [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
as a base framework; that was fully replaced (see [ADR 0002](adrs/0002-tmux-plugins-via-chezmoi-externals.md)'s
update note).

## Overview

- **Base Configuration**: `home/dot_config/tmux/tmux.conf` (XDG path: `~/.config/tmux/tmux.conf`) — a single, self-contained file, no vendored framework
- **Plugins**: `tmux-sensible`, `tmux-prefix-highlight`, `tmux-powerline` — each fetched as an individually-pinned Chezmoi external, not a plugin manager
- **Prefix**: `C-a` (not the default `C-b`)
- **Vi Mode**: vi-style copy mode and pane navigation
- **Mouse**: always on (no toggle binding)
- **Theming**: Integrated with the [universal theme switcher](adrs/0005-universal-theme-switcher.md) — pane borders and the powerline status bar both re-theme when `theme <name>` runs

## Architecture

### Standalone configuration, no vendored base

`home/dot_config/tmux/tmux.conf` is the entire configuration. There is no
external base framework to source, no `~/.tmux.conf` symlink, and no
`dot_tmux.conf.local` override file — everything (prefix, keybindings,
plugins, theming) lives in this one file.

### Plugins as individually-pinned Chezmoi externals

Plugins are declared in `home/.chezmoidata/tmux-plugins.yaml`
(`tmux_plugins.extras`) and materialized as Chezmoi `git-repo` externals by
`home/.chezmoiexternals/tmux.toml.tmpl`, which ranges over the catalog:

```yaml
tmux_plugins:
  extras:
    - path: ".config/tmux/plugins/tmux-sensible"
      type: git-repo
      url: https://github.com/tmux-plugins/tmux-sensible.git
      branch: master
      revision: <pinned-commit-sha>
      refreshPeriod: "168h"
    # ...tmux-powerline, tmux-prefix-highlight follow the same shape
```

Each plugin lands at `~/.config/tmux/plugins/<name>/`, and `tmux.conf` loads
it with an explicit `run-shell` line:

```tmux
run-shell ~/.config/tmux/plugins/tmux-sensible/sensible.tmux
run-shell ~/.config/tmux/plugins/tmux-prefix-highlight/prefix_highlight.tmux
# ...
run-shell ~/.config/tmux/plugins/tmux-powerline/main.tmux
```

There is no TPM, no `prefix + I` install step, and no floating `master`/`main`
tracking — each plugin is pinned to a commit SHA (`revision`), and a Renovate
`jsonata` custom manager bumps that SHA when the plugin's declared `branch`
moves (see [docs/renovate.md](renovate.md)). See [ADR 0002](adrs/0002-tmux-plugins-via-chezmoi-externals.md)
for why this approach was chosen over TPM/tpack/submodules.

### Configuration Files

```
~/.config/tmux/tmux.conf                -> Full config (no symlink, no vendored base)
~/.config/tmux/tmux-remote-detect.sh    -> SSH-session detection, hooked on attach/create
~/.config/tmux/plugins/<name>/          -> Individually-pinned plugin externals
~/.config/tmux-powerline/               -> Powerline status-bar config, themes, custom segments
~/.local/state/theme/tmux.conf          -> Theme overlay written by theme.d/tmux; source-file'd at the bottom of tmux.conf
```

## Custom Features

### Vi Mode Navigation

**Location**: `home/dot_config/tmux/tmux.conf`

#### Copy Mode

- `setw -g mode-keys vi` — enables vi-style copy mode
- `v` — begin selection in copy mode
- `y` — yank selection and exit copy mode
- `set -g set-clipboard on` plus explicit OSC 52 `terminal-features` — copies both to tmux's own buffer and the outer terminal (Ghostty, WezTerm, kitty, iTerm2, etc.)

#### Pane Navigation (Prefix-based fallback)

- `prefix + h/j/k/l` — navigate between panes
- `prefix + H/J/K/L` — resize panes (with repeat)
- `prefix + Up/Left/Down/Right` — navigate without repeat

### Smart Pane Switching with Vim Awareness

The `Ctrl-h/j/k/l` bindings are unprefixed and vim-aware: they check whether
the active pane is running vim/nvim (via a `ps`-based `is_vim` shell test)
and, if so, forward the keystroke to vim instead of switching tmux panes.
This is the same detection technique popularized by
[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator), but
implemented directly in `tmux.conf` rather than pulled in as a separate
plugin — there is no `vim-tmux-navigator` Chezmoi external or tmux plugin;
the neovim side needs no matching plugin either.

- `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l` — move between vim splits (inside vim) or tmux panes (outside vim)
- `Ctrl+\` — move to the previous pane/split
- Copy mode has matching `C-h/j/k/l/\\` bindings for consistent navigation

#### Version Compatibility

The `Ctrl+\` binding is defined twice, guarded by a runtime `tmux -V` check,
because tmux changed how backslash needs escaping in bound commands at 3.0:

- **tmux < 3.0**: single backslash escape
- **tmux >= 3.0**: double backslash escape

### Custom Keybindings

**Location**: `home/dot_config/tmux/tmux.conf`

#### Claude Code Integration

- `prefix + e` — opens a new "dotfiles" window and launches Claude Code in the chezmoi working tree (`chezmoi data | jq -r .chezmoi.workingTree`)

#### Popups (`display-popup`)

- `prefix + p` — scratch popup in the current pane's directory
- `prefix + g` — `lazygit`
- `prefix + v` — `nvim`
- `prefix + d` / `prefix + D` — `lumen diff` / `lumen-stacked` (fish)
- `prefix + y` — `yazi` in a new window
- `M-s` / `M-k` / `M-j` (unprefixed) — kitmux sessions / palette / scratch popup
- `prefix + o` / `prefix + W` / `prefix + A` — kitmux workspaces / worktrees / agents

#### Other

- `prefix + w` — `choose-tree -Zw`, a mouse-friendly window/session switcher
- `prefix + r` — reload config from `~/.config/tmux/tmux.conf`
- `prefix + q` — detach client
- `prefix + z` — open Zed in the current pane's directory
- `prefix + \|` / `prefix + -` — split panes horizontally/vertically, preserving `pane_current_path`
- `prefix + c` — new window, preserving `pane_current_path`
- `prefix + C-l` — clear terminal and scrollback history
- `Ctrl+Tab` / `Ctrl+Shift+Tab` (unprefixed) — next/previous window

### Remote Session Detection

`~/.config/tmux/tmux-remote-detect.sh` sets a `@is-remote` user option based
on whether `SSH_CONNECTION` is present in the tmux server's environment. It
runs on tmux start, on client attach, and on session creation, so the status
bar (via a tmux-powerline segment) can reflect local vs. SSH sessions.

### Theming

Pane borders and the powerline status bar both participate in the
[universal theme switcher](adrs/0005-universal-theme-switcher.md):

- `theme.d/tmux` (run by `theme <name>`) writes pane/window style overrides to `~/.local/state/theme/tmux.conf`, which `tmux.conf` `source-file`s if present.
- `tmux-powerline`'s config (`~/.config/tmux-powerline/config.sh`) picks a Catppuccin variant based on system appearance, and a silent `theme_refresh` segment re-applies the pane theme on every status-bar refresh so a running server picks up theme changes without a manual reload.

## Installation & Management

### Initial Setup

```bash
# Materializes tmux.conf and fetches all pinned plugin externals
chezmoi apply
```

### Updating a Plugin's Pinned Revision

Plugin revisions are bumped by Renovate (a `jsonata` custom manager reads
`home/.chezmoidata/tmux-plugins.yaml` directly) or by hand — either way, the
new `revision` lands in that YAML file, and the next `chezmoi apply`
re-fetches the plugin at the new pin. There is no floating-branch tracking or
`chezmoi update --force` external-refresh step to run.

### Runtime Management

```bash
# Reload configuration (also bound to `prefix + r`)
tmux source-file ~/.config/tmux/tmux.conf

# View current key bindings
tmux list-keys
```

`prefix + r` reloads directly from the file on disk — no `chezmoi apply` is
involved in a runtime reload.

## Adding a New Plugin

Per [ADR 0002](adrs/0002-tmux-plugins-via-chezmoi-externals.md), a new plugin
requires two edits:

1. Add a row to `tmux_plugins.extras` in `home/.chezmoidata/tmux-plugins.yaml` (`path`, `type`, `url`, plus `branch`/`revision` for `git-repo` pins, or `stripComponents`/`exact` for `archive`).
2. Add an explicit `run-shell` (or `source-file`) line in `home/dot_config/tmux/tmux.conf` pointing at the same `path`.

Then add a matching Renovate rule if the plugin needs automatic SHA bumps —
see [docs/renovate.md](renovate.md).

## Integration with Development Workflow

### Neovim Integration

- Seamless navigation between vim splits and tmux panes via the embedded `is_vim` detection (no plugin required on either side)
- Copy mode navigation matches vim movement

### Shell Integration

- Works with any shell (zsh, bash, fish)
- Smart window/pane naming via `tmux-sensible`

### Session Management

```bash
# Create named session
tmux new-session -s development

# Attach to session
tmux attach-session -t development

# List sessions
tmux list-sessions
```

## Troubleshooting

### Navigation Issues

- Check tmux version compatibility for the `Ctrl+\` binding (see Version Compatibility above)
- Verify the `ps` command's output format on your system if vim detection misbehaves

### Configuration Problems

- Use `prefix + r` to reload after changes
- Check syntax with: `tmux -f ~/.config/tmux/tmux.conf -T`
- View logs: `tmux show-messages`

### Plugin Issues

- Confirm the plugin materialized: `ls ~/.config/tmux/plugins/<name>`
- `chezmoi diff` / `chezmoi apply` to re-fetch a pinned plugin external
- Check `home/.chezmoidata/tmux-plugins.yaml` for the plugin's declared `revision`

### Paste Issues in Ghostty/Neovim

`tmux.conf` sets `extended-keys off` specifically to fix paste breaking
inside Ghostty + Neovim (see [gpakosz/.tmux#776](https://github.com/gpakosz/.tmux/issues/776)
for the underlying tmux/terminal interaction). If paste misbehaves after
changing terminal or Neovim versions, check this setting before assuming
it's a new bug.

## Performance Considerations

- **Pinned, not floating**: each plugin is pinned to a commit SHA, refreshed on a per-plugin `refreshPeriod` (currently 7 days) rather than tracking a branch live on every apply
- **Minimal overhead**: explicit `run-shell` lines, no plugin-manager indirection layer
- **Smart Detection**: vim detection uses a lightweight `ps` check

## References

- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) — sane defaults this config builds on
- [tmux-powerline](https://github.com/erikw/tmux-powerline) — status bar
- [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight) — prefix-key indicator
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) — origin of the vim-aware pane-switching technique used here
- [Tmux Manual](http://man.openbsd.org/OpenBSD-current/man1/tmux.1) — complete tmux documentation
- [ADR 0002](adrs/0002-tmux-plugins-via-chezmoi-externals.md) — why plugins are Chezmoi externals, not TPM/tpack/submodules
