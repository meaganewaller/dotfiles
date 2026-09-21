-- Mouse in the completion menu, VSCode-style: wheel to scroll through
-- suggestions, click to pick one. blink.cmp has no mouse support at all.

local M = {}

local function is_menu_open()
  local ok, cmp = pcall(require, "blink.cmp")
  return ok and cmp.is_menu_visible(), cmp
end

local function menu_window()
  local ok, menu = pcall(require, "blink.cmp.completion.windows.menu")
  if not ok or not menu.win:is_open() then
    return nil
  end
  return menu.win:get_win()
end

--- The wheel scrolls through suggestions instead of scrolling the text.
--- @param direction "next"|"prev"
local function on_wheel(direction)
  local is_open, cmp = is_menu_open()
  if not is_open then
    -- menu closed: wheel goes back to its normal role
    return direction == "next" and "<ScrollWheelDown>" or "<ScrollWheelUp>"
  end
  if direction == "next" then
    cmp.select_next()
  else
    cmp.select_prev()
  end
  return "<Ignore>"
end

--- A click in the menu picks the pointed-at line and inserts it.
local function on_click()
  local win = menu_window()
  if not win then
    return "<LeftMouse>"
  end

  local pos = vim.fn.getmousepos()
  if pos.winid ~= win then
    return "<LeftMouse>"
  end

  local ok, cmp = pcall(require, "blink.cmp")
  if not ok then
    return "<LeftMouse>"
  end

  -- getmousepos gives the line within the window, blink indexes its items the same way
  local list = require("blink.cmp.completion.list")
  vim.schedule(function()
    if list.select(pos.line, { is_explicit_selection = true }) ~= false then
      cmp.accept()
    end
  end)
  return "<Ignore>"
end

function M.setup()
  local opts = { expr = true, silent = true }

  vim.keymap.set("i", "<ScrollWheelDown>", function()
    return on_wheel("next")
  end, vim.tbl_extend("force", opts, { desc = "Next suggestion" }))

  vim.keymap.set("i", "<ScrollWheelUp>", function()
    return on_wheel("prev")
  end, vim.tbl_extend("force", opts, { desc = "Previous suggestion" }))

  vim.keymap.set("i", "<LeftMouse>", on_click, vim.tbl_extend("force", opts, { desc = "Pick suggestion" }))
end

return M
