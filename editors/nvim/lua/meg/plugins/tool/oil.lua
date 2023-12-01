local custom = require "meg.custom"

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function(_, opts)
    require("oil").setup(opts)

    local map = require("meg.utils").map
    map("n", "-", "<cmd>Oil --float<CR>", "Open parent directory")
  end,
  opts = {
    show_hidden = true,
    columns = {
      "icon",
      "size",
    },
    skip_confirm_for_simple_edits = true,
    cleanup_delay_ms = false,
    float = {
      border = custom.border,
    },
    preview = {
      border = custom.border,
    },
    progress = {
      border = custom.border,
    },
  },
}
