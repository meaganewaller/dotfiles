return {
  "nvimdev/guard.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvimdev/guard-collection" },
  config = function()
    local ft = require("guard.filetype")

    ft("python"):fmt("black")
    ft("lua"):fmt("stylua")

    vim.g.guard_config = {
      fmt_on_save = false,
      lsp_as_default_formatter = true,
    }

    vim.keymap.set({ "n", "v" }, "<space>t", "<cmd>Guard fmt<CR>")
  end,
}

