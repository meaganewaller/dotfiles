local M = {}

function M.setup()
  require("meg.settings").setup()
end

function M.activate_theme()
  local settings = require("meg.settings")
  local theme = settings.theme

  local themes = require("meg.theming.themes")

  themes.activate_theme(theme.name, theme.style, theme.transparent)
end

function M.configure_mappings()
  require("meg.mappings").setup()
end

function M.configure_lsp()
  require("meg.language").setup()
end

return M
