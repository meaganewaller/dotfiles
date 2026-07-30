-- Window management: split lifecycle + a hand-rolled zoom toggle (native
-- Neovim has no single "maximize this window" command), plus smart-splits
-- for tmux-aware navigation/resizing.
--
-- home/dot_config/tmux/tmux.conf already binds unprefixed C-h/j/k/l to
-- forward to Neovim when the focused pane is running vim (the classic
-- vim-tmux-navigator `is_vim` trick), falling back to `select-pane`
-- otherwise. That only gets a keypress into Neovim -- it doesn't know
-- whether Neovim itself is at the edge of its own splits. smart-splits'
-- move/resize functions close that loop: they act like <C-w>hjkl inside
-- Neovim, and when the cursor doesn't move (already at Neovim's edge),
-- they shell out to tmux themselves to cross into the adjacent pane.
vim.pack.add({
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
})

local smart_splits = require("smart-splits")
smart_splits.setup({
  ignored_filetypes = { "nofile", "quickfix", "prompt" },
  ignored_buftypes = { "nofile" },
})

local map = vim.keymap.set

-- Move across splits, crossing into tmux at the edge.
map("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Window: move left" })
map("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Window: move down" })
map("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Window: move up" })
map("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Window: move right" })

-- Resize the current split, same tmux-crossing behavior at the edge.
map("n", "<A-h>", smart_splits.resize_left, { desc = "Window: resize left" })
map("n", "<A-j>", smart_splits.resize_down, { desc = "Window: resize down" })
map("n", "<A-k>", smart_splits.resize_up, { desc = "Window: resize up" })
map("n", "<A-l>", smart_splits.resize_right, { desc = "Window: resize right" })

-- Split lifecycle. `s`/`v` mirror :h CTRL-W's own mnemonics (horizontal /
-- vertical) rather than inventing new ones.
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

-- Zoom toggle: grow the current window to fill the tab, then restore equal
-- sizes on a second press. `wincmd |`/`wincmd _` already exist natively;
-- this just adds the toggle-back half.
local zoomed = false
map("n", "<leader>wm", function()
  if zoomed then
    vim.cmd("wincmd =")
  else
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
  end
  zoomed = not zoomed
end, { desc = "Toggle window zoom" })
