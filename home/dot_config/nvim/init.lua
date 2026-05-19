-- Entry point. Files under plugin/ are auto-sourced by Neovim after this
-- runs, so this module only handles bootstrap that must happen first.
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("ui")
require("window")
require("keymaps")
require("autocmds")
