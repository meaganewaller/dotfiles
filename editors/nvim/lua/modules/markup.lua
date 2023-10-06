return {
  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function() require("configs.vimtex") end,
  },
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    build = "cd app && npm install",
    ft = "markdown",
    cmd = { "MarkdownPreview" },
  },
  {
    "chrisbra/csv.vim",
    lazy = true,
    ft = "csv",
  },
  {
    "kiran94/edit-markdown-table.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "EditMarkdownTable",
  },
  "rhysd/vim-grammarous",
}
