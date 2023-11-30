local M = {
  "brenoprata10/nvim-highlight-colors",
  event = "VeryLazy",
}

M.config = function()
  local utils = require("meg.utils")
  local colorizer = require("nvim-highlight-colors")

  colorizer.setup({})
  utils.which_key("<Leader>tc", "Colorizer")
  utils.noremap("n", "<Leader>tc", function() colorizer.toggle() end, "Toggle Colorizer")
end

return M
