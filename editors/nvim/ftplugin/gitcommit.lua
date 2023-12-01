local function setup_buffer()
  vim.bo.textwidth = 72
  return nil
end

local function bind()
  vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })
end

local function autocmd()
  local g = require("meg.git")
  local augroup = g['augroup']
  local layout_triple, layout_double = g['layout_triple'], g['layout_double']

  vim.api.nvim_create_autocmd(
    { "VimEnter" },
    {
      group = augroup,
      pattern = { "COMMIT_EDITMSG" },
      callback = layout_triple,
    }
  )

  vim.api.nvim_create_autocmd(
    { "VimEnter" },
    {
      group = augroup,
      pattern = { "TAG_EDITMSG" },
      callback = layout_double(true, true)
    }
  )

  vim.api.nvim_create_autocmd(
    { "VimEnter" },
    {
      group = augroup,
      pattern = { "MERGE_MSG" },
      callback = layout_double(false, false)
    }
  )
end
bind()
autocmd()

local group = vim.api.nvim_create_augroup("git-commit-buf-enter", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", { callback = setup_buffer, buffer = 0, group = group })

vim.cmd("setlocal spell")
vim.cmd("setlocal linebreak")
vim.cmd("setlocal nolist")
vim.cmd("setlocal wrap")
vim.cmd("setlocal expandtab")
vim.cmd("setlocal textwidth=72")

-- Break undo sequences into chunks (after punctuation); see: `:h i_CTRL-G_u`
-- https://twitter.com/vimgifs/status/913390282242232320
vim.keymap.set({ 'i' }, '.', '.<c-g>u', { buffer = true })
vim.keymap.set({ 'i' }, '?', '?<c-g>u', { buffer = true })
vim.keymap.set({ 'i' }, '!', '!<c-g>u', { buffer = true })
vim.keymap.set({ 'i' }, ',', ',<c-g>u', { buffer = true })
vim.opt.colorcolumn = { 50, 72 }

return nil
