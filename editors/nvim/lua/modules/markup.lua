return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'markdown' },
    config = function()
      require('configs.vimtex')
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    build = ':call mkdp#util#install()',
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
