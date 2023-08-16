--[[
┌┐┌┌─┐┌─┐┬  ┬┬┌┬┐
│││├┤ │ │└┐┌┘││││
┘└┘└─┘└─┘ └┘ ┴┴ ┴
# Author: Meagan Waller
# Github: github.com/meaganwaller
# Dotfiles Repo: github.com/meaganewaller/dotfiles
# Last edited: August 16th, 2023
--]]

-- bootstrap lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

if not vim.g.vscode then
  local neovim = require("meg.client.neovim")
  neovim.setup()

  local options = {}
  require("lazy").setup("meg.plugins", options)
  neovim.activate_theme()
  neovim.configure_mappings()
  neovim.configure_lsp()
else
  local vscode = require("meg.client.vscode")
  vscode.configure()

  local options = {
    root = vim.fn.stdpath("data") .. "/lazy-vscode",
    lockfile = vim.fn.stdpath("config") .. "/lazy-vscode-lock.json",
  }

  require("lazy").setup(vscode.packages(), options)
end



---- set leader to space
---- set localleader to comma
---- this needs to occur before initializing lazy
--vim.g.mapleader = " "
--vim.g.maplocalleader = ","
--
--_G.mw = {
--  ui = require("meg.ui"),
--  theme = vim.env.SYSTEM_THEME or "rose-pine",
--  mappings = {},
--  local_config = {
--    dir = ".nvim",
--    file = "init.local.lua",
--    palettes_dir = "palettes",
--    palette_file = "palette.json",
--    spell_dir = "spell",
--    vale_dir = "styles/Vocab/Project",
--    vale_file = ".vale.ini",
--    prettier_file = ".prettierrc",
--    templates = vim.fn.stdpath("config") .. "/templates",
--  },
--  loading_error_msg = function(plugin_name)
--    vim.notify(plugin_name, "ERROR", { title = "Loading failed" })
--  end,
--}
--
--Homedir = os.getenv("HOME")
--Sessiondir = vim.fn.stdpath("data") .. "/sessions"
--
--require("meg.utils")
---- require("meg.options")
--require("meg")
---- require("meg.keymaps")
