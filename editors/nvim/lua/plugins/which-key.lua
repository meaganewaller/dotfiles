return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    win = {
      border = 'double',
      title = false,
    },
    icons = {
      mappings = false,
      breadcrumb = '',
      separator = '',
      group = '',
    },
  },
}
