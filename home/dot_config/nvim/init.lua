-- Entry point. Files under plugin/ are auto-sourced by Neovim after this
-- runs, so this module only handles bootstrap that must happen first.

-- Free <Space> in normal and visual mode so it can be used as a prefix
-- for our keymaps (init.lua loads before plugin/*.lua).
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Neovim still respects mapleader for any built-in or third-party code
-- that consults it. Mirror our prefix so behaviour is consistent.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
