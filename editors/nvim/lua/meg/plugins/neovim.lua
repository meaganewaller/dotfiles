local function setup_whichkey()
  local wk = require("which-key")
  wk.setup({
    plugins = {
      marks = true,
      registers = true,
      spelling = { enabled = false, suggestions = 20 },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    operators = {
      gc = "Comments",
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
    window = {
      border = "single",        -- none, single, double, shadow
      position = "bottom",      -- bottom, top
      margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },                                             -- min and max height of the columns
      width = { min = 20, max = 50 },                                             -- min and max width of the columns
      spacing = 3,                                                                -- spacing between columns
      align = "left",                                                             -- align columns left, center or right
    },
    ignore_missing = false,                                                       -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true,                                                             -- show help message on the command line when the popup is visible
    show_keys = true,                                                             -- show the currently pressed key and its label as a message in the command line
    triggers = "auto",                                                            -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      -- most people should not need to change this
      i = { "j", "k" },
      v = { "j", "k" },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by deafult for Telescope
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt", "lazy", "alpha" },
    },
  })
end

local function setup_alpha()
  local alpha = require("alpha")
  local config = require("meg.lib.alpha").config
  alpha.setup(config)
end

local function setup_neoscroll()
  local neoscroll = require("neoscroll")
  neoscroll.setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = "cubic",   -- quadratic, cubic, quartic, quintic, circular, sine
    pre_hook = function()        -- Function to run before the scrolling animation starts
      -- ts_ctx.disable()
      -- vim.cmd [[TSBufToggle highlight]]
    end,
    post_hook = function() -- Function to run after the scrolling animation ends
      -- ts_ctx.enable()
      -- vim.cmd [[TSBufToggle highlight]]
    end,
    performance_mode = false, -- Disable "Performance Mode" on all buffers.
  })

  -- Syntax scrolling function: `scroll(lines, move_cursor, time[, easing_function_name])`
  local t = {}
  -- Syntax: t[keys] = {function, {function arguments}}
  t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
  t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
  t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "450" } }
  t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "450" } }
  t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
  t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
  t["<C-h>"] = { "zt", { "250" } }
  t["<C-l>"] = { "zb", { "250" } }
  t["M"] = { "zz", { "250" } }
  t["zt"] = { "zt", { "250" } }
  t["zz"] = { "zz", { "250" } }
  t["zb"] = { "zb", { "250" } }

  require("neoscroll.config").set_mappings(t)
end

return {
  {
    "goolord/alpha-nvim",
    enabled = true,
    event = { "VimEnter" },
    lazy = false,
    cmd = "Alpha",
    priority = 1000,
    config = function() setup_alpha() end,
  },
  {
    "karb94/neoscroll.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() setup_neoscroll() end,
  },
  "lambdalisue/suda.vim",
  {
    "norcalli/nvim-colorizer.lua",
    config = function() require("colorizer").setup() end,
  },
  "wakatime/vim-wakatime",
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("noice").setup({
        messages = { enabled = false },
        lsp = {
          override = {
            -- override markdown rendering so tht cmp and other plugins use
            -- Treesitter
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          progress = {
            enabled = false,
          },
          hover = {
            enabled = false,
          },
          signature = {
            enabled = false,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function() setup_whichkey() end,
  },
}
