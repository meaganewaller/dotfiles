local M = {
  "brenoprata10/nvim-highlight-colors",
  event = "VeryLazy",
}

M.config = function()
  local utils = require("meg.utils")
  local colorizer = require("nvim-highlight-colors")

  colorizer.setup({})
  utils.map("n", "<Leader>tC", function() colorize.toggle() end, "Toggle colorizer")
end

return M
