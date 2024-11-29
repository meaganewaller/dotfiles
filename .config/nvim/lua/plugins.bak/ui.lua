return {
  -- messages, cmdline and the popupmenu
  {
    'folke/noice.nvim',
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = 'notify',
          find = 'No information available',
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd('FocusGained', {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd('FocusLost', {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = 'notify_send',
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = 'split',
          opts = { enter = true, format = 'details' },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function(event)
          vim.schedule(function()
            require('noice.text.markdown').keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 5000,
    },
  },

  -- animations
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Tab>', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next tab' },
      { '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Prev tab' },
    },
    opts = {
      options = {
        mode = 'tabs',
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- filename
  -- {
  --   'b0o/incline.nvim',
  --   dependencies = { 'craftzdog/solarized-osaka.nvim' },
  --   event = 'BufReadPre',
  --   priority = 1200,
  --   config = function()
  --     local colors = require('solarized-osaka.colors').setup()
  --     require('incline').setup({
  --       highlight = {
  --         groups = {
  --           InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
  --           InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
  --         },
  --       },
  --       window = { margin = { vertical = 0, horizontal = 1 } },
  --       hide = {
  --         cursorline = true,
  --       },
  --       render = function(props)
  --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
  --         if vim.bo[props.buf].modified then
  --           filename = '[+] ' .. filename
  --         end
  --
  --         local icon, color = require('nvim-web-devicons').get_icon_color(filename)
  --         return { { icon, guifg = color }, { ' ' }, { filename } }
  --       end,
  --     })
  --   end,
  -- },

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    opts = function(_, opts)
      local LazyVim = require('lazyvim.util')
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = 'cwd',
          modified_hl = 'MatchParen',
          directory_hl = '',
          filename_hl = 'Bold',
          modified_sign = '',
          readonly_icon = ' 󰌾 ',
        }),
      }
    end,
  },

  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = '+2' },
      },
    },
    keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' } },
  },

  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local status_ok, alpha = pcall(require, 'alpha')
      if not status_ok then
        return
      end

      local dashboard = require('alpha.themes.dashboard')

      local function button(sc, txt, keybind, keybind_opts)
        local sc_ = sc:gsub('%s', ''):gsub('SPC', '<Leader>')

        local opts = {
          position = 'center',
          shortcut = sc,
          cursor = 5,
          width = 30,
          align_shortcut = 'right',
          hl_shortcut = 'Keyword',
        }

        if keybind then
          keybind_opts =
            vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
          opts.keymap = { 'n', sc_, keybind, keybind_opts }
        end

        local function on_press()
          local key = vim.api.nvim_replace_termcodes(sc_ .. '<Ignore>', true, false, true)
          vim.api.nvim_feedkeys(key, 'normal', false)
        end

        return {
          type = 'button',
          val = txt,
          on_press = on_press,
          opts = opts,
        }
      end

      -- Obtain Date Info
      local date = io.popen('echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"')
      local date_info = '󰨲 Today is ' .. date:read('*a')
      date:close()

      local headers = require('static.headers')
      local footers = require('static.footers')

      local function random_elem(tb)
        local keys = {}
        for k in pairs(tb) do
          table.insert(keys, k)
        end
        return tb[keys[math.random(#keys)]]
      end

      Header = random_elem(headers)
      require('alpha.term')

      local text_header = {
        type = 'text',
        val = Header,
        opts = {
          position = 'center',
          hl = 'Type',
        },
      }

      local date_today = {
        type = 'text',
        val = date_info,
        opts = {
          position = 'center',
          hl = 'Keyword',
        },
      }

      local buttons = {
        type = 'group',
        val = {
          button('f', '󰈞 -> Find file', ':Telescope find_files <CR>'),
          button('e', ' -> New file', ':ene <BAR> startinsert <CR>'),
          button('p', '󱞊 -> Find project', ':Telescope projects <CR>'),
          button('r', ' -> Recently used files', ':Telescope oldfiles <CR>'),
          button('t', '󱘢 -> Find text', ':Telescope live_grep <CR>'),
          button('q', '󰅙 -> Quit Neovim', ':qa<CR>'),
        },
        opts = {
          spacing = 1,
        },
      }

      local footer = {
        type = 'text',
        val = random_elem(footers),
        opts = {
          position = 'center',
          hl = 'Number',
        },
      }

      local section = {
        header = text_header,
        date = date_today,
        buttons = buttons,
        footer = footer,
      }

      local opts = {
        layout = {
          { type = 'padding', val = 5 },
          section.header,
          { type = 'padding', val = 4 },
          section.date,
          { type = 'padding', val = 2 },
          section.buttons,
          { type = 'padding', val = 1 },
          section.footer,
          { type = 'padding', val = 5 },
        },
        opts = {
          margin = 5,
          noautocmd = true,
          redraw_on_resize = true,
        },
      }

      dashboard.opts = opts
      alpha.setup(dashboard.opts)
    end,
  },

  {
    'svampkorg/moody.nvim',
    event = { 'ModeChanged', 'BufWinEnter', 'WinEnter' },
    dependencies = {
      'sainnhe/gruvbox-material',
    },
    opts = {
      -- you can set different blend values for your different modes.
      -- Some colours might look better more dark.
      blend = {
        normal = 0.2,
        insert = 0.2,
        visual = 0.3,
        command = 0.2,
        replace = 0.2,
        select = 0.3,
        terminal = 0.2,
        terminal_n = 0.2,
      },
    },
  },
  -- {
  --   'nvimdev/dashboard-nvim',
  --   event = 'VimEnter',
  --   opts = function(_, opts)
  --     local logo = require('static.headers')['default16']
  --     local footer = require('static.footers')['default1']
  --     opts.config.header = logo
  --     opts.config.footer = footer
  --   end,
  -- },
}
