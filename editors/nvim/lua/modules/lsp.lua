return {
  { "nvim-lua/lsp-status.nvim" },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    cmd = { "LspInfo", "LspStart" },
    config = function() require("configs.nvim-lspconfig") end,
    keys = {
      { "<Leader>li", "<cmd>LspInfo<CR>", desc = "lsp: Server information" },
      { "<Leader>lr", "<cmd>LspRestart<CR>", desc = "lsp: Restart server" },
      { "<Leader>ls", "<cmd>LspStart<CR>", desc = "lsp: Start server" },
      { "<Leader>lp", "<cmd>LspStop<CR>", desc = "lsp: Stop server" },
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

  { "ekalinin/Dockerfile.vim" },
  { "cespare/vim-toml" },
  { "mtdl9/vim-log-highlighting" },
  { "folke/neodev.nvim" },
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
