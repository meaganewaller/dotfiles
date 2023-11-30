return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  },
  cmd = { "TroubleToggle", "Trouble" },
  config = function()
    require("trouble").setup({
      auto_fold = false,
      fold_open = " ",
      fold_closed = " ",
      height = 6,
      indent_str = " ┊   ",
      include_declaration = {
        "lsp_references",
        "lsp_implementations",
        "lsp_definitions"
      },
      mode = "workspace_diagnostics",
      multiline = true,
      padding = false,
      position = "bottom",
      severity = nil,
      signs = require("meg.custom").icons.diagnostics,
      use_diagnostic_signs = true,
    })

    local noremap = require("meg.utils").noremap
    noremap("n", "<leader>lr", "<cmd>TroubleToggle lsp_reference<cr>", "lsp references")
    noremap("n", "<leader>le", "<cmd>TroubleToggle document_diagnostics<cr>", "diagnostics")
    noremap("n", "<leader>t", function()
      require("lsp_lines").toggle()
      vim.cmd [[TroubleToggle workspace_diagnostics]]
    end, "toggle trouble  ")
  end,
}
