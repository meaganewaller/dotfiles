-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = "zsh"
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.inccommand = "split"
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"
vim.opt.mouse = "a"

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

vim.g.mapleader = " "

vim.opt.expandtab = true
vim.opt.grepprg = "rg --vimgrep --smart-case --"
vim.opt.hidden = true
vim.opt.shortmess:append({ W = true, I = true, c = true })
vim.opt.showmode = false -- dont show mode since we have a statusline
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.listchars = "trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂"
vim.opt.pumblend = 10

vim.g.os = vim.uv.os_uname().sysname
vim.g.fps = vim.g.os == "Darwin" and 120 or 160
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand("~/.dotfiles")
vim.g.vim_dir = vim.g.dotfiles .. "/.config/nvim"

--  ╭─────────────────╮
--  │ Default plugins │
--  ╰─────────────────╯
-- Stop loading built in plugins
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.logipat = 1

-- Disable some extension providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup("vimrc", {})

vim.opt.backup = true
vim.opt.swapfile  = false
vim.opt.cmdheight = 0
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

if vim.g.neovide then
  vim.opt.guifont = "Menlo,Symbols Nerd Font Mono:h10"
  vim.g.neovide_scale_factor = 0.3
end

vim.o.title = true
vim.o.titlestring = LazyVim.root.cwd():match("([^/]+)$")

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.deprecation_warnings = true
vim.g.ai_cmp = false
vim.g.lazyvim_blink_main = true

for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen.
vim.opt.signcolumn = "yes"

-- disable some fancy UI stuff when run in Neovide
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_floating_blur_amount_x = 0.0
  vim.g.neovide_floating_blur_amount_y = 0.0
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_window_blurred = true

  vim.opt.guifont = "MonaspiceKr Nerd Font Mono:h13"
  vim.cmd([[nnoremap <ScrollWheelRight> <Nop>]])
  vim.cmd([[nnoremap <ScrollWheelLeft> <Nop>]])
  vim.cmd([[nnoremap <S-ScrollWheelUp> <ScrollWheelRight>]])
  vim.cmd([[nnoremap <S-ScrollWheelDown> <ScrollWheelLeft>]])
end
