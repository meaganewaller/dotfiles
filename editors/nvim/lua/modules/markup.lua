return {
  {
    'lervag/vimtex',
    ft = { 'tex' },
    config = function()
      require('configs.vimtex')
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    build = 'cd app && npm install',
    ft = 'markdown',
  },
  {
    'chrisbra/csv.vim',
    lazy = true,
    ft = 'csv',
  },
  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    event = { 'BufReadPost', 'BufNew' },
    config = function()
      require('configs.vim-table-mode')
    end,
  },
}
