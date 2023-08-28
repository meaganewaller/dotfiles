return {
  {
    "junegunn/fzf.vim",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "voldikss/vim-floaterm",
    event = "VeryLazy",
  },
  { "ThePrimeagen/harpoon" },
  {
    "utilyre/sentiment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("sentiment").setup({}) end,
  },
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    -- dependencies = { "roobert/surround-ui.nvim" },
    enabled = true,
    config = function()
      require("nvim-surround").setup({})
      -- require("surround-ui").setup({ root_key = "S" })
    end,
  },
  {
    "tpope/vim-repeat",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
  },
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    -- event = "VeryLazy",
    enabled = true,
    config = function() require("nvim-highlight-colors").setup({}) end,
  },
  {
    "Exafunction/codeium.vim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    config = function() end,
  },
  {
    "rcarriga/nvim-notify",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    -- event = "VeryLazy",
    config = function()
      require("notify").setup({
        background_colour = "Normal",
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = "",
        },
        level = 2,
        -- minimum_width = 50,
        render = "minimal", -- compact, minimal, simple, default
        stages = "slide",
        top_down = true,
        timeout = 3000,
        max_height = function() return math.floor(vim.o.lines * 0.75) end,
        max_width = function() return math.floor(vim.o.columns * 0.35) end,
      })
    end,
  },

  {
    "Wansmer/treesj",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    -- keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local tsj = require("treesj")

      local langs = { --[[ configuration for languages ]]
      }

      tsj.setup({
        -- Use default keymaps
        -- (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,

        -- Node with syntax error will not be formatted
        check_syntax_error = true,

        -- If line after join will be longer than max value,
        -- node will not be formatted
        max_join_length = 120,

        -- hold|start|end:
        -- hold - cursor follows the node/place on which it was called
        -- start - cursor jumps to the first symbol of the node being formatted
        -- end - cursor jumps to the last symbol of the node being formatted
        cursor_behavior = "hold",

        -- Notify about possible problems or not
        notify = true,
        langs = langs,

        -- Use `dot` for repeat action
        dot_repeat = true,
      })
    end,
  },
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    config = function()
      require("dressing").setup({
        input = {
          override = function(conf)
            conf.col = -1
            conf.row = 0
            return conf
          end,
        },
      })
    end,
  },

  -- icons
  "nvim-tree/nvim-web-devicons",

  -- ui components
  "nvim-lua/popup.nvim",

  {
    "gbprod/yanky.nvim",
    enabled = true,
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ring = {
        history_length = 100,
        storage = "shada",
        sync_with_numbered_registers = true,
        cancel_event = "update",
      },
      picker = {
        select = {
          action = nil, -- nil to use default put action
        },
        telescope = {
          use_default_mappings = true, -- if default mappings should be used
          mappings = nil,              -- nil to use default mappings or no mappings (see `use_default_mappings`)
        },
      },
      system_clipboard = {
        sync_with_ring = true,
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 150,
      },
      preserve_cursor_position = {
        enabled = true,
      },
    },
    keys = {
      -- stylua: ignore
      {
        "<leader>P",
        function() require("telescope").extensions.yank_history.yank_history({}) end,
        desc =
        "Paste from Yanky"
      },
      { "y",  "<Plug>(YankyYank)",                     mode = { "n", "x" } },
      { "p",  "<Plug>(YankyPutAfter)",                 mode = { "n", "x" } },
      { "P",  "<Plug>(YankyPutBefore)",                mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)",                mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)",               mode = { "n", "x" } },
      { "[y", "<Plug>(YankyCycleForward)" },
      { "]y", "<Plug>(YankyCycleBackward)" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" },
      { "=p", "<Plug>(YankyPutAfterFilter)" },
      { "=P", "<Plug>(YankyPutBeforeFilter)" },
      -- { "<c-n>", "<Plug>(YankyCycleForward)" },
      -- { "<c-p>", "<Plug>(YankyCycleBackward)" },
    },
    config = true,
  },
}
