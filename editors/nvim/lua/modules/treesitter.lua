return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = {
      "TSInstall",
      "TSInstallSync",
      "TSInstallInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSBufEnable",
      "TSBufToggle",
      "TSEnable",
      "TSToggle",
      "TSModuleInfo",
      "TSEditQuery",
      "TSEditQueryUserAfter",
    },
    event = "BufReadPost",
    config = function() require("configs.nvim-treesitter") end,
    dependencies = {
      "ts-node-action",
      "nvim-ts-autotag",
      "nvim-treesitter-textobjects",
      "nvim-ts-context-commentstring",
      "nvim-treesitter-endwise",
    },
  },

  {
    "CKolkey/ts-node-action",
    dependencies = "nvim-treesitter",
    config = function() require("configs.ts-node-action") end,
    keys = {
      {
        "<Leader><Leader>",
        function() require("ts-node-action").node_action() end,
        desc = "treesitter: Do node action",
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter",
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    dependencies = "nvim-treesitter",
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    dependencies = "nvim-treesitter",
  },

  {
    "Eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    dependencies = "nvim-treesitter",
  },

  {
    "RRethy/nvim-treesitter-endwise",
    event = "FileType",
    dependencies = "nvim-treesitter",
  },
}
