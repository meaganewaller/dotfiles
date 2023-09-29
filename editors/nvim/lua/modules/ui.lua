return {
  {
    "goolord/alpha-nvim",
    enabled = true,
    event = { "VimEnter" },
    lazy = false,
    cmd = "Alpha",
    priority = 1000,
    config = function() require("configs.alpha") end,
  },

  {
    "akinsho/bufferline.nvim",
    lazy = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function() require("configs.bufferline") end,
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {},
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function() require("configs.dressing") end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function() require("configs.noice") end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufWritePost" },
    config = function() require("configs.dropbar") end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    branch = "v3",
    event = "VeryLazy",
    config = function() require("configs.indent-blankline") end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufNew", "BufRead" },
    config = function() require("configs.nvim-colorizer") end,
  },

  {
    "ojroques/nvim-bufdel",
    cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
    keys = {
      { "<A-q>", "<Cmd>BufDel<CR>", desc = "buffer: Delete current" },
      { "<A-S-q>", "<Cmd>BufDel!<CR>", desc = "buffer: Force delete current" },
    },
  },

  {
    "yorickpeterse/nvim-pqf",
    event = "VeryLazy",
    config = function() require("configs.pqf") end,
  },
}
