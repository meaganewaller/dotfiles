local custom = require "meg.custom"

return {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    window = {
      border = custom.border,
      size = {
        height = "60%",
        width = "80%",
      },
    },
    icons = custom.icons.kind_with_space,
    lsp = {
      auto_attach = true,
    },
  },
  init = function()
    local map = require("meg.utils").map

    map("n", "<Leader>n", function()
      require("nvim-navbuddy").open()
    end, "Open Navigator (navbuddy)")
  end,
}
