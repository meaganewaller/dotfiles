return {
  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'ds',
      'cs',
      { 'S', mode = 'x' },
      { '<C-g>s', mode = 'i' },
    },
    config = function() require('configs.nvim-surround') end,
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' }, desc = 'comment: Toggle lines' },
      { 'gb', mode = { 'n', 'x' }, desc = 'comment: Toggle block' },
    },
    config = function() require('configs.Comment') end,
  },

  {
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function() require 'configs.ultimate-autopair' end,
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'ga', mode = { 'n', 'x' } },
      { 'gA', mode = { 'n', 'x' } },
    },
    config = function()
      require('configs.vim-easy-align')
    end,
  },

  {
    "rainbowhxch/accelerated-jk.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require('configs.accelerated-jk')
    end
  }
}
