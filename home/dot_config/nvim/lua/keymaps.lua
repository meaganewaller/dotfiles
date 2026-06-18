local map = vim.keymap.set

local function fugitive(command)
  return function()
    vim.cmd.packadd("vim-fugitive")
    vim.cmd(command)
  end
end

map("i", "jk", "<Esc>", { noremap = true, desc = "Exit insert mode" })

-- Window navigation
map("n", "<C-J>", "<C-W><C-J>", { desc = "Move to the window below" })
map("n", "<C-K>", "<C-W><C-K>", { desc = "Move to the window above" })
map("n", "<C-H>", "<C-W><C-H>", { desc = "Move to the window left" })
map("n", "<C-L>", "<C-W><C-L>", { desc = "Move to the window right" })

-- Clear highlights
map("n", "<C-S>", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

-- Buffer navigation
map("n", "]b", ":bprevious<CR>", { noremap = true, silent = true, desc = "Go to previous buffer" })
map("n", "[b", ":bnext<CR>", { noremap = true, silent = true, desc = "Go to next buffer" })

-- Toggle relative line numbers
map("n", "<leader>r", ":set rnu!<CR>", { noremap = true, silent = true, desc = "Toggle relative line numbers" })

-- %% expands to current file directory
vim.cmd([[cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%']])

map("n", "<leader>gs", fugitive("Git"), { desc = "Git status" })
map("n", "<leader>gb", fugitive("Git blame"), { desc = "Git blame" })
map("n", "<leader>gd", fugitive("Gvdiffsplit"), { desc = "Git diff" })
map("n", "<leader>gw", fugitive("Gwrite"), { desc = "Git stage file" })
map("n", "<leader>gl", fugitive("Git log --oneline --decorate --graph"), { desc = "Git log" })
map("n", "<leader>gc", fugitive("Git commit"), { desc = "Git commit" })
map("n", "<leader>gp", fugitive("Git push"), { desc = "Git push" })
map("n", "<leader>gP", fugitive("Git pull --rebase"), { desc = "Git pull rebase" })
map("n", "<leader>gr", fugitive("Gread"), { desc = "Git restore file" })
