-- Minimal git integration. The heavy lifting lives in lazygit and the
-- shell; this module just makes those a keystroke away from the buffer
-- you're already editing, plus a tiny blame-line helper that shells
-- out instead of pulling in a full plugin.

local map = vim.keymap.set

local function open_lazygit()
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("git: lazygit not on PATH", vim.log.levels.WARN)
    return
  end
  vim.cmd.tabnew()
  vim.cmd("terminal lazygit")
  vim.cmd.startinsert()
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    once = true,
    callback = function() vim.cmd.tabclose() end,
  })
end

local function blame_line()
  local file = vim.fn.expand("%:p")
  if file == "" then return end
  local line = vim.fn.line(".")
  local cmd = string.format("git -C %s blame -L %d,%d --date=short -- %s",
    vim.fn.shellescape(vim.fn.expand("%:p:h")),
    line, line,
    vim.fn.shellescape(file))
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("git blame failed: " .. out, vim.log.levels.WARN)
    return
  end
  vim.notify(vim.trim(out), vim.log.levels.INFO, { title = "git blame" })
end

map("n", "<Space>gg", open_lazygit, { desc = "Git: lazygit" })
map("n", "<Space>gb", blame_line, { desc = "Git: blame line" })
