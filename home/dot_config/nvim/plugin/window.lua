-- Window splits, navigation, and resizing under the <Space>w prefix.

local map = vim.keymap.set

-- Split management.
map("n", "<Space>ws", "<cmd>split<CR>", { desc = "Window: horizontal split" })
map("n", "<Space>wv", "<cmd>vsplit<CR>", { desc = "Window: vertical split" })
map("n", "<Space>wc", "<cmd>close<CR>", { desc = "Window: close" })
map("n", "<Space>wo", "<cmd>only<CR>", { desc = "Window: only (close others)" })
map("n", "<Space>w=", "<C-w>=", { desc = "Window: equalize" })
map("n", "<Space>wm", "<cmd>resize | vertical resize<CR>", { desc = "Window: maximize" })

-- Direct navigation. Works alongside any tmux-navigator-style plugin
-- later because we only bind the unmapped <C-h/j/k/l> in normal mode.
map("n", "<C-h>", "<C-w>h", { desc = "Window: go left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window: go down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window: go up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window: go right" })

-- Resize with arrow keys.
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Window: grow vertically" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Window: shrink vertically" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Window: shrink horizontally" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Window: grow horizontally" })
