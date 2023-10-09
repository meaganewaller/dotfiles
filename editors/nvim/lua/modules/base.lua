return {
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function() require("configs.nvim-web-devicons") end,
  },

  { "wakatime/vim-wakatime", event = "VeryLazy" },
  { "milisims/nvim-luaref", lazy = false },
  { "nanotee/luv-vimdocs", lazy = false },
  {
    "linty-org/key-menu.nvim",
    event = "VeryLazy",
    config = function() require("configs.key-menu") end,
  },

  --- Separate cut from delete registers
  {
    "gbprod/cutlass.nvim",
    event = "VeryLazy",
    opts = { cut_key = "x" },
  },

  --- Sudo in Neovim
  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  },

  --- Smart ESC, ESC not gonna exit terminal mode again whenever I try to close htop!
  {
    "sychen52/smart-term-esc.nvim",
    event = "TermOpen",
    opts = {
      key = "<Esc>",
      except = { "nvim", "emacs", "fzf", "zf", "htop" },
    },
  },
}
