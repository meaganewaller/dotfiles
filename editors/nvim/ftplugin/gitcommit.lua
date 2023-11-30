vim.cmd("setlocal spell")

local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = 0,
  silent = true,
  noremap = true,
  nowait = true,
}

local map = require("meg.utils").map

map("n", "<C-,>", "1z=", "Shortcut for spell check", opts)
