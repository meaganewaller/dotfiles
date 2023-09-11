--[[
┌┐┌┌─┐┌─┐┬  ┬┬┌┬┐
│││├┤ │ │└┐┌┘││││
┘└┘└─┘└─┘ └┘ ┴┴ ┴
# Author: Meagan Waller
# Github: github.com/meaganwaller
# Dotfiles Repo: github.com/meaganewaller/dotfiles
# Last edited: September 11th, 2023
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

require('config.BrioVim')
require('utils.globals')
require('utils.functions')

require('config.options')
require('config.lazy')

local config = require('nvim')
config.activate_theme()
config.configure_mappings()
config.configure_lsp()

-- if not vim.g.vscode then
--   local neovim = require("meg.client.neovim")
--   neovim.setup()
--
--   local options = {}
--   require("lazy").setup("meg.plugins", options)
--   neovim.activate_theme()
--   neovim.configure_mappings()
--   neovim.configure_lsp()
-- else
--   local vscode = require("meg.client.vscode")
--   vscode.configure()
--
--   local options = {
--     root = vim.fn.stdpath("data") .. "/lazy-vscode",
--     lockfile = vim.fn.stdpath("config") .. "/lazy-vscode-lock.json",
--   }
--
--   require("lazy").setup(vscode.packages(), options)
-- end
