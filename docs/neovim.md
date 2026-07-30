# Neovim Configuration

This dotfiles repository ships a Neovim configuration built directly on top of
Neovim's own primitives — no framework, no plugin-manager DSL. Plugins are
fetched and managed with [`vim.pack`](https://neovim.io/doc/user/pack.html)
(built in to Neovim 0.12+), LSP is wired up with the native
`vim.lsp.config` / `vim.lsp.enable` API (0.11+), and config is split into
ordinary Lua modules.

## Overview

- **Plugin manager**: `vim.pack` (built in), declared per-plugin — see
  [How plugins are managed](#how-plugins-are-managed)
- **Completion**: [`blink.cmp`](https://github.com/Saghen/blink.cmp)
- **Picker**: [`fzf-lua`](https://github.com/ibhagwan/fzf-lua)
- **File explorer**: [`oil.nvim`](https://github.com/stevearc/oil.nvim) (`-` to open)
- **Git**: [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) (hunk stage/reset/preview, inline blame)
- **Statusline**: [`lualine`](https://github.com/nvim-lualine/lualine.nvim) + `nvim-web-devicons`
- **Keymap hints**: [`which-key.nvim`](https://github.com/folke/which-key.nvim)
- **Syntax**: [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) (default branch, no version pin)
- **Colorschemes**: a curated set with a runtime fzf-lua picker (default: `catppuccin-mocha`)
- **Windows**: hand-rolled split/zoom keymaps + [`smart-splits.nvim`](https://github.com/mrjones2014/smart-splits.nvim) for tmux-aware move/resize (see the Keymaps and Tmux integration sections below)
- **Claude Code observability**: `onlooker` — a custom in-repo plugin (`lua/onlooker/`) for watching and steering Claude Code sessions from inside Neovim; see [Onlooker](#onlooker)
- **Configuration location**: `home/dot_config/nvim/`

LSP servers come from `PATH` — install them with `mise` or your system
package manager. There is no Mason equivalent in this config.

There is still **no harpoon and no vim-fugitive** in this config. Window
management is covered below — it isn't a gap anymore.

## Directory structure

```
home/dot_config/nvim/
├── init.lua                       # bootstrap: options, leader keys, runtimepath/package.path shims
├── nvim-pack-lock.json            # vim.pack revision pins (committed)
├── lua/
│   ├── theme/
│   │   ├── init.lua               # managed colorscheme list + apply helpers
│   │   └── light.lua              # (placeholder)
│   └── onlooker/                  # Claude Code observability plugin (dashboard, feed,
│                                   # digest, dispatch, takeover, queue, cleanup, ...)
└── plugin/                        # auto-sourced by Neovim after init.lua, alphabetically
    ├── colorschemes.lua           # vim.pack.add for every installed colorscheme
    ├── completion.lua             # blink.cmp setup + advertises capabilities to LSP
    ├── explorer.lua               # oil.nvim, `-` to open
    ├── finder.lua                 # fzf-lua setup + <leader>f… keymaps
    ├── git.lua                    # gitsigns setup + <leader>h… keymaps
    ├── lsp.lua                    # vim.lsp.config servers + LspAttach keymaps
    ├── onlooker.lua                # require("onlooker").setup()
    ├── statusline.lua             # lualine + nvim-web-devicons
    ├── theme.lua                  # require("theme") — applies the saved/default colorscheme
    ├── treesitter.lua             # parser install list + auto-start on FileType
    ├── whichkey.lua               # which-key setup + leader group labels
    └── window.lua                 # split lifecycle, zoom toggle, smart-splits (tmux-aware move/resize)
```

Two conventions worth knowing:

- **Files in `lua/` are loaded explicitly** via `require()` (from `init.lua`,
  `plugin/onlooker.lua`, or `plugin/theme.lua`), so load order for those is
  deterministic.
- **Files in `plugin/` are auto-sourced by Neovim** after `init.lua` finishes,
  in alphabetical order. `colorschemes.lua` sorts before `theme.lua` so the
  colorscheme plugins are on `runtimepath` before `theme.lua`'s `:colorscheme`
  call runs.

## How plugins are managed

There is no central plugin-spec list. Each `plugin/<name>.lua` file declares
its own plugins right where it uses them:

```lua
-- plugin/explorer.lua
vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup()

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil" })
```

`vim.pack` writes pinned revisions to `nvim-pack-lock.json` alongside
`init.lua` — that file is committed so other machines (and `chezmoi apply`)
reproduce the same plugin versions. Plugin sources themselves live under
`stdpath("data")`.

`plugin/colorschemes.lua` is the one exception with multiple specs in a single
file, since every colorscheme shares the same "just make it available on
runtimepath" setup — there's nothing per-theme to configure.

### Adding a plugin

1. Create (or reuse) a `plugin/<name>.lua` file.
2. Call `vim.pack.add({ { src = "..." } })`, then `require("...").setup(...)`
   and any keymaps it needs. It's auto-sourced on the next launch.

### Removing a plugin

Delete its `plugin/<name>.lua` file (and any `require()` of it elsewhere).
Unlike some `vim.pack` setups, **there is no automatic stale-plugin pruning**
here — the plugin stays installed on disk until you explicitly run
`:lua vim.pack.del({"plugin-repo-name"})`, or check `:lua =vim.pack.get()` for
anything no longer referenced by a `plugin/*.lua` file.

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

Currently wired: `lua_ls`, `ts_ls`, `gopls`, `clangd`, `jsonls`, `yamlls`,
`bashls`, `fish_lsp`, `tailwindcss`, `marksman`, `tombi`, `terraformls`,
`texlab`, `dockerls`, `sqls`, `harper_ls`, `biome`, `ruff`, `ty`. Add new
servers by extending the `servers` table in `plugin/lsp.lua` and installing
the binary (typically via `mise use -g <tool>@<version>`).

Neovim's own LSP/diagnostic defaults already cover rename, references, code
action, hover, and signature help (see `:h lsp-defaults` and
`:h diagnostic-defaults`). This config only adds the gaps on top of those,
via `LspAttach`:

| Map | Action |
| --- | --- |
| `gd` | Definition |
| `gD` | Declaration |
| `<leader>lf` | Format (async) |
| `<leader>lq` | Diagnostics to location list |

`jsonls` and `yamlls` also pull schemas from
[`schemastore.nvim`](https://github.com/b0o/schemastore.nvim).

## Keymaps

`<leader>` and `<localleader>` are both `<Space>`, set once in `init.lua`.

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

### Git hunks — `<leader>h…` (gitsigns)

| Map | Action |
| --- | --- |
| `]c` / `[c` | Next / previous hunk (falls back to native `]c`/`[c` in diff mode) |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk |
| `<leader>hS` / `<leader>hR` | Stage / reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hd` | Diff this |
| `<leader>tb` | Toggle current-line blame |
| `ih` (operator/visual) | Hunk text object |

### Onlooker — `<leader>o…` (Claude Code observability)

| Map | Action |
| --- | --- |
| `<leader>oo` | Open the session dashboard |
| `<leader>of` | Open the live feed for a session |
| `<leader>od` | Open the Q&A digest for a session |
| `<leader>on` | Dispatch a new agent in the current directory |
| `<leader>ot` | Take over a dispatched session's TUI |
| `<leader>om` | Queue a message into a dispatched session |
| `<leader>ox` | Clean up idle, detached dispatched sessions |

See [Onlooker](#onlooker) for what these actually do.

### Windows — `<leader>w…` / smart-splits

| Map | Action |
| --- | --- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to the split left/down/up/right, crossing into the adjacent tmux pane at the edge |
| `<A-h>` / `<A-j>` / `<A-k>` / `<A-l>` | Resize the current split in that direction, same tmux-crossing behavior |
| `<leader>ws` / `<leader>wv` | Split horizontal / vertical (mirrors `:h CTRL-W`'s own `s`/`v`) |
| `<leader>wc` | Close window |
| `<leader>wo` | Close other windows |
| `<leader>w=` | Equalize windows |
| `<leader>wm` | Toggle zoom (grow to fill the tab, press again to restore) |

See the Tmux integration section below for how the tmux-crossing behavior
actually works.

### Files / other

| Map | Action |
| --- | --- |
| `-` | Open `oil` |

No clear-search-highlight mapping exists in this config today (there's no
default one either — you'd need to add your own `<Esc>` → `:nohlsearch`).

## Themes

The colorscheme picker (`<leader>ft`) is restricted to a curated list in
`lua/theme/init.lua`. The default is `catppuccin-mocha`, but on startup
`lua/theme/init.lua` reads `$XDG_STATE_HOME/theme/nvim` (falling back to
`~/.local/state/theme/nvim`) and applies whatever the universal `theme`
switcher last set there (see
[ADR 0005](adrs/0005-universal-theme-switcher.md)) before falling back to the
default. The picker forces `background=dark` and ignores `ColorScheme` events
fired by itself so live preview doesn't loop.

To add or remove themes, edit `managed_themes` in `lua/theme/init.lua` **and**
add/remove the matching `vim.pack.add` entry in `plugin/colorschemes.lua`.

## Onlooker

`lua/onlooker/` is a custom, in-repo plugin (not a fetched dependency) for
observing and steering Claude Code sessions without leaving Neovim. Per its
own header comment:

> Observation (dashboard/feed/digest) is lossless and non-invasive — it only
> tails the `.jsonl` transcripts Claude Code already writes under
> `~/.claude/projects`, for every session it finds, whether or not onlooker
> started it. Steering (dispatch/takeover/queue/cleanup) only ever touches
> sessions onlooker itself dispatched as terminal jobs: it writes to its own
> child's pty, never reaches into another process.

`plugin/onlooker.lua` calls `require("onlooker").setup()` with the defaults in
`lua/onlooker/config.lua`:

| Option | Default | Meaning |
| --- | --- | --- |
| `claude_bin` | `"claude"` | Binary used for dispatched sessions |
| `projects_root` | `~/.claude/projects` | Where transcripts are tailed from |
| `poll_ms` | `750` | Live feed/digest re-check interval |
| `scan_ms` | `4000` | Dashboard re-scan interval |
| `active_window_seconds` | `120` | Transcript-write recency to count a session "active" |
| `idle_cleanup_minutes` | `45` | Idle threshold before a dispatched session is a cleanup candidate |
| `max_tail_bytes` | `65536` | How much transcript tail to read for dashboard previews |

It exposes both user commands (`:OnlookerDashboard`, `:OnlookerFeed`,
`:OnlookerDigest`, `:OnlookerDispatch [prompt]`, `:OnlookerTakeover`,
`:OnlookerQueue`, `:OnlookerCleanup`) and the `<leader>o…` keymaps above.
Internals (`dashboard.lua`, `feed.lua`, `digest.lua`, `dispatch.lua`,
`takeover.lua`, `queue.lua`, `cleanup.lua`, plus supporting
`discover`/`registry`/`render`/`transcript`/`live_view` modules) live under
`lua/onlooker/` — read those directly for implementation detail; this doc only
covers the surface.

## Tmux integration

`home/dot_config/tmux/tmux.conf` binds unprefixed `C-h`/`C-j`/`C-k`/`C-l` at
the tmux level using the classic `vim-tmux-navigator` `is_vim` check: if the
focused pane is running vim/nvim it forwards the raw keys through, otherwise
it moves tmux panes directly. That only gets the keypress into Neovim —
tmux has no idea whether Neovim is at the edge of its own split layout.

`plugin/window.lua`'s smart-splits keymaps close that loop: they act like
`<C-w>hjkl` inside Neovim, and when the cursor doesn't move (already at
Neovim's outermost split), smart-splits shells out to tmux itself to select
the adjacent pane. The two halves — tmux's `is_vim` forwarding and
smart-splits' edge detection — only work together; neither alone crosses the
tmux/Neovim boundary. The `<A-h/j/k/l>` resize keymaps use the same
edge-detection to resize the adjacent tmux pane once Neovim has nothing left
to shrink or grow.

## Common workflows

| Task | Command |
| --- | --- |
| Update plugins | `:lua vim.pack.update()` |
| Inspect installed plugins | `:lua =vim.pack.get()` |
| Remove a plugin's files from disk | `:lua vim.pack.del({"name"})` after deleting its `plugin/*.lua` (no auto-prune — see [Removing a plugin](#removing-a-plugin)) |
| Reinstall treesitter parsers | `:TSUpdate` |
| LSP info | `:lua =vim.lsp.get_clients()` |
| LSP log | `:LspLog` |
| Health check | `:checkhealth` |

## Troubleshooting

- **A plugin won't install** — `:lua =vim.pack.get()` shows the current
  state; `:lua vim.pack.update()` re-runs the fetch.
- **Treesitter parser is missing** — `tree-sitter` CLI must be on `PATH`
  (install via `mise`). `plugin/treesitter.lua` emits a notification if it
  can't build a parser.
- **LSP server didn't start** — make sure the binary in `servers[name].cmd[1]`
  is on `PATH` (see the server list in `plugin/lsp.lua`). The config silently
  skips servers whose binary is missing.
- **Theme didn't apply on launch** — check that the plugin for that theme is
  declared in `plugin/colorschemes.lua` and that the spec name matches what
  `lua/theme/init.lua`'s `managed_themes` list expects; also check
  `~/.local/state/theme/nvim` for a stale value.
- **Onlooker command does nothing** — it only sees sessions writing to
  `~/.claude/projects`; confirm `claude_bin` resolves and that a transcript is
  actually being written for the session you expect.
