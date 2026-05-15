# Fish Configuration

This document describes the [fish shell](https://fishshell.com/) configuration in this dotfiles repository.

## Status

Fish is an **alternative** interactive shell — zsh remains the primary shell and the only one with agent-aware branching (see [docs/zsh.md](zsh.md) and [ADR 0001](adrs/0001-specialized-agent-shell.md)). If you launch fish manually, the full interactive profile runs. If an AI coding agent spawns fish, it gets the same full profile — there is **no** fish equivalent of the `_dotfiles_is_agent_shell` check today.

If you want fast, POSIX-style behavior for an agent in this repo, prefer zsh (the agent-minimal path is wired up in `home/dot_zshrc.tmpl`).

## Layout

```
home/dot_config/fish/
├── config.fish.tmpl              # Top-level interactive config (chezmoi-templated)
├── fish_plugins                  # Fisher plugin manifest
├── functions/
│   ├── fisher.fish               # Vendored fisher plugin manager (function file)
│   └── fish_greeting.fish        # Greeting hook
└── conf.d/
    ├── __homebrew.fish           # Homebrew env (loads first; double-underscore prefix)
    ├── editor.fish               # $EDITOR resolution per terminal context
    ├── fnox.fish                 # fnox secret-manager activation
    └── starship-init.fish        # Prompt
```

`config.fish.tmpl` is a [chezmoi template](agents/chezmoi.md) — the `.tmpl` extension causes chezmoi to render Go `text/template` directives at apply time. Everything under `conf.d/` and `functions/` is plain fish that chezmoi copies through unchanged.

## Top-level config (`config.fish.tmpl`)

Fish auto-loads `config.fish` for **every** shell, so this file short-circuits early for non-interactive sessions:

```fish
if not status is-interactive
    return
end
```

After that the template branches on the `work_profile` chezmoi data flag (set during `chezmoi init` — see [README.md](../README.md)):

| Branch | What happens |
| --- | --- |
| `work_profile = true` | Sets `PROFILE=work` and sources `~/.gusto/init.fish` if present. Does **not** activate mise here — work-profile machines manage their own tool resolution. |
| `work_profile = false` | Sets `PROFILE=personal`, prepends `~/.cargo/bin` to `PATH` (when not already managed by mise), and activates mise with `mise activate fish --shims`. |

Both branches then ensure GNU coreutils win on macOS (`$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin`), enable fzf-backed `cheat`, and set `GIT_MERGE_AUTOEDIT=no`.

## `conf.d/` — drop-in startup modules

Fish loads `conf.d/*.fish` alphabetically before `config.fish`. The repo ships four:

| File | Purpose |
| --- | --- |
| `__homebrew.fish` | Resolves `brew` and exports `HOMEBREW_PREFIX` / `HOMEBREW_CELLAR` / `HOMEBREW_REPOSITORY`. Double-underscore prefix forces this to load first so later modules can rely on Homebrew env vars. |
| `editor.fish` | Picks `$EDITOR` based on `$TERM_PROGRAM`: `code -w` inside VS Code, `cursor -w` inside Cursor, `nvim` otherwise. This **overrides** the `EDITOR=nvim` set inside `config.fish` for terminals that launch from an editor. |
| `fnox.fish` | Activates [fnox](https://github.com/jdx/fnox) (encrypted secret manager) if installed. |
| `starship-init.fish` | Initializes the [Starship](https://starship.rs/) prompt if the binary is on `PATH` and the shell is interactive. |

## `functions/` — autoloaded functions

Files in `functions/` are autoloaded the first time a function of the matching name is called. The repo owns two:

- **`fisher.fish`** — the [fisher](https://github.com/jorgebucaran/fisher) plugin manager itself, vendored as a function file so it's available without a bootstrap step. Pinned to version 4.4.8.
- **`fish_greeting.fish`** — overrides fish's default greeting to call `welcome2u` when present, otherwise silent.

## Plugins (fisher)

Plugin manifest: `home/dot_config/fish/fish_plugins`. Each line is a GitHub `owner/repo` reference. Currently shipping:

```
edc/bass
```

(`bass` lets fish source bash-style env scripts — handy for tools that only ship `.env`-style activators.)

### Adding or removing a plugin

```fish
fisher install owner/repo      # adds to $fish_plugins automatically
fisher remove  owner/repo
fisher update                  # update all
```

`fisher` writes the new list back to `fish_plugins`. Commit that file change through chezmoi:

```bash
chezmoi re-add ~/.config/fish/fish_plugins
chezmoi diff && chezmoi apply
```

See [docs/agents/chezmoi.md](agents/chezmoi.md) for the full edit / diff / apply workflow.

## Adding a function

Drop a `name.fish` file into `home/dot_config/fish/functions/` containing a single `function name … end` block. Fish autoloads on first use. No registration step.

If the function needs to be available across **both** zsh and fish, prefer a script in `bin/` (POSIX-compatible) over duplicating the logic in two shell dialects.

## Agent-shell question

Fish has no agent-shell branching today. If we later want to short-circuit fish for AI coding agents the way zsh does, the natural place is the very top of `config.fish.tmpl`, checking the same signals enumerated in [ADR 0001](adrs/0001-specialized-agent-shell.md) (`DOTFILES_AGENT_SHELL`, `CLAUDECODE`, `CURSOR_AGENT`). Not implemented — file an issue if you hit a real need.

## References

- [Fish documentation](https://fishshell.com/docs/current/index.html)
- [fisher (plugin manager)](https://github.com/jorgebucaran/fisher)
- [bass (bash compatibility)](https://github.com/edc/bass)
- [ADR 0001 — Agents need a specialized shell](adrs/0001-specialized-agent-shell.md) (zsh-only today)
- [docs/zsh.md](zsh.md) — primary shell and agent behavior
