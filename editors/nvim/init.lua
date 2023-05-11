--      __  ________________    ________  ___
--     /  |/  / ____/ ____/ |  / /  _/  |/  /
--    / /|_/ / __/ / / __ | | / // // /|_/ /
--   / /  / / /___/ /_/ / | |/ // // /  / /
--  /_/  /_/_____/\____/  |___/___/_/  /_/
--
--  Author: https://github.com/meaganewaller
--  GitHub: https://github.com/meaganewaller/.dotfiles/editors/nvim
--  Last Updated: 2023-05-11

local vim = vim

if vim.loader then
  vim.loader.enable()
end

vim.g.enabled_plugin = {
  breadcrumb = false,
  mappings = false,
  autocmds = false,
  megline = false,
  megcolumn = false,
  lsp = false,
  term = false,
  repls = false,
  cursorline = false,
  colorcolumn = false,
  windows = false,
  numbers = false,
  quickfix = false,
  folds = false,
  env = false,
  tmux = false,
  dim = false,
  vscode = false,
  winbar = false,
}

for plugin, _ in pairs(vim.g.enabled_plugin) do
  if not vim.tbl_contains({ "autocmds", "mappings", "quickfix" }, plugin) and vim.g.started_by_firenvim then
    vim.g.enabled_plugin[plugin] = false
  end
end

vim.g.colorscheme = "catppuccin"
vim.g.default_colorcolumn = "81"
vim.g.mapleader = ","
vim.g.maplocalleader = " "
vim.g.notifier_enabled = true
vim.g.debug_enabled = false
vim.g.picker = "telescope"
vim.g.tree = "neo-tree"

_G.meg = meg
  or {
    ui = {},
    fn = {},
    fzf = {},
    dirs = {},
    mappings = {},
    term = {},
    lsp = {},
    icons = require("meg.icons"),
    ts_ignored_langs = { "svg", "json", "heex", "jsonc" },
    notify = vim.notify,
  }

require("meg.globals")
require("meg.debug")
require("meg.options")
require("meg.plugins")
require("meg.mappings")
require("meg.event")

meg.pcall("theme failed to load because", function(colorscheme)
  local theme = fmt("meg.lush_theme.%s", colorscheme)
  local ok, lush_theme = pcall(require, theme)
  if ok then
    vim.g.colors_name = colorscheme
    package.loaded[theme] = nil

    require("lush")(lush_theme)
  else
    vim.cmd.colorscheme(colorscheme)
  end

  meg.colors = require("meg.lush_theme.colors")
end, vim.g.colorscheme)
