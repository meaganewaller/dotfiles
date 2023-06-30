-- Plugins: UI

return {
  -----------------------------------------------------------------------------
  { 'nvim-tree/nvim-web-devicons', lazy = false },
  { 'MunifTanjim/nui.nvim', lazy = false },
  { 'rafi/tabstrip.nvim', lazy = false, priority = 98, opts = true },

  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      if vim.g.gnvim then
        dashboard.section.header.val = {
          [[        		           ]],
          [[                        ]],
          [[    Ｎ Ｘ Ｖ ｉ ｍ    ]],
          [[                        ]],
        }
      else
        dashboard.section.header.val = {
          [[                    ]],
          [[                    ]],
          [[   🇳 🇽 🇻 🇮 🇲   ]],
          [[                    ]],
        }
      end

      local sep = " "
      dashboard.section.buttons.val = {
        -- dashboard.button("f", icons.Files .. sep .. "Files", ":Telescope find_files<CR>"),
        dashboard.button("f", "󰈢" .. sep .. "File Browser", "<Cmd>Neotree float<CR>"),
        dashboard.button("n", "󰈔" .. sep .. " New File", "<Cmd>ene <BAR> startinsert<CR>"),
        dashboard.button("r", "" .. sep .. " Recent Files", "<Cmd>Telescope oldfiles<CR>"),
        dashboard.button("p", "󰉓" .. sep .. " Projects", "<Cmd>Telescope projects<CR>"),
        dashboard.button("s", "" .. sep .. " Sessions", "<Cmd>Telescope persisted<cr>"),
        dashboard.button("o", "" .. sep .. " Options", "<Cmd>e ~/.config/nvim/lua/nxvim/options.lua<CR>"),
        dashboard.button("q", "󰅙" .. sep .. " Quit", "<Cmd>qa<CR>"),
        -- dashboard.button("b", icons.Book .. sep .. " Bookmarks", ":Telescope bookmarks list prompt_title=Bookmarks<CR>"),
        -- dashboard.button("g", icons.List .. sep .. " Grep Files", ":Telescope live_grep <CR>"),
      }

      ---@param kind "custom"|"fortune"
      local function footer(kind)
        if kind == "custom" then
          local quotes = {
            "The version of you that ends his day in gratitude: What what he do in your situation?",
            "Pray not for a lighter burden, but for stronger shoulders.",
            "Breathe brother.",
          }
          math.randomseed(os.time())
          dashboard.section.footer.val = "\n \n \n" .. quotes[math.random(#quotes)]
          return
        end

        -- Use fortune instead of a custom quote table (requires fortune to be installed on your system).
        vim.schedule(function() -- defer load to not sacrifice startup time when a fortune is fetched.
          local handle = io.popen("fortune")
          -- local handle = io.popen "fortune -a | cowsay -f bud-frogs | lolcat "
          if handle == nil then return end
          local cookie = handle:read("*a")
          handle:close()
          dashboard.section.footer.val = "\n \n \n" .. cookie
          vim.api.nvim_feedkeys("k", "n", true)
        end)
      end
      footer("custom")

      dashboard.section.footer.opts.hl = "Normal"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.opts.opts.noautocmd = true

      nx.map({ { "<leader>a", "<Cmd>Alpha<CR>", desc = "Alpha", silent = true } })

      alpha.setup(dashboard.opts)
    end,
  },

  -----------------------------------------------------------------------------
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      { '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
      { '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
      { '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
      { '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
      { '<c-f>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll forward', mode = {'i', 'n', 's'} },
      { '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll backward', mode = {'i', 'n', 's'}},
    },
    ---@type NoiceConfig
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      messages = {
        view_search = false,
      },
      routes = {
        {
          filter = { event = 'msg_show', find = '%d+L, %d+B' },
          view = 'mini',
        },
        {
          filter = { event = 'msg_show', find = 'Hunk %d+ of %d+' },
          view = 'mini',
        },
        {
          filter = { event = 'msg_show', find = '%d+ more lines' },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', find = '%d+ lines yanked' },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = 'quickfix' },
          view = 'mini',
        },
        {
          filter = { event = 'msg_show', kind = 'search_count' },
          view = 'mini',
        },
        {
          filter = { event = 'msg_show', kind = 'wmsg' },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      commands = {
        all = {
          view = 'split',
          opts = { enter = true, format = 'details' },
          filter = {},
        },
      },
      ---@type NoiceConfigViews
      views = {
        mini = {
          zindex = 100,
          win_options = { winblend = 0 },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'stevearc/dressing.nvim',
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
  },

  -----------------------------------------------------------------------------
  {
    'SmiteshP/nvim-navic',
    keys = {
      {
        '<Leader>tf',
        function()
          if vim.b.navic_winbar then
            vim.b.navic_winbar = false
            vim.wo.winbar = ''
          else
            vim.b.navic_winbar = true
            vim.wo.winbar =
            "%#NavicIconsFile# %t %* "
            .. "%{%v:lua.require'nvim-navic'.get_location()%}"
          end
        end,
        desc = 'Toggle structure panel',
      },
    },
    init = function()
      vim.g.navic_silence = true

      ---@param client lsp.Client
      ---@param buffer integer
      require('meg.lib.lsp').on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = '  ',
        highlight = true,
        -- icons = require('meg.static.icons').get('kind', true)
      }
    end,
  },

  -----------------------------------------------------------------------------
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>un',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
        desc = 'Dismiss all Notifications',
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  -----------------------------------------------------------------------------
  {
    'chentoast/marks.nvim',
    dependencies = 'lewis6991/gitsigns.nvim',
    event = 'FileType',
    keys = {
      { 'm/', '<cmd>MarksListAll<CR>', desc = 'Marks from all opened buffers' }
    },
    opts = {
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      bookmark_1 = { sign = '󰈼' },  -- ⚐ ⚑ 󰈻 󰈼 󰈽 󰈾 󰈿 󰉀
      mappings = {
        annotate = 'm<Space>',
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'FileType',
    keys = {
      { '<Leader>ti', '<cmd>IndentBlanklineToggle<CR>' },
    },
    opts = {
      show_trailing_blankline_indent = false,
      disable_with_nolist = true,
      show_foldtext = false,
      char_priority = 100,
      show_current_context = true,
      show_current_context_start = false,
      filetype_exclude = {
        'lspinfo',
        'checkhealth',
        'help',
        'man',
        'lazy',
        'alpha',
        'dashboard',
        'terminal',
        'TelescopePrompt',
        'TelescopeResults',
        'neo-tree',
        'Outline',
        'mason',
        'Trouble',
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'tenxsoydev/tabs-vs-spaces.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
  },

  -----------------------------------------------------------------------------
  {
    't9md/vim-quickhl',
    keys = {
      {
        '<Leader>mt',
        '<Plug>(quickhl-manual-this)',
        mode = { 'n', 'x' },
        desc = 'Highlight word'
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    cmd = 'BqfAutoToggle',
    event = 'QuickFixCmdPost',
    opts = {
      auto_resize_height = false,
      func_map = {
        tab = 'st',
        split = 'sv',
        vsplit = 'sg',

        stoggleup = 'K',
        stoggledown = 'J',
        stogglevm = '<Space>',

        ptoggleitem = 'p',
        ptoggleauto = 'P',
        ptogglemode = 'zp',

        pscrollup = '<C-b>',
        pscrolldown = '<C-f>',

        prevfile = 'gk',
        nextfile = 'gj',

        prevhist = '<S-Tab>',
        nexthist = '<Tab>',
      },
      preview = {
        auto_preview = true,
        should_preview_cb = function(bufnr)
          -- file size greater than 100kb can't be previewed automatically
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(filename)
          if fsize > 100 * 1024 then
            return false
          end
          return true
        end,
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'uga-rosa/ccc.nvim',
    event = 'FileType',
    keys = {
      { '<Leader>cp', '<cmd>CccPick<CR>', desc = 'Color-picker' }
    },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
        excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'itchyny/calendar.vim',
    cmd = 'Calendar',
    init = function()
      vim.g.calendar_google_calendar = 1
      vim.g.calendar_google_task = 1
      vim.g.calendar_cache_directory = vim.fn.stdpath('data') .. '/calendar'
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup({
        show_in_active_only = true,
        handle = {
          blend = 30,
        },
        handlers = {
          cursor = false,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        },
      })
    end,
  },
  { "edluffy/hologram.nvim", event = "VeryLazy" },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function()
      local indent_char = "▏"
      if not vim.g.neovide and (vim.g.loaded_gui or vim.env.TERM_PROGRAM == "WezTerm") then indent_char = "│" end

      require("indent_blankline").setup({
        char = indent_char,
        context_char = indent_char,
        show_end_of_line = true,
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
        show_first_indent_level = true,
        show_trailing_blankline_indent = false,
        use_treesitter = true,
        context_patterns = { -- Works with treesitter contexts
          "class",
          "return",
          "function",
          "method",
          "^if",
          "^while",
          "jsx_element",
          "^for",
          "^object",
          "^array",
          "^table",
          "block",
          "arguments",
          "if_statement",
          "else_clause",
          "jsx_element",
          "jsx_self_closing_element",
          "try_statement",
          "catch_clause",
          "import_statement",
          "operation_type",
          "element",
        },
        context_pattern_highlight = {
          element = "LineNr",
        },
        buftype_exclude = { "terminal", "nofile" },
        filetype_exclude = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Trouble",
          "md",
        },
      })
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      local animate = require("mini.animate")

      local config = {
        -- Cursor path
        cursor = {
          -- Whether to enable this animation
          enable = true,
          --<function: implements linear total 250ms animation duration>,
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
        },
        -- Vertical scroll
        scroll = {
          enable = false,
          -- enable = vim.g.loaded_gui and true or false,
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({ max_output_steps = 60 }),
        },
        -- Window resize -- we use the animation library that comes with windows.nvim instead
        resize = {
          enable = false,
        },
        -- Window open
        open = {
          enable = false,
        },
        -- Window close
        close = {
          enable = false,
        },
      }

      if vim.g.loaded_gui then config.cursor.enable = false end
      animate.setup(config)

      -- Occasionally mini.animate leaves a residue of virtualedit = "all". This ensures that it's removed.
      local config_ve = vim.o.virtualedit
      nx.au({
        "BufEnter",
        callback = function() vim.wo.virtualedit = config_ve end,
      })
      -- <== }

      -- { == Bufremove ==> =========================================================

      require("mini.bufremove").setup()
      -- <== }

      -- { == Move ==> ==============================================================

      require("mini.move").setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          left = vim.g.eu_kbd and "ù" or "<A-h>",
          right = vim.g.eu_kbd and "ø" or "<A-l>",
          down = vim.g.eu_kbd and "ú" or "<A-j>",
          up = vim.g.eu_kbd and "ĳ" or "<A-k>",
          -- Move current line in Normal mode
          -- line_left =  vim.g.eu_kbd and"ù" or "<A-h>",
          -- line_right =  vim.g.eu_kbd and"ø" or "<A-l>",
          line_left = "",
          line_right = "",
          line_down = vim.g.eu_kbd and "ú" or "<A-j>",
          line_up = vim.g.eu_kbd and "ĳ" or "<A-k>",
        },
      })
      -- <== }

      -- { == Trailspace ==> ========================================================

      require("mini.trailspace").setup()

      nx.hl({ "MiniTrailspace", link = "DiagnosticUnderlineHint" })
    end
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      -- https://github.com/karb94/neoscroll.nvim

      local neoscroll = require("neoscroll")

      -- { == Configuration ==> =====================================================

      local config = {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = {}, -- See keymaps section below
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = "sine", -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
        performance_mode = false, -- Disable "Performance Mode" on all buffers.}
      }
      -- <== }

      -- { == Keymaps ==> ===========================================================

      config.mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" }

      -- Mapping overrides for custom easing function / animation length
      local t = {}
      t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250", "circular" } }
      t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250", "circular" } }
      -- Pass "nil" to disable the easing animation (constant scrolling speed)
      -- When no easing function is provided the default easing function will be used
      t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
      t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150", "sine" } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150", "sine" } }
      -- t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "175", "quintic" } }
      -- t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "175", "quintic" } }
      -- t['zt']    = { 'zt', { '300' } }
      -- t['zz']    = { 'zz', { '300' } }
      -- t['zb']    = { 'zb', { '300' } }
      -- <== }

      neoscroll.setup(config)
      require("neoscroll.config").set_mappings(t)
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      -- https://github.com/nvim-tree/nvim-web-devicons

      -- { == Configuration ==> =====================================================

      require("nvim-web-devicons").setup({
        override_by_extension = {
          ["v"] = {
            icon = "𝗩",
            color = "#5D87BF",
            cterm_color = "24",
            name = "V",
          },
          ["py"] = {
            icon = "",
            color = "#4B8BBE",
            cterm_color = "214",
            name = "Py",
          },
          ["vb"] = {
            icon = "󰈜",
            color = "#1D6F42",
            cterm_color = "29",
            name = "VBA",
          },
        },
      })
      -- <== }
    end,
  },
	{ "tenxsoydev/size-matters.nvim", lazy = true },
	{
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")

      require("statuscol").setup({
        segments = {
          { text = { "%s" }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            text = { " ", builtin.foldfunc, " " },
            condition = { builtin.not_empty, true, builtin.not_empty },
            click = "v:lua.ScFa",
          },
        },
      })
    end,
  },
  {
    "levouh/tint.nvim",
    event = "VeryLazy",
    config = function()
      local tint = require("tint")
      local config = {
        tint = -30,
        highlight_ignore_patterns = {
          "WinSeparator",
          "IndentBlankline*",
          "NeoTreeTabInactive",
          "NeoTreeTabActive",
          "NeoTreeTabSeparatorActive",
          "NeoTreeTabSeparatorInactive",
          "ShortLineLeftWindowNumberSeparator",
          "ShortLineLeftBufferTypeSeparator",
        },
      }

      if vim.g.colors_name == "tokyonight" then
        if require("tokyonight.config").options.style ~= "day" then
          -- brighten up LineNr a bit to fix problems with tint highlighting
          nx.hl({
            { "LineNr", fg = "LineNr:fg:#b+10" },
            { "Winbar", { link = "LineNr" } },
          })
          config.tint = -20
        else
          config.tint = 25
        end
      end

      tint.setup(config)
      nx.au({
        { "Colorscheme", "SessionLoadPost" },
        callback = function() vim.defer_fn(tint.refresh, 250) end,
      })
      nx.cmd({ "TintRefresh", tint.refresh })
    end,
  },
  { "tenxsoydev/tabs-vs-spaces.nvim", config = true },




}
