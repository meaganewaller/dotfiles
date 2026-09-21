-- Documentation popup under the mouse, like VSCode: hover a symbol,
-- the LSP (language server protocol) doc shows up. Independent of mode and cursor position.
--
-- Single manager: two sources open popups (the mouse here, and keyboard
-- hover on CursorHold). Without shared cleanup, they'd stack up.

local M = {}

local DELAY_MS = 250

local timer = nil
local float_win = nil
local last_pos = nil

local enabled = true
local suspended = true

-- Escape closes it, but moves neither cursor nor mouse: CursorHold re-arms
-- and reopens the same popup a second later. We remember the rejected spot
-- and stay quiet there until it actually moves.
local rejected_cursor = nil
local rejected_mouse = nil

local function cursor_key()
  local pos = vim.api.nvim_win_get_cursor(0)
  return vim.api.nvim_get_current_buf() .. ":" .. pos[1] .. ":" .. pos[2]
end

local function mouse_key()
  local pos = vim.fn.getmousepos()
  return pos.winid .. ":" .. pos.line .. ":" .. pos.column
end

local function is_floating(win)
  return win ~= nil and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative ~= ""
end

-- Closes any documentation popup still on screen, wherever it came from.
-- The safety net: sweep floating windows carrying an LSP preview buffer,
-- since an orphaned popup is no longer tracked by anyone.
local function close_all()
  local closed = false

  -- the window may have closed itself and its id gotten recycled by a
  -- normal window: closing it then would kill a real split
  if is_floating(float_win) then
    pcall(vim.api.nvim_win_close, float_win, true)
    closed = true
  end
  float_win = nil

  -- vim.lsp.util.open_floating_preview stores its window id here
  local tracked = vim.b.lsp_floating_preview
  if is_floating(tracked) then
    pcall(vim.api.nvim_win_close, tracked, true)
    closed = true
  end
  vim.b.lsp_floating_preview = nil

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_floating(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local ok, marked = pcall(vim.api.nvim_buf_get_var, buf, "lsp_floating_preview_source")
      if ok and marked then
        pcall(vim.api.nvim_win_close, win, true)
        closed = true
      end
    end
  end

  return closed
end

-- Remote navigation is not user intent to open documentation.
function M.suspend_until_input()
  suspended = true
  close_all()
end

-- anchor = "mouse" (mouse hover) or "cursor" (cursor at rest)
local function show(buf, line, column, anchor)
  if suspended then
    return
  end
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(buf) },
    position = { line = line, character = column },
  }

  vim.lsp.buf_request(buf, "textDocument/hover", params, function(err, result)
    if suspended or err or not result or not result.contents then
      return
    end
    local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    lines = vim.split(table.concat(lines, "\n"), "\n", { trimempty = true })
    if #lines == 0 then
      return
    end

    close_all()

    -- focusable: a click inside enters it instead of passing through to the buffer.
    -- BufLeave is excluded, otherwise entering the popup would close it right away.
    local fbuf, win = vim.lsp.util.open_floating_preview(lines, "markdown", {
      relative = anchor or "mouse",
      focusable = true,
      border = "rounded",
      max_width = 90,
      max_height = 20,
      close_events = { "InsertCharPre", "WinScrolled" },
    })
    float_win = win
    pcall(vim.api.nvim_buf_set_var, fbuf, "lsp_floating_preview_source", true)

    -- The preview is filetype markdown, so LazyVim's wrap_spell autocmd turns the
    -- spell checker on and underlines every symbol name in red. This is API doc,
    -- not prose.
    pcall(function()
      vim.wo[win].spell = false
    end)

    -- Neovim only installs "q" in its popups, never Escape (issue #27288).
    -- Buffer-local: a global mapping gets overridden by plugins.
    for _, lhs in ipairs({ "<Esc>", "q" }) do
      vim.keymap.set("n", lhs, function()
        M.close_all_popups()
      end, { buffer = fbuf, nowait = true, desc = "Close the popup" })
    end

    -- Click or jump outside the popup: it closes instead of staying in the way.
    -- Definitely not "once": entering the popup already fires a WinLeave on
    -- the editor, which would consume the autocommand before we leave it.
    local watcher
    watcher = vim.api.nvim_create_autocmd({ "WinLeave", "WinClosed" }, {
      callback = function()
        if not is_floating(win) then
          pcall(vim.api.nvim_del_autocmd, watcher)
          if float_win == win then
            float_win = nil
          end
          return
        end
        if vim.api.nvim_get_current_win() ~= win then
          return
        end
        vim.schedule(function()
          if is_floating(win) and vim.api.nvim_get_current_win() ~= win then
            pcall(vim.api.nvim_win_close, win, true)
          end
          if float_win == win then
            float_win = nil
          end
          pcall(vim.api.nvim_del_autocmd, watcher)
        end)
      end,
    })
  end)
end

local function mouse_over_popup()
  return is_floating(float_win) and vim.fn.getmousepos().winid == float_win
end

function M.is_popup_open()
  return is_floating(float_win)
end

-- Closes everything and gives focus back to the window we came from if we were in it.
-- Returns true if something was closed, so Escape keeps its role otherwise.
function M.close_all_popups()
  local current = vim.api.nvim_get_current_win()
  if is_floating(current) then
    local previous = vim.fn.win_getid(vim.fn.winnr("#"))
    if previous ~= 0 and previous ~= current and vim.api.nvim_win_is_valid(previous) then
      vim.api.nvim_set_current_win(previous)
    end
  end

  last_pos = nil
  rejected_cursor = cursor_key()
  rejected_mouse = mouse_key()
  return close_all()
end

function M.on_hover()
  if not enabled then
    return
  end

  local pos = vim.fn.getmousepos()

  -- mouse over the popup itself: keep it, we're here to read or select it
  if mouse_over_popup() then
    return
  end

  if pos.winid == 0 or pos.line == 0 or pos.column == 0 then
    close_all()
    last_pos = nil
    return
  end

  local key = pos.winid .. ":" .. pos.line .. ":" .. pos.column
  if key == last_pos then
    return
  end
  if key == rejected_mouse then
    return
  end
  rejected_mouse = nil
  last_pos = key
  close_all()

  if timer then
    timer:stop()
  end

  local ok, buf = pcall(vim.api.nvim_win_get_buf, pos.winid)
  if not ok or vim.bo[buf].buftype ~= "" then
    return
  end

  local supported = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if client:supports_method("textDocument/hover") then
      supported = true
      break
    end
  end
  if not supported then
    return
  end

  timer = vim.defer_fn(function()
    -- the mouse moved in the meantime: the request is no longer worth anything
    if last_pos == key then
      show(buf, pos.line - 1, pos.column - 1, "mouse")
    end
  end, DELAY_MS)
end

-- Keyboard hover: same popup, same marking, so Escape closes it too.
-- vim.lsp.buf.hover used to open a window this module couldn't find again.
function M.on_rest()
  if not enabled then
    return
  end
  if vim.bo.buftype ~= "" or vim.fn.mode() ~= "n" then
    return
  end
  if is_floating(vim.api.nvim_get_current_win()) then
    return
  end
  if cursor_key() == rejected_cursor then
    return
  end
  rejected_cursor = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_floating(win) then
      return
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if client:supports_method("textDocument/hover") then
      local pos = vim.api.nvim_win_get_cursor(0)
      show(buf, pos[1] - 1, pos[2], "cursor")
      return
    end
  end
end

function M.setup()
  vim.o.mousemoveevent = true
  vim.on_key(function(_, typed)
    if typed and typed ~= "" then
      suspended = false
    end
  end, vim.api.nvim_create_namespace("hover-mouse-input"))
  vim.api.nvim_create_autocmd("FocusLost", {
    group = vim.api.nvim_create_augroup("hover-mouse-focus", { clear = true }),
    callback = M.suspend_until_input,
  })
  vim.keymap.set({ "n", "i" }, "<MouseMove>", function()
    M.on_hover()
    return "<Ignore>"
  end, { expr = true, desc = "LSP hover under the mouse" })

  vim.api.nvim_create_user_command("ToggleHover", function()
    enabled = not enabled
    if not enabled then
      close_all()
    end
    rejected_cursor = nil
    rejected_mouse = nil
    vim.notify("Hover popups " .. (enabled and "on" or "off"))
  end, { desc = "Toggle LSP hover popups (mouse and cursor)" })
end

return M
