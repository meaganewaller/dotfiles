return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  opts = {
    scope = {
      show_start = false,
    },
    indent = {
      char = "│",
      tab_char = "┊",
      smart_indent_cap = true,
    },
    whitespace = {
      remove_blankline_trail = true,
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
  end,
}
