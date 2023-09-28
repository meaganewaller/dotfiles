-- Define mappings for Ruby block selection
vim.api.nvim_set_keymap(
  "o",
  "ar",
  '<cmd>lua require("ruby_block").select_block("a", false)<cr>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "x",
  "ar",
  '<cmd>lua require("ruby_block").select_block("a", true)<cr>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "o",
  "ir",
  '<cmd>lua require("ruby_block").select_block("i", false)<cr>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "x",
  "ir",
  '<cmd>lua require("ruby_block").select_block("i", true)<cr>',
  { noremap = true, silent = true }
)
