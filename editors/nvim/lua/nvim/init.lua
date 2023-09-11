local M = {}

function M.setup()
  require("config").setup()
end

function M.activate_theme()
  local theme = BrioVim.theme

  local themes = require("config.themes")

  themes.activate_theme(theme.name, theme.style, theme.transparent)
end

function M.configure_mappings()
  require('config.mappings').setup()
end

function M.configure_lsp()
  require('language').setup()
end

return M
