local conf = require('modules.ui.config')

packadd({
  'hardhackerlabs/theme-vim',
})

packadd({
  'nvimdev/dashboard-nvim',
  event = 'UIEnter',
  config = conf.dashboard,
})

packadd({
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter */*',
  config = conf.gitsigns,
})

packadd({
  'nvimdev/indentmini.nvim',
  event = 'BufEnter */*',
  config = function()
    vim.opt.listchars:append({ tab = '  ' })
    require('indentmini').setup({
      only_current = true,
    })
  end,
})
