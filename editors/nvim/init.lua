--[[
┌┐┌┌─┐┌─┐┬  ┬┬┌┬┐
│││├┤ │ │└┐┌┘││││
┘└┘└─┘└─┘ └┘ ┴┴ ┴
# Author: Meagan Waller
# Github: github.com/meaganwaller
# Dotfiles Repo: github.com/meaganewaller/dotfiles
# Last edited: October 4th, 2023
--]]

-- Compile lua to bytecode if the nvim version supports it.
if vim.loader and vim.fn.has("nvim-0.9.1") == 1 then vim.loader.enable() end

-- bootstrap lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.fn.resolve(lazypath) then
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
  local nvim = require("client.neovim")
  nvim.setup()

  nvim.activate_plugins()
  nvim.activate_theme()
  nvim.configure_projectionist()
else
  local vscode = require("client.vscode")
  vscode.configure()

  local options = {
    root = vim.fn.stdpath("data") .. "/lazy-vscode",
    lockfile = vim.fn.stdpath("config") .. "/lazy-vscode-lock.json",
  }

  require("lazy").setup(vscode.packages(), options)
end
