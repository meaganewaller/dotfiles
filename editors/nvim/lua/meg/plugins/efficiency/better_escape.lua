return {
  "max397574/better-escape.nvim",
  event = "InsertEnter",
  config = function()
    require("better_escape").setup({
      mapping = { "jk", "jj" },
      timeout = vim.o.timeoutlen,
      clear_empty_lines = false,
      keys = "<Esc>",
    })
  end,
}
