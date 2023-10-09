return {
  "folke/neodev.nvim",
  { "ray-x/lsp_signature.nvim" },
  {
    "Maan2003/lsp_lines.nvim",
    keys = {
      { "<Leader>ll", "<cmd>LspLinesToggle<CR>", desc = "Toggle LSP lines plugin" },
    },
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      vim.api.nvim_create_user_command(
      "LspLinesToggle",
      require("lsp_lines").toggle,
      { desc = "Toggle lsp_lines.nvim plugin" }
      )
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    cmd = { "LspInfo", "LspStart" },
    config = function() require("configs.nvim-lspconfig") end,
    keys = {
      { "<Leader>li", "<cmd>LspInfo<CR>", desc = "LSP Server information" },
      { "<Leader>lr", "<cmd>LspRestart<CR>", desc = "Restart LSP server" },
      { "<Leader>ls", "<cmd>LspStart<CR>", desc = "Start LSP server" },
      { "<Leader>lp", "<cmd>LspStop<CR>", desc = "Stop LSP server" },
    },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("configs.conform") end,
  },

  {
    "dnlhc/glance.nvim",
    event = "LspAttach",
    config = function() require("configs.glance") end,
  },

  {
    "hrsh7th/nvim-gtd",
    config = function() require("configs.gtd") end,
  },

  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    keys = {
      -- stylua: ignore
      { "<leader>lc", "<cmd>CodeActionMenu<cr>", desc = "Code Action Menu" },
    },
  },
}
