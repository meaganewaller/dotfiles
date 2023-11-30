local custom = require "meg.custom"

local which_key_ok, which_key = pcall(require, "which-key")
if which_key_ok then
  which_key.register({
    ["s"] = { name = "+hop" },
    ["["] = { name = "+prev" },
    ["]"] = { name = "+next" },
    ["g"] = { name = "+goto" },
    ["<leader>"] = {
      name = "+<leader>",
      ["<leader>"] = {
        name = "+<leader>"
      },
      ["f"] = {
        name = "+find",
        ["d"] = { name = "+debug" },
      },
      ["g"] = {
        name = "+git",
        ["d"] = { name = "+diffview" },
      },
      ["s"] = {
        name = "+session",
        ["c"] = { name = "+current" },
      },
      ["b"] = {
        name = custom.prefer_tabpage and "+tab" or "+buffer",
        ["s"] = { name = "+sort" },
      },
      ["l"] = {
        name = "+lsp",
        ["w"] = { name = "+workspace" },
      },
      ["i"] = { name = "+insert" },
      ["m"] = { name = "+manage" },
      ["r"] = { name = "+tasks" },
      ["d"] = { name = "+debug" },
      ["t"] = { name = "+toggle" },
      ["h"] = { name = "+helper" },
      ["q"] = { name = "+quickfix" },
    },
  })
end

local function toggle_quickfix()
  local wins = vim.fn.getwininfo()
  local qf_win = vim
    .iter(wins)
    :filter(function(win)
      return win.quickfix == 1
    end)
    :totable()
  if #qf_win == 0 then
    vim.cmd.copen()
  else
    vim.cmd.cclose()
  end
end

vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>tq", toggle_quickfix, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>hi", function()
  vim.show_pos()
end, { desc = "Inspect" })
vim.keymap.set("n", "<leader>ht", function()
  vim.treesitter.inspect_tree()
end, { desc = "Treesitter Tree" })
vim.keymap.set("n", "<leader>hq", function()
  vim.treesitter.query.edit()
end, { desc = "Treesitter Query" })

-- Provided by nvim-next
-- vim.keymap.set("n", "[q", "<Cmd>cprevious<CR>", {})
-- vim.keymap.set("n", "]q", "<Cmd>cnext<CR>", {})

local filetype_keymaps = vim.api.nvim_create_augroup("meaganewaller_filetype_keymaps", {})
vim.api.nvim_create_autocmd("Filetype", {
  group = filetype_keymaps,
  pattern = "qf",
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set("n", "q", "<Cmd>cclose<CR>", { buffer = bufnr })
  end,
})
