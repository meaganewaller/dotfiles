# Neovim Configuration

This dotfiles repository ships a Neovim configuration built directly on top of
Neovim's own primitives — no framework, no plugin-manager DSL. Plugins are
fetched and managed with [`vim.pack`](https://neovim.io/doc/user/pack.html)
(built in to Neovim 0.12+), LSP is wired up with the native
`vim.lsp.config` / `vim.lsp.enable` API (0.11+), and config is split into
ordinary Lua modules.

## Overview

- **Plugin manager**: `vim.pack` (built in)
- **Completion**: [`blink.cmp`](https://github.com/Saghen/blink.cmp)
- **Picker**: [`fzf-lua`](https://github.com/ibhagwan/fzf-lua)
- **File tree**: [`oil.nvim`](https://github.com/stevearc/oil.nvim)
- **Marks / quick switch**: [`harpoon`](https://github.com/ThePrimeagen/harpoon) (`harpoon2` branch)
- **Git**: [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) + [`vim-fugitive`](https://github.com/tpope/vim-fugitive)
- **Statusline**: [`lualine`](https://github.com/nvim-lualine/lualine.nvim) + `nvim-web-devicons`
- **Keymap hints**: [`which-key.nvim`](https://github.com/folke/which-key.nvim)
- **Syntax**: [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch)
- **Colorschemes**: a curated set with a runtime fzf-lua picker (default: `catppuccin-mocha`)
- **Configuration location**: `home/dot_config/nvim/`

LSP servers come from `PATH` — install them with `mise` or your system
package manager. There is no Mason equivalent in this config.

## Directory structure

```
home/dot_config/nvim/
├── init.lua                       # bootstrap: leader keys, then require() each module
├── nvim-pack-lock.json            # vim.pack revision pins (committed)
├── lua/
│   ├── options.lua                # editing options (indent, search, undo, wildmenu, …)
│   ├── ui.lua                     # UI options + custom tabline
│   ├── window.lua                 # <Space>w window splits / navigation / resize
│   ├── keymaps.lua                # top-level keymaps (<leader>g git, etc.)
│   ├── autocmds.lua               # yank highlight, trim trailing whitespace
│   ├── picker/
│   │   ├── init.lua               # fzf-lua setup
│   │   └── keymaps.lua            # <leader>f… find / grep / theme picker
│   ├── theme/
│   │   ├── init.lua               # managed colorscheme list + apply helpers
│   │   └── light.lua              # (placeholder)
│   └── utils/                     # tiny helpers (functions, icons, remaps)
└── plugin/                        # auto-sourced by Neovim after init.lua
    ├── 00-packs.lua               # vim.pack.add(specs) + stale-plugin pruning
    ├── blink.lua                  # completion config
    ├── gitsigns.lua
    ├── harpoon.lua
    ├── lsp.lua                    # vim.lsp.config + LspAttach keymaps
    ├── lualine.lua
    ├── oil.lua                    # <leader>e to open
    ├── picker.lua                 # → require("picker")
    ├── theme.lua                  # → require("theme")
    ├── treesitter.lua             # install + start parsers
    └── whichkey.lua
```

Two conventions worth knowing:

- **Files in `lua/` are loaded explicitly** from `init.lua` via `require()`,
  so the bootstrap order is deterministic.
- **Files in `plugin/` are auto-sourced by Neovim** after `init.lua` finishes.
  The `00-` prefix on `00-packs.lua` guarantees plugins are added before any
  other plugin-config file runs.

## How plugins are managed

`plugin/00-packs.lua` declares the plugin set as a list of `vim.pack` specs:

```lua
local specs = {
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.0") },
  "https://github.com/ibhagwan/fzf-lua",
  -- …
}

-- Prune anything previously installed that's no longer in `specs`.
local wanted = {}
for _, spec in ipairs(specs) do wanted[spec_name(spec)] = true end
for _, plugin in ipairs(vim.pack.get()) do
  if not wanted[plugin.spec.name] then table.insert(stale, plugin.spec.name) end
end
if #stale > 0 then vim.pack.del(stale) end

vim.pack.add(specs)
```

That's the whole plugin manager. `vim.pack` writes pinned revisions to
`nvim-pack-lock.json` alongside `init.lua` — that file is committed so other
machines (and `chezmoi apply`) reproduce the same plugin versions. Plugin
sources themselves live under `stdpath("data")`.

### Adding a plugin

1. Append a spec to the `specs` table in `plugin/00-packs.lua`.
2. If the plugin needs setup, add a sibling `plugin/<name>.lua` that calls
   `require("...").setup(...)` and any keymaps. It will be auto-sourced on the
   next launch.

### Removing a plugin

Delete its entry from `specs` (and any sibling `plugin/<name>.lua`). The next
launch will detect it's stale and call `vim.pack.del()` to remove it.

### Updating

`:lua vim.pack.update()` — or restart Neovim and let it pull updates as part
of `vim.pack.add()`.

## LSP

`plugin/lsp.lua` uses the native API — no `nvim-lspconfig`, no Mason. Each
server config is gated on the binary being present in `PATH`:

```lua
for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
  end
end
```

Currently wired: `lua_ls`, `rust_analyzer`, `ts_ls`, `gopls`. Add new servers
by extending the `servers` table and installing the binary (typically via
`mise use -g <tool>@<version>`).

Buffer-local keymaps are attached via `LspAttach`:

| Map | Action |
| --- | --- |
| `gd` / `gD` | Definition / declaration |
| `gr` / `gi` | References / implementation |
| `K` | Hover |
| `<Space>lr` | Rename |
| `<Space>la` | Code action |
| `<Space>lf` | Format (async) |
| `<Space>ld` | Line diagnostics float |
| `[d` / `]d` | Prev / next diagnostic |

## Keymaps

`<leader>` is `<Space>`. `<localleader>` is also `<Space>`. (Note: `options.lua`
also sets `vim.g.mapleader = ","` for historical reasons — the `<Space>` in
`init.lua` wins because it runs first.)

### Finding things — `<leader>f…` (fzf-lua)

| Map | Action |
| --- | --- |
| `<leader>ff` | Files |
| `<leader>fr` | Recent files |
| `<leader>fc` | Config files (`stdpath("config")`) |
| `<leader>fg` | Live grep |
| `<leader>fs` / `<leader>fS` | Grep word / WORD under cursor |
| `<leader>fk` | Keymaps |
| `<leader>fh` | Help tags |
| `<leader>fd` | Workspace diagnostics |
| `<leader>fb` | Buffers |
| `<leader>fu` | Undo tree |
| `<leader>ft` | Theme picker (live-preview managed colorschemes) |

### Git — `<leader>g…` (vim-fugitive, lazy-loaded)

| Map | Action |
| --- | --- |
| `<leader>gs` | `:Git` (status) |
| `<leader>gb` | `:Git blame` |
| `<leader>gd` | `:Gvdiffsplit` |
| `<leader>gw` | `:Gwrite` (stage current file) |
| `<leader>gl` | `:Git log --oneline --decorate --graph` |
| `<leader>gc` | `:Git commit` |
| `<leader>gp` / `<leader>gP` | Push / pull --rebase |
| `<leader>gr` | `:Gread` (restore file) |

`gitsigns` shows hunk markers in the sign column and inline blame on the
current line.

### Files / windows / other

| Map | Action |
| --- | --- |
| `<leader>e` | Open `oil` |
| `<leader>a` | Harpoon: add file |
| `<C-e>` | Harpoon: toggle quick menu |
| `<Space>ws` / `wv` | Split horizontal / vertical |
| `<Space>wc` / `wo` | Close / only |
| `<Space>w=` / `wm` | Equalize / maximize |
| `<C-Up/Down/Left/Right>` | Resize current window |
| `<Esc>` (normal) | Clear search highlight |
| `<C-f>` | `tmux-sessionizer.sh` in a new tmux window |

> ⚠️ `<C-h/j/k/l>` is bound in **two** places: `lua/window.lua` maps it to
> `<C-w>h/j/k/l` (window navigation), and `plugin/harpoon.lua` maps it to
> `harpoon:list():select(1..4)`. `plugin/` runs after `init.lua`, so harpoon
> wins. If you want tmux-aware navigation back, rework one of those bindings.

## Themes

The colorscheme picker (`<leader>ft`) is restricted to a curated list in
`lua/theme/init.lua`. The default is `catppuccin-mocha`. The picker forces
`background=dark` and ignores `ColorScheme` events fired by itself so live
preview doesn't loop.

To add or remove themes, edit `managed_themes` in `lua/theme/init.lua` and
make sure the corresponding plugin is in `plugin/00-packs.lua`.

## Common workflows

| Task | Command |
| --- | --- |
| Update plugins | `:lua vim.pack.update()` |
| Inspect installed plugins | `:lua = vim.pack.get()` |
| Remove stale plugins | Restart Neovim (handled by `00-packs.lua`) |
| Reinstall treesitter parsers | `:TSUpdate` (triggered automatically on plugin change) |
| LSP info | `:lua = vim.lsp.get_clients()` |
| LSP log | `:LspLog` |
| Health check | `:checkhealth` |

## Tmux integration

`<C-f>` opens a fresh tmux window running `tmux-sessionizer.sh`. There is no
`vim-tmux-navigator` plugin in this config — see the harpoon caveat above
about `<C-h/j/k/l>`.

## Troubleshooting

- **A plugin won't install** — `:lua = vim.pack.get()` shows the current
  state; `:lua vim.pack.update()` re-runs the fetch.
- **Treesitter parser is missing** — `tree-sitter` CLI must be on `PATH`
  (install via `mise`). `plugin/treesitter.lua` emits a notification if it
  can't build a parser.
- **LSP server didn't start** — make sure the binary in `servers[name].cmd[1]`
  is on `PATH`. The config silently skips servers whose binary is missing.
- **Theme didn't apply on launch** — check that the plugin for that theme is
  declared in `plugin/00-packs.lua` and that the spec name matches what
  `lua/theme/init.lua` is calling.
