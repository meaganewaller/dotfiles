return {
  {
    "otavioschwanck/ruby-toolkit.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
    ft = { "ruby" },
    keys = {
      {
        "<leader>rv",
        "<cmd>lua require('ruby-toolkit').extract_variable()<CR>",
        desc = "Extract Variable",
        mode = { "v" },
      },
      {
        "<leader>rf",
        "<cmd>lua require('ruby-toolkit').extract_to_function()<CR>",
        desc = "Extract To Function",
        mode = { "v" },
      },
      {
        "<leader>rf",
        "<cmd>lua require('ruby-toolkit').create_function_from_text()<CR>",
        desc = "Create Function from item on cursor",
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local mappings = {
        { "gsa", desc = "Add surrounding", mode = { "n", "v" } },
        { "gsd", desc = "Delete surrounding" },
        { "gsf", desc = "Find right surrounding" },
        { "gsF", desc = "Find left surrounding" },
        { "gsh", desc = "Highlight surrounding" },
        { "gsr", desc = "Replace surrounding" },
        { "gsn", desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
        suffix_last = "l",
        suffix_next = "n",
      },
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  {
    "elijahmanor/export-to-vscode.nvim",
    keys = {
      -- stylua: ignore
      { "<leader>code", function() require("export-to-vscode").launch() end, desc = "Export to VS Code" },
    },
  },
}
