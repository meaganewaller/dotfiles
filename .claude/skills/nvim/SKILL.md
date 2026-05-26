---
name: nvim
description: "Use when troubleshooting Neovim plugin errors, updating plugins after breaking changes, or diagnosing colorscheme/startup issues in this vim.pack-based config."
argument-hint: "[debug | update | fix <plugin>]"
model: sonnet
context: default
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(nvim --version:*)
  - Bash(nvim --headless:*)
  - Bash(tmux new-session -d -s nvim-debug:*)
  - Bash(tmux kill-session -t nvim-debug:*)
  - Bash(tmux capture-pane -t nvim-debug:*)
  - Bash(ls:*)
  - Bash(cat /tmp/nvim-debug*:*)
  - Bash(git -C ~/.local/share/nvim/site/pack/core/opt:*)
  - Bash(chezmoi diff:*)
  - Bash(chezmoi status:*)
  - Bash(sleep:*)
  # Requires user approval:
  # - Edit/Write (config changes)
  # - chezmoi apply (deploys to destination)
  # - git add/commit (version control)
  # - rm cache, cp lockfile (destructive/overwrite)
---

# Neovim Troubleshooting & Updates

This config is **not** LazyVim. Plugins are managed by `vim.pack` (Neovim 0.12+ built-in). No lazy.nvim, no LazyVim distribution, no snacks. See `docs/neovim.md` for the full layout.

## Arguments

```
$ARGUMENTS
```

## Key Paths

| What | Source (edit here) | Installed (read-only) |
|------|-------------------|----------------------|
| Plugin specs | `home/dot_config/nvim/plugin/00-packs.lua` | `~/.config/nvim/plugin/00-packs.lua` |
| Per-plugin config | `home/dot_config/nvim/plugin/<name>.lua` | `~/.config/nvim/plugin/<name>.lua` |
| Core modules | `home/dot_config/nvim/lua/{options,ui,window,keymaps,autocmds}.lua` | `~/.config/nvim/lua/...` |
| Lockfile (committed) | `home/dot_config/nvim/nvim-pack-lock.json` | `~/.config/nvim/nvim-pack-lock.json` |
| Installed plugins | — | `~/.local/share/nvim/site/pack/core/opt/<plugin>/` |

**Always edit source (`home/dot_config/nvim/`), never destination. Deploy with `chezmoi apply`.**

## Mode: `debug` (default)

**Use tmux, not headless** — `--headless` skips UI plugins (lualine, blink.cmp, oil) so it hides real errors. The debug script also relies on `vim.pack` having finished its install/update pass.

1. Copy debug script: `cp .claude/skills/nvim/nvim-debug.lua /tmp/nvim-debug.lua`
2. Launch: `tmux new-session -d -s nvim-debug -x 200 -y 50 "nvim -S /tmp/nvim-debug.lua"`
3. Wait + read: `sleep 8 && cat /tmp/nvim-debug-output.txt`
4. Check `[ERROR]` lines — these come from `:messages` (where `vim.pack`, LSP, and plugins route errors)

## Mode: `fix <plugin>`

1. **Compare lockfile vs. installed rev**: `nvim-pack-lock.json` records pinned `rev`. Check `git -C ~/.local/share/nvim/site/pack/core/opt/<plugin> rev-parse HEAD` — drift means an out-of-band update broke things.
2. **Find the breaking commit**: `git -C ~/.local/share/nvim/site/pack/core/opt/<plugin> log --oneline --grep="BREAKING\|refactor!\|breaking" --all`
3. **Edit source** in `home/dot_config/nvim/plugin/00-packs.lua` (pin a `version`) or the sibling `plugin/<plugin>.lua` (adjust setup call). Run `chezmoi diff` then `chezmoi apply`.
4. **Clear compiled cache** if theme-related: `rm -rf ~/.cache/catppuccin`. Catppuccin is the only theme that compiles.
5. **Re-run debug mode** to verify.
6. **Sync lockfile back to source** after a successful run: `cp ~/.config/nvim/nvim-pack-lock.json home/dot_config/nvim/nvim-pack-lock.json`. `vim.pack` writes the destination copy; the source copy is what's committed.

## Mode: `update`

1. Run `:lua vim.pack.update()` in a real Neovim session. It opens a confirm buffer; review the diff and `:write` to apply.
2. Run debug mode to catch breakage.
3. Sync lockfile back to source (see step 6 above).

## Anti-patterns

- **Never** treat this like a LazyVim config. There is no `:Lazy`, no `lua/plugins/`, no `lazy-lock.json`, no `snacks.notifier`. Don't look for upstream LazyVim fixes — there is no upstream distribution.
- **Never** use inline `-c "lua ..."` — shell escaping mangles quotes. Write temp Lua files.
- **Never** edit `~/.config/nvim/` directly — chezmoi owns the destination.
- **Never** ignore lockfile drift — sync the installed lockfile back to source or breakage recurs on the next `chezmoi apply` to a fresh machine.

## Examples

```
/nvim                    → Run debug, report errors
/nvim fix catppuccin     → Fix catppuccin after breaking update
/nvim update             → Update all plugins, debug, sync lockfile
```
