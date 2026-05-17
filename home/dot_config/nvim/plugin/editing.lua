-- Editing behaviour: indentation, search, completion, small keymaps.

local o = vim.opt

o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.shiftround = true
o.smartindent = true
o.autoindent = true

o.ignorecase = true
o.smartcase = true
o.inccommand = "split"
o.hlsearch = true
o.incsearch = true

o.completeopt = { "menu", "menuone", "noselect", "popup" }
o.wildmode = { "longest:full", "full" }
o.wildoptions = "pum"

o.virtualedit = "block"
o.formatoptions:remove({ "c", "r", "o" })

-- Keep the cursor centered when jumping through search results / pages.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Hold the yanked register when pasting over a visual selection.
vim.keymap.set("x", "p", [["_dP]])

-- Clear search highlights.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quick save / quit using <Space> as prefix.
vim.keymap.set("n", "<Space>w", "<cmd>write<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<Space>q", "<cmd>quit<CR>", { desc = "Quit window" })
vim.keymap.set("n", "<Space>Q", "<cmd>quitall<CR>", { desc = "Quit all" })

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})
