-- bootstrap lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- set leader to space
-- this needs to occur before initializing lazy
vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.mw = {}

require("meg")

-- require("lazy").setup("meg.plugins", {
--   debug = false,
--   defaults = { lazy = true },
--   checker = { enabled = false },
--   diff = {
--     cmd = "terminal_git",
--   },
--   rtp = {
--     disabled_plugins = {
--       "gzip",
--       "zip",
--       "zipPlugin",
--       "tar",
--       "tarPlugin",
--       "getscript",
--       "getscriptPlugin",
--       "vimball",
--       "vimballPlugin",
--       "2html_plugin",
--       "logipat",
--       "rrhelper",
--       "spellfile_plugin",
--       "matchit",
--       "tutor_mode_plugin",
--       "remote_plugins",
--       "shada_plugin",
--       "filetype",
--       "spellfile",
--       "tohtml",
--     },
--   },
-- })
