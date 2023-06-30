--[[
┌┐┌┌─┐┌─┐┬  ┬┬┌┬┐
│││├┤ │ │└┐┌┘││││
┘└┘└─┘└─┘ └┘ ┴┴ ┴
# Author: Meagan Waller
# Github: github.com/meaganwaller
# Dotfiles Repo: github.com/meaganewaller/dots
# Last edited: June 29, 2023
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

-- set leader to space
-- set localleader to comma
-- this needs to occur before initializing lazy
vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.mw = {
  ui = require("meg.ui"),
  theme = vim.env.SYSTEM_THEME or "rose-pine",
  mappings = {},
  loading_error_msg = function(plugin_name)
    vim.notify(plugin_name, "ERROR", { title = "Loading failed" })
  end,
}

require("meg")
