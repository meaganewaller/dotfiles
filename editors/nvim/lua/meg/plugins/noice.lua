-- https://github.com/folke/noice.nvim

-- { == Configuration ==> =====================================================

require("noice").setup({
  lsp = {
    signature = {
      enabled = false,
    },
    hover = { enabled = true },
    progress = {
      enabled = false, -- using fidget instead as it feel less intrusive
    },
    documentation = {
      opts = {
        win_options = {
          concealcursor = "n",
          conceallevel = 3,
          winhighlight = {
            Normal = "LspFloat",
            FloatBorder = "LspFloatBorder",
          },
        },
      },
    },
  },
  cmdline = {
    format = {
      cmdline = { icon = " " },
      search_down = { icon = "  " },
      search_up = { icon = "  " },
      filter = { icon = " ", lang = "fish" },
      lua = { icon = " " },
      help = { icon = " 󰋖" },
    },
    opts = {
      position = {
        row = vim.o.lines - 3,
        col = 0,
      },
      size = { width = "100%" },
      border = {
        padding = { 0, 3 },
      },
      win_options = {
        winhighlight = {
          Normal = "CmdLine",
          FloatBorder = "CmdLineBorder",
        },
      },
    },
  },
  history = {
    filter = {},
  },
  routes = {
    {
      filter = {
        any = {
          { find = "No active Snippet" },
          { find = "No signature help available" },
          { find = "^<$" },
          { kind = "wmsg" },
        },
      },
      opts = { skip = true },
    },
  },
  views = {
    mini = {
      position = {
        row = vim.o.lines - 8,
      },
      win_options = {
        winblend = vim.o.winblend, -- mainly necessary to fix coloring issue in alacritty
      },
    },
    popup = {
      win_options = {
        winhighlight = {
          Normal = "NormalFloat",
          FloatBorder = "FloatBorder",
        },
      },
    },
  },
  notify = {
    enabled = false,
  },
  presets = {
    bottom_search = true,
    lsp_doc_border = nx.opts.float_win_border ~= "none" and true or false,
  },
})

-- <== }

-- { == Highlights ==> ========================================================

nx.hl({ { "NoiceCmdlinePopupBorder", "NoiceCmdlineIconCmdLine" }, link = "Operator" })
-- <== }

-- { == Keymaps ==> ===========================================================

nx.map({
  { "<C-j>", "<Tab>", "c", desc = "Next Entry" },
  { "<C-k>", "<S-Tab>", "c", desc = "Previous Entry" },
})
-- <== }
