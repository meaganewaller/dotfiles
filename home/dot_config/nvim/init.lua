-- Entry point. Files under plugin/ are auto-sourced by Neovim after this
-- runs, so this module only handles bootstrap that must happen first.
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.expandtab = true
opt.smartindent = true

opt.wrap = true
opt.linebreak = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.scrolloff = 8
opt.signcolumn = "yes"

opt.updatetime = 50
opt.colorcolumn = "80"

opt.cursorline = true

opt.termguicolors = true
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard = "unnamedplus"

opt.splitright = true
opt.splitbelow = true
opt.path:append("**") -- makes :find search recursively from the cwd

opt.iskeyword:append("-")
opt.shortmess:append("I")
opt.title = true
opt.titlestring = "%<%F - nvim"

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

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
