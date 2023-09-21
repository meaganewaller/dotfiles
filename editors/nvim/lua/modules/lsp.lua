return {
  {
    'neovim/nvim-lspconfig',
    event = { 'FileType' },
    cmd = { 'LspInfo', 'LspStart' },
    config = function()
      require('configs.nvim-lspconfig')
    end,
  },
  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    config = function()
      require('configs.glance')
    end,
  },
}
