return {
  {
    "kylechui/nvim-surround",
    keys = {
      "ys",
      "ds",
      "cs",
      { "S", mode = "x" },
      { "<C-g>s", mode = "i" },
    },
    config = function() require("configs.nvim-surround") end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("configs.autopairs") end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "x" }, desc = "comment: Toggle lines" },
      { "gb", mode = { "n", "x" }, desc = "comment: Toggle block" },
    },
    config = function() require("configs.Comment") end,
  },

  {
    "tpope/vim-sleuth",
    event = "BufReadPre",
  },

  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function() require("configs.ultimate-autopair") end,
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", mode = { "n", "x" } },
      { "gA", mode = { "n", "x" } },
    },
    config = function() require("configs.vim-easy-align") end,
  },

  {
    "rainbowhxch/accelerated-jk.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function() require("configs.accelerated-jk") end,
  },

  {
    "malbertzard/inline-fold.nvim",
    event = { "BufEnter", "BufWinEnter" },
    opts = {
      defaultPlaceholder = "…",
      queries = {

        -- Some examples you can use
        html = {
          { pattern = 'class="([^"]*)"', placeholder = "@" }, -- classes in html
          { pattern = 'href="(.-)"' }, -- hrefs in html
          { pattern = 'src="(.-)"' }, -- HTML img src attribute
        },
      },
    },
    command = "InlineFoldToggle",
    config = function(opts) require("inline-fold").setup(opts) end,
  },

  {
    "ojroques/nvim-bufdel",
    lazy = true,
    cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
  },

  {
    "rhysd/clever-f.vim",
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = function() require("configs.cleverf") end,
  },

  {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewClose" },
  },

  {
    "smoka7/hop.nvim",
    lazy = true,
    version = "*",
    event = { "CursorHold", "CursorHoldI" },
    config = function() require("configs.hop") end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    config = function() require("configs.copilot") end,
  },
}
