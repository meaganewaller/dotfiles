-- Built-in terminal: open helpers and ergonomic insert-mode escapes.

local map = vim.keymap.set

-- Escape terminal mode without remapping <Esc> inside TUIs we run there.
map("t", "<C-\\><C-n>", "<C-\\><C-n>", { desc = "Terminal: to normal mode" })
map("t", "<C-w>h", [[<C-\><C-n><C-w>h]], { desc = "Terminal: window left" })
map("t", "<C-w>j", [[<C-\><C-n><C-w>j]], { desc = "Terminal: window down" })
map("t", "<C-w>k", [[<C-\><C-n><C-w>k]], { desc = "Terminal: window up" })
map("t", "<C-w>l", [[<C-\><C-n><C-w>l]], { desc = "Terminal: window right" })

-- Open a shell in a split or new tab.
map("n", "<Space>'", function()
  vim.cmd.split()
  vim.cmd.terminal()
  vim.cmd.startinsert()
end, { desc = "Terminal: horizontal split" })

map("n", "<Space>\"", function()
  vim.cmd.vsplit()
  vim.cmd.terminal()
  vim.cmd.startinsert()
end, { desc = "Terminal: vertical split" })

-- In a terminal buffer, drop signcolumn/numbers and enter insert mode.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("terminal_open", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd.startinsert()
  end,
})
