return {
  {
    "rainbowhxch/accelerated-jk.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("accelerated-jk").setup({
        mode = "time_driven",
        enable_deceleration = false,
        acceleration_motions = {},
        acceleration_limit = 150,
        acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
        -- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
        deceleration_table = { { 150, 9999 } },
      })
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = true,
    cmd = { "SessionSave", "SessionRestore", "SessionDelete" },
    config = function()
      require("auto-session").setup({
        log_level = "info",
        auto_session_enable_last_session = true,
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = nil,
      })
    end,
  },
  {
    "m4xshen/autoclose.nvim",
    lazy = true,
    event = "InsertEnter",
    config = function()
      require("autoclose").setup({
        keys = {
          ["("] = { escape = false, close = true, pair = "()" },
          ["["] = { escape = false, close = true, pair = "[]" },
          ["{"] = { escape = false, close = true, pair = "{}" },

          [">"] = { escape = true, close = false, pair = "<>" },
          [")"] = { escape = true, close = false, pair = "()" },
          ["]"] = { escape = true, close = false, pair = "[]" },
          ["}"] = { escape = true, close = false, pair = "{}" },

          ['"'] = { escape = true, close = true, pair = '""' },
          ["'"] = { escape = true, close = true, pair = "''" },
          ["`"] = { escape = true, close = true, pair = "``" },
        },
        options = {
          disabled_filetypes = { "big_file_disabled_ft" },
          disable_when_touch = false,
        },
      })
    end,
  },
  {
    "max397574/better-escape.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = function()
      require("better_escape").setup({
        mapping = { "jk", "jj" }, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
        -- example(recommended)
        -- keys = function()
        --   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
        -- end,
      })
    end,
  },
  {
    "LunarVim/bigfile.nvim",
    lazy = false,
    config = function()
      local ftdetect = {
        name = "ftdetect",
        opts = { defer = true },
        disable = function()
          vim.api.nvim_set_option_value("filetype", "big_file_disabled_ft", { scope = "local" })
        end,
      }

      local cmp = {
        name = "nvim-cmp",
        opts = { defer = true },
        disable = function()
          require("cmp").setup.buffer({ enabled = false })
        end,
      }

      require("bigfile").config({
        filesize = 1, -- size of the file in MiB
        pattern = { "*" }, -- autocmd pattern
        features = { -- features to disable
          "indent_blankline",
          "lsp",
          "illuminate",
          "treesitter",
          "syntax",
          "vimopts",
          ftdetect,
          cmp,
        },
      })
    end,
    cond = true,
  },
  {
    "ojroques/nvim-bufdel",
    lazy = true,
    event = "BufReadPost",
  },
  {
    "rhysd/clever-f.vim",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
      vim.api.nvim_set_hl(
        0,
        "CleverChar",
        { underline = true, bold = true, fg = "Orange", bg = "NONE", ctermfg = "Red", ctermbg = "NONE" }
      )
      vim.g.clever_f_mark_char_color = "CleverChar"
      vim.g.clever_f_mark_direct_color = "CleverChar"
      vim.g.clever_f_mark_direct = true
      vim.g.clever_f_timeout_ms = 1500
    end,
  },
  {
    "junegunn/vim-easy-align",
    lazy = true,
    cmd = "EasyAlign",
  },
  {
    "romainl/vim-cool",
    lazy = true,
    event = { "CursorMoved", "InsertEnter" },
  },
  {
    "lambdalisue/suda.vim",
    lazy = true,
    cmd = { "SudaRead", "SudaWrite" },
    config = function()
      vim.g["suda#prompt"] = "Enter administrator password: "
    end,
  },
  {
    "numToStr/Comment.nvim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = function()
      require("Comment").setup({
        -- Add a space b/w comment and the line
        padding = true,
        -- Whether the cursor should stay at its position
        sticky = true,
        -- Lines to be ignored while (un)comment
        ignore = "^$",
        -- LHS of toggle mappings in NORMAL mode
        toggler = {
          -- Line-comment toggle keymap
          line = "gcc",
          -- Block-comment toggle keymap
          block = "gbc",
        },
        -- LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          -- Line-comment keymap
          line = "gc",
          -- Block-comment keymap
          block = "gb",
        },
        -- LHS of extra mappings
        extra = {
          -- Add comment on the line above
          above = "gcO",
          -- Add comment on the line below
          below = "gco",
          -- Add comment at the end of line
          eol = "gcA",
        },
        -- We defined mappings in `lua/keymap/init.lua` with description so disable them here.
        mappings = {
          -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = false,
          -- Extra mapping; `gco`, `gcO`, `gcA`
          extra = false,
        },
        -- Function to call before (un)comment
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        -- Function to call after (un)comment
        post_hook = nil,
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        filetypes_denylist = {
          "DoomInfo",
          "DressingSelect",
          "NvimTree",
          "Outline",
          "TelescopePrompt",
          "Trouble",
          "alpha",
          "dashboard",
          "dirvish",
          "fugitive",
          "help",
          "lsgsagaoutline",
          "neogitstatus",
          "norg",
          "toggleterm",
        },
        under_cursor = false,
      })
    end,
  },
}
