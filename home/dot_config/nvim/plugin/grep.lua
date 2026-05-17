-- Native :grep wired to ripgrep, plus a small wrapper that prompts for
-- a pattern and opens the quickfix list with results.

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --glob '!.git'"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

local function run_grep(pattern)
  if not pattern or pattern == "" then return end
  vim.cmd("silent! grep! " .. vim.fn.shellescape(pattern))
  local results = vim.fn.getqflist()
  if #results == 0 then
    vim.notify("grep: no matches for " .. pattern, vim.log.levels.INFO)
  else
    vim.cmd.copen()
  end
end

vim.api.nvim_create_user_command("Grep", function(opts)
  run_grep(opts.args)
end, { nargs = "+", complete = "file", desc = "Run grepprg and open quickfix" })

vim.keymap.set("n", "<Space>/", function()
  vim.ui.input({ prompt = "Grep: " }, run_grep)
end, { desc = "Grep: prompt and search" })

vim.keymap.set("n", "<Space>*", function()
  run_grep(vim.fn.expand("<cword>"))
end, { desc = "Grep: word under cursor" })

-- Quickfix navigation that complements grep results.
local map = vim.keymap.set
map("n", "<Space>cn", "<cmd>cnext<CR>", { desc = "Quickfix: next" })
map("n", "<Space>cp", "<cmd>cprev<CR>", { desc = "Quickfix: previous" })
map("n", "<Space>co", "<cmd>copen<CR>", { desc = "Quickfix: open" })
map("n", "<Space>cc", "<cmd>cclose<CR>", { desc = "Quickfix: close" })
