return {
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },

  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    config = function()
      require('configs.nvim-web-devicons')
    end,
  },
}
