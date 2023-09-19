local M = {}

function M.setup()
  require("settings").setup()
end

function M.activate_theme()
  local settings = require("settings")
  local theme = settings.theme

  local themes = require('theming.themes')

  themes.activate_theme(theme.name, theme.style, theme.transparent)
end

function M.configure_mappings()
  require("mappings")
end

-- function M.configure_lsp()
--   require("lsp").setup()
-- end

return M
