return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  enabled = os.getenv('SSH_TTY') == nil,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    preset = 'modern',
    win = {
      no_overlap = false,
      border = 'double',
      title = false,
    },
    layout = {
      width = { max = 80 },
      spacing = 3,
      align = 'left',
    },
    icons = {
      mappings = false,
      breadcrumb = '',
      separator = '',
      group = '',
    },
  },
}
