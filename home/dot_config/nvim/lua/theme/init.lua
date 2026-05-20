local managed_themes = {
  "afterglow",
  "boo",
  "catppuccin-mocha",
  "citruszest",
  "evangelion",
  "evergarden",
  "gruvbox",
  "kanagawa-wave",
  "melange",
  "miasma",
  "neverland",
  "nightfox",
  "onedark",
  "rose-pine-moon",
  "tokyonight",
  "tokyonight-storm",
  "vague",
  "yugen",
}

local managed_theme_set = {}
for _, theme_name in ipairs(managed_themes) do
  managed_theme_set[theme_name] = true
end

local M = {}
local picker_active = false

local function apply_theme(theme_name)
  if not theme_name or theme_name == "" then
    return false
  end

  vim.o.background = "dark"
  local ok = pcall(vim.cmd.colorscheme, theme_name)
  return ok
end

-- Resolve the active theme from the universal switcher's state file.
-- See docs/adrs/0005-universal-theme-switcher.md.
local function read_state_theme()
  local state = (vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")) .. "/theme/nvim"
  local f = io.open(state, "r")
  if not f then
    return nil
  end
  local line = f:read("l")
  f:close()
  if not line then
    return nil
  end
  line = line:gsub("%s+$", "")
  if line == "" then
    return nil
  end
  return line
end

local function ensure_default_theme()
  local theme = read_state_theme() or "catppuccin-mocha"
  apply_theme(theme)
end

ensure_default_theme()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    if picker_active then
      return
    end

    local theme_name = args.match
    if not theme_name or theme_name == "" then
      return
    end

    if not managed_theme_set[theme_name] then
      return
    end
  end,
})

M.set_picker_active = function(active)
  picker_active = active
end

M.get_managed_themes = function()
  return vim.deepcopy(managed_themes)
end

M.apply_managed_theme = function(theme_name)
  if not managed_theme_set[theme_name] then
    return false
  end

  return apply_theme(theme_name)
end

M.enforce_dark_background = function()
  vim.o.background = "dark"
end

return M
