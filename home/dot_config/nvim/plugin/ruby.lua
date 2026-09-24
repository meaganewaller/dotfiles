-- Ruby/Rails editing. Language servers (ruby-lsp, herb) live in
-- plugin/lsp.lua; this file holds the non-LSP pieces.
vim.pack.add({
  -- Adds the matching `end` after def/do/if/class, driven by the treesitter
  -- parse tree rather than regex. Needs no setup call.
  { src = "https://github.com/RRethy/nvim-treesitter-endwise" },
  -- Runs the test under the cursor; detects RSpec and Minitest on its own.
  { src = "https://github.com/vim-test/vim-test" },
})

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "botright 15"

local map = vim.keymap.set
map("n", "<leader>rn", "<cmd>TestNearest<cr>", { desc = "Test nearest" })
map("n", "<leader>rf", "<cmd>TestFile<cr>", { desc = "Test file" })
map("n", "<leader>rs", "<cmd>TestSuite<cr>", { desc = "Test suite" })
map("n", "<leader>rl", "<cmd>TestLast<cr>", { desc = "Test last" })
map("n", "<leader>rv", "<cmd>TestVisit<cr>", { desc = "Visit last test file" })
