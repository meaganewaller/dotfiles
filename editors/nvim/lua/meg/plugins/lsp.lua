return {
  "neovim/nvim-lspconfig",
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  "onsails/lspkind-nvim",
  "ray-x/lsp_signature.nvim",
  "nvimdev/lspsaga.nvim",
  "pmizio/typescript-tools.nvim",
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },
}
