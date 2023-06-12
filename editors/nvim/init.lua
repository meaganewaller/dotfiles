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

_G.mw = {}

require("meg")
