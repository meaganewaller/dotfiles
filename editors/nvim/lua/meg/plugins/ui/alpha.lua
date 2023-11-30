return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require "alpha"

    local dashboard = require "alpha.themes.dashboard"

    dashboard.section.header.val = {
      [[                                                     ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
      [[                                                     ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('b', "    Bookmarks", ":Telescope marks<cr>"),
      dashboard.button('c', "    Change colorscheme", ":Telescope colorscheme<cr>"),
      dashboard.button('e', "    Recent files", ":Telescope oldfiles<cr>"),
      dashboard.button('f', "    Find file", ":Telescope find_files<cr>"),
      dashboard.button('g', "    Find word", ":Telescope live_grep<cr>"),
      dashboard.button('h', "󰊢    Browse git", ":Flog<CR>"),
      dashboard.button('i', "    New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button('l', "    Update plugins", ":Lazy sync<cr>"),
      dashboard.button('m', '󱌣    Mason', ':Mason<CR>'),
      dashboard.button('p', "󰄉    Profile", ':Lazy profile<CR>'),
      dashboard.button('q', "    Quit NVIM", ":qa<cr>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = 'Normal'
      button.opts.hl_shortcut = 'Function'
    end
    dashboard.section.footer.opts.hl = 'Special'
    dashboard.opts.layout = {
      dashboard.section.header,
      dashboard.section.buttons,
      dashboard.section.footer,
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

    alpha.setup(dashboard.config)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = '󱐋 ' .. stats.count .. ' plugins loaded in ' .. ms .. 'ms'
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
