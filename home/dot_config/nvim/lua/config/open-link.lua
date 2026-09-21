-- Cmd+Enter: opens the URL under the cursor in the browser, otherwise jumps
-- to the symbol definition. Also works in the LSP documentation popup,
-- where rust-analyzer puts its links (Rust by Example, docs.rs...).

local M = {}

local URL_PATTERN = "%f[%w](https?://[%w-_%.%?%.:/%+=&~@#%%]+)"

--- Looks for a URL on the line, preferring the one that contains the cursor.
--- @return string|nil
local function url_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local from = 1
  local first = nil
  while true do
    local s, e, url = line:find(URL_PATTERN, from)
    if not s then
      break
    end
    first = first or url
    if col >= s and col <= e then
      return url
    end
    from = e + 1
  end

  -- cursor isn't on it but the line has one anyway: good enough
  return first
end

--- In a markdown popup, links are written [text](url).
--- @return string|nil
local function markdown_url()
  local line = vim.api.nvim_get_current_line()
  return line:match("%]%((https?://[^%)]+)%)")
end

function M.open()
  local url = url_under_cursor() or markdown_url()
  if url then
    vim.ui.open(url)
    return
  end

  if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
    vim.lsp.buf.definition()
  end
end

function M.setup()
  -- <D-CR> needs Ghostty's `super+enter=unbind` and Nvim talking CSI u to it
  -- directly; tmux (extended-keys off) drops the Cmd modifier. <M-CR> is left
  -- Option+Enter, which works anywhere thanks to macos-option-as-alt = left.
  vim.keymap.set("n", "<D-CR>", M.open, { desc = "Open the URL or go to definition" })
  vim.keymap.set("n", "<M-CR>", M.open, { desc = "Open the URL or go to definition" })
end

return M
