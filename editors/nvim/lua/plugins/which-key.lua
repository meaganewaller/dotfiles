return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  enabled = os.getenv('SSH_TTY') == nil,
  pin = true,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = true,
        windows = false,
        nav = true,
        z = true,
        g = true,
      },
    },
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
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    show_help = true,
  },
}
