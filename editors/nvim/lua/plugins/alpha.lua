return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')
    local sections = dashboard.section

    local logo = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
    ]]

    sections.header.val = vim.split(logo, '\n')

    sections.buttons.val = {
      dashboard.button('n', '  New file', ':ene <bar> startinsert <cr>'),
      dashboard.button('L', '󰒲  Lazy', ':Lazy<cr>'),
      dashboard.button('q', '  Quit', ':qa<cr>'),
    }

    local fortune = require('alpha.fortune')
    sections.footer.val = fortune()

    sections.lazy = {
      type = 'text',
      val = 'info',
      opts = {
        position = 'center',
        hl = 'Number',
      },
    }

    local config = {
      layout = {
        { type = 'padding', val = 2 },
        sections.header,
        { type = 'padding', val = 2 },
        sections.lazy,
        { type = 'padding', val = 2 },
        sections.buttons,
        sections.footer,
      },
      opts = {
        margin = 5,
      },
    }

    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    alpha.setup(config)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        sections.lazy.val = 'Loaded ' .. stats.count .. ' plugins in ' .. ms .. ' ms'

        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
