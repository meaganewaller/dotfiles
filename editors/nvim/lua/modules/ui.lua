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
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    config = function() require("configs.barbar") end,
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function() require("configs.notify") end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
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
  {
    "linty-org/key-menu.nvim",
    event = "VeryLazy",
    config = function() require("configs.key-menu") end,
  },
  {
    "princejoogie/chafa.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "m00qek/baleia.nvim",
    },
    config = function() require("configs.chafa") end,
  },

  {
    "gorbit99/codewindow.nvim",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({
        window_border = "none",
      })
      codewindow.apply_default_keybinds()
    end,
  }
}
