return {
  -- extend auto completion
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      })
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "comment",
          "css",
          "diff",
          "dockerfile",
          "dot",
          "fish",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "gitignore",
          "graphql",
          "graphql",
          "hcl",
          "html",
          "http",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "jsonc",
          "just",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "mermaid",
          "python",
          "query",
          "regex",
          "rust",
          "scss",
          "sql",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "xml",
          "yaml",
        })
      end
    end,
  },
}
