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

local function ensure_default_theme()
  local default_theme = "catppuccin-mocha"
  apply_theme(default_theme)
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
