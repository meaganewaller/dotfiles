-- Entry point. Files under plugin/ are auto-sourced by Neovim after this
-- runs, so this module only handles bootstrap that must happen first.
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.clipboard = "unnamedplus"
opt.scrolloff = 6
opt.splitright = true
opt.splitbelow = true
opt.path:append("**") -- makes :find search recursively from the cwd

opt.shortmess:append("I")
opt.title = true
opt.titlestring = "%<%F - nvim"

-- Puts this directory's lua/ on the module path even when Neovim is
-- pointed straight at the repo source (e.g. `nvim -u home/dot_config/nvim/init.lua`)
-- rather than the chezmoi-applied ~/.config/nvim.
local this = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("<sfile>:p")), ":h")

vim.opt.runtimepath:prepend(this)
package.path = table.concat({
  this .. "/lua/?.lua",
  this .. "/lua/?/init.lua",
  package.path,
}, ";")
