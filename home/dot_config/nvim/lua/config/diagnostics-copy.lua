-- Copies diagnostics to the clipboard as path:line:col: SEVERITY: message
-- lines, ready to paste into an issue, a chat, or an agent prompt.

local M = {}

local LABEL = {
  [vim.diagnostic.severity.ERROR] = "ERROR",
  [vim.diagnostic.severity.WARN] = "WARN",
  [vim.diagnostic.severity.INFO] = "INFO",
  [vim.diagnostic.severity.HINT] = "HINT",
}

local function relative_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[No Name]"
  end
  return vim.fn.fnamemodify(name, ":.")
end

local function format_line(d)
  return string.format(
    "%s:%d:%d: %s: %s%s",
    relative_path(d.bufnr),
    d.lnum + 1,
    d.col + 1,
    LABEL[d.severity] or "?",
    (d.message or ""):gsub("%s+$", ""),
    d.source and (" [" .. d.source .. "]") or ""
  )
end

-- bufnr nil = whole project, 0 = current file
function M.copy(bufnr, min_severity)
  local opts = min_severity and { severity = { min = min_severity } } or nil
  local diags = vim.diagnostic.get(bufnr, opts)
  if #diags == 0 then
    vim.notify("No diagnostics to copy")
    return
  end

  table.sort(diags, function(a, b)
    local pa, pb = relative_path(a.bufnr), relative_path(b.bufnr)
    if pa ~= pb then
      return pa < pb
    end
    return a.lnum < b.lnum
  end)

  local lines = vim.tbl_map(format_line, diags)
  local text = table.concat(lines, "\n")
  vim.fn.setreg("+", text)
  vim.notify(#diags .. " diagnostics copied to clipboard")
end

function M.setup()
  vim.api.nvim_create_user_command("DiagCopy", function()
    M.copy(nil)
  end, { desc = "Copy project diagnostics" })

  vim.api.nvim_create_user_command("DiagCopyBuf", function()
    M.copy(0)
  end, { desc = "Copy current file diagnostics" })

  vim.api.nvim_create_user_command("DiagCopyErrors", function()
    M.copy(nil, vim.diagnostic.severity.ERROR)
  end, { desc = "Copy project errors" })

  vim.keymap.set("n", "<leader>xy", function()
    M.copy(nil)
  end, { desc = "Copy diagnostics (project)" })

  vim.keymap.set("n", "<leader>xY", function()
    M.copy(0)
  end, { desc = "Copy diagnostics (file)" })
end

return M
