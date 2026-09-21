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

local bottom_terminal_buf = nil

local function toggle_bottom_terminal()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bottom_terminal_buf then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  vim.cmd("botright split")
  vim.cmd("resize 15")

  if bottom_terminal_buf and vim.api.nvim_buf_is_valid(bottom_terminal_buf) then
    vim.api.nvim_win_set_buf(0, bottom_terminal_buf)
  else
    vim.cmd("terminal")
    bottom_terminal_buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd("startinsert")
end

local function open_right_terminal()
  vim.cmd("botright vsplit")
  vim.cmd("vertical resize 60")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>tt", toggle_bottom_terminal, { desc = "Toggle terminal (bottom)" })
vim.keymap.set("n", "<D-j>", toggle_bottom_terminal, { desc = "Toggle terminal (bottom)" })
vim.keymap.set("n", "<leader>tv", open_right_terminal, { desc = "Terminal (right)" })
vim.keymap.set("n", "<leader>tc", "<cmd>close<cr>", { desc = "Close window" })

vim.keymap.set("t", "<C-q>", "<cmd>close<cr>", { desc = "Close Terminal" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal mode" })

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

-- Ghostty rewrites Option+Left/Right to <M-b>/<M-f> and Cmd+Left/Right to
-- <Home>/<End> (dot_config/ghostty/config.tmpl), so those are the maps that
-- fire there; <M-Left>/<D-Left> cover terminals that pass the modifier through.
map("i", "<M-Right>", "<C-o>w", { desc = "Word right" })
map("i", "<M-Left>", "<C-o>b", { desc = "Word left" })
map("i", "<M-f>", "<C-o>w", { desc = "Word right" })
map("i", "<M-b>", "<C-o>b", { desc = "Word left" })
map("i", "<M-BS>", "<C-w>", { desc = "Delete word backward" })
map("n", "<M-Right>", "w", { desc = "Word right" })
map("n", "<M-Left>", "b", { desc = "Word left" })
map("n", "<M-f>", "w", { desc = "Word right" })
map("n", "<M-b>", "b", { desc = "Word left" })
map("v", "<M-Right>", "w", { desc = "Word right" })
map("v", "<M-Left>", "b", { desc = "Word left" })
map("v", "<M-f>", "w", { desc = "Word right" })
map("v", "<M-b>", "b", { desc = "Word left" })
map("i", "<D-Right>", "<C-o>$", { desc = "Line end" })
map("i", "<D-Left>", "<C-o>0", { desc = "Line start" })
map("i", "<C-Right>", "<C-o>$", { desc = "Line end" })
map("i", "<C-Left>", "<C-o>0", { desc = "Line start" })
map("i", "<S-Right>", "<C-o>$", { desc = "Line end" })
map("i", "<S-Left>", "<C-o>0", { desc = "Line start" })
map("i", "<End>", "<C-o>$", { desc = "Line end" })
map("i", "<Home>", "<C-o>0", { desc = "Line start" })
map("n", "<D-Right>", "$", { desc = "Line end" })
map("n", "<D-Left>", "0", { desc = "Line start" })
map("n", "<C-Right>", "$", { desc = "Line end" })
map("n", "<C-Left>", "0", { desc = "Line start" })
map("n", "<S-Right>", "$", { desc = "Line end" })
map("n", "<S-Left>", "0", { desc = "Line start" })
map("n", "<End>", "$", { desc = "Line end" })
map("n", "<Home>", "0", { desc = "Line start" })
map("v", "<D-Right>", "$", { desc = "Line end" })
map("v", "<D-Left>", "0", { desc = "Line start" })
map("v", "<C-Right>", "$", { desc = "Line end" })
map("v", "<C-Left>", "0", { desc = "Line start" })
map("v", "<S-Right>", "$", { desc = "Line end" })
map("v", "<S-Left>", "0", { desc = "Line start" })
map("v", "<End>", "$", { desc = "Line end" })
map("v", "<Home>", "0", { desc = "Line start" })

-- Ghostty sends Cmd+S as the kitty-encoded <D-s>; both keys do the same :write.
map({ "n", "i", "v" }, "<C-s>", "<cmd>silent! write<cr><esc>", { desc = "Save" })
map({ "n", "i", "v" }, "<D-s>", "<cmd>silent! write<cr><esc>", { desc = "Save" })
