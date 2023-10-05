return {
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
    event = "VeryLazy",
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
}
