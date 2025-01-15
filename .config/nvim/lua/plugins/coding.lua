return {
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = {
      filetypes = { ["*"] = true },
    },
  },
  { "wakatime/vim-wakatime", event = "VeryLazy" },
  {
    "bennypowers/nvim-regexplainer",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter", "MunifTanjim/nui.nvim" },
    config = true,
    opts = {
      mappings = {
        toggle = "ge",
      },
    },
  },

  {
    "~p00f/godbolt.nvim",
    url = "https://git.sr.ht/~p00f/godbolt.nvim",
    cmd = { "Godbolt", "GodboltCompiler" },
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.o.mps = vim.o.mps .. ',<:>,":"'
    end,
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

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
