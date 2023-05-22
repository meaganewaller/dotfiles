return {
  { 'nmac427/guess-indent.nvim', lazy = false, priority = 50, config = true },
  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion' },
  { 'lambdalisue/suda.vim', event = 'BufRead' },
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      delay = 200,
      under_cursor = false,
      modes_allowlist = { 'n', 'no', 'nt' },
      filetypes_denylist = { 'fugitive', 'neo-tree', 'SidebarNvim', 'git' },
    },
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'Prev Reference' },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. dir .. '_reference'](false)
        end, {
            desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference',
            buffer = buffer
          })
      end

      map(']]', 'next')
      map('[[', 'prev')

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('meg_illuminate', {}),
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map(']]', 'next', buffer)
          map('[[', 'prev', buffer)
        end,
      })
    end,
  },
  -- File manager
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      trash = false,
      skip_confirm_for_simple_edits = true,
      restore_win_options = false,
      prompt_save_on_select_new_entry = false,
      keymaps = {
        ["`"] = "actions.tcd",
        ["~"] = "actions.cd",
        ["<C-t>"] = "actions.open_terminal",
        ["gd"] = {
          desc = "Toggle detail view",
          callback = function()
            local oil = require("oil")
            local config = require("oil.config")
            if #config.columns == 1 then
              oil.set_columns({ "icon", "permissions", "size", "mtime" })
            else
              oil.set_columns({ "icon" })
            end
          end,
        },
      },
    },
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)
      vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
      vim.keymap.set("n", "_", function()
        oil.open(vim.fn.getcwd())
        end, { desc = "Open cwd" })
    end,
  },

  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<Leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' }
    }
  },

  {
    'kana/vim-niceblock',
    keys = {
      { 'I',  '<Plug>(niceblock-I)',  silent = true, mode = 'x', desc = 'Blockwise Insert' },
      { 'gI', '<Plug>(niceblock-gI)', silent = true, mode = 'x', desc = 'Blockwise Insert' },
      { 'A',  '<Plug>(niceblock-A)',  silent = true, mode = 'x', desc = 'Blockwise Append' },
    },
    init = function()
      vim.g.niceblock_no_default_key_mappings = 0
    end
  },

  {
    'haya14busa/vim-edgemotion',
    keys = {
      { 'gj', '<Plug>(edgemotion-j)', mode = { 'n', 'x' }, desc = 'Move to bottom edge' },
      { 'gk', '<Plug>(edgemotion-k)', mode = { 'n', 'x' }, desc = 'Move to top edge' },
    },
  },

  {
    'folke/zen-mode.nvim',
    dependencies = {
      "smart-splits",
    },
    cmd = 'ZenMode',
    keys = {
      { '<Leader>zz', '<cmd>ZenMode<CR>', noremap = true, desc = 'Zen Mode' },
    },
    opts = {
      window = {
        width = 126,
        height = function() return vim.fn.winheight(0) + (vim.fn.has("nvim-0.9.0") == 1 and 3 or 1) end,
      },
      on_open = nil,
      on_close = nil,
    },
    config = function(_, opts)
      local zen_mode = require("zen-mode")
      local gs = package.loaded.gitsigns

      opts.on_open = function()
        vim.g.zen_mode = true
        vim.o.laststatus = 3
        vim.wo.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:›,vert:▏]]
        vim.cmd("ScrollbarHide")
        if gs.toggle_signs() then gs.toggle_signs() end

        -- Disable default window-switch keymaps as they would close zen-mode.
        nx.map({ { "<C-h>", "<C-j>", "<C-k>", "<C-l>" }, "<nop>" })
      end

      opts.on_close = function()
        vim.g.zen_mode = nil
        vim.o.laststatus = 2
        vim.cmd("ScrollbarShow")
        if not gs.toggle_signs() then gs.toggle_signs() end
        -- Re-enable default window-switch keymaps.
        local smart_splits = require("smart-splits")
        smart_splits.setup()

        nx.map({
          { "<C-Left>", function() smart_splits.resize_left(2) end },
          { "<C-Right>", function() smart_splits.resize_right(2) end },
          { "<C-Down>", function() smart_splits.resize_down(2) end },
          { "<C-Up>", function() smart_splits.resize_up(2) end },
          { "<C-h>", smart_splits.move_cursor_left, desc = "Go to Left Window" },
          { "<C-l>", smart_splits.move_cursor_right, desc = "Go to Right Window" },
          { "<C-j>", smart_splits.move_cursor_down, desc = "Go to Below Window" },
          { "<C-k>", smart_splits.move_cursor_up, desc = "Go to Above Window" },
        })
      end
    end
  },

  {
    'folke/which-key.nvim',
    cmd = 'WhichKey',
    opts = {
      plugins = { marks = true, registers = false, spelling = { enabled = true, suggestions = 20 } },
      icons = { separator = '  ' },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = true,
        nav = true,
        z = true,
        g =  true,
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "rounded",
        position = "bottom", -- bottom, top
        margin = { 0, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
        winblend = vim.wo.winblend,
      },
      layout = {
        height = { min = 5, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 4, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<Cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = false,
      triggers = "auto",
      triggers_blacklist = {
        n = { ";", "y" },
        v = { "j", "k" },
        i = { "j", "k", "<lt>" },
      },
    },
    init = function()
      local wk = require("which-key")
      wk.register({
        ["/"] = { name = "Search" },
        [","] = { name = "Config" },
        ["`"] = { name = "Terminal", ["`"] = "Toggle" },
        b = { name = "Buffers" },
        d = { name = "Diagnostics" },
        f = { name = "File" },
        g = {
          name = "Git",
          y = "Link",
          G = { name = "Gist" },
        },
        c = { name = "TODO Comments" },
        h = { name = "History" },
        l = { name = "LSP" },
        m = { name = "Bookmarks" },
        R = { name = "SnipRun" },
        s = { name = "Sessions" },
        t = { name = "Toggle", d = { name = "Diagnostics" } },
        T = { name = "Treesitter" },
      }, { prefix = "<Leader>" })

      wk.register({
        d = "Delete fold at cursor",
        D = "Delete fold at cursor recursively",
        E = "Eliminate all folds in window",
        ["%"] = "which_key_ignore",
      }, { prefix = "z" })

      wk.register({
        ["/"] = { name = "Search Marks" },
        h = { name = "Harpoon" },
        x = { name = "Delete Marks" },
        ["0"] = "which_key_ignore",
      }, { prefix = "m" })

      wk.register({
        ["<C-/>"] = "which_key_ignore",
        ["<C-_>"] = "which_key_ignore",
        ["`"] = "which_key_ignore",
        j = "which_key_ignore",
        k = "which_key_ignore",
        g = { name = "Git" },
        R = { name = "SnipRun" },
      }, { prefix = "<leader>", mode = "v" })

      wk.register({
        t = { name = "Tabs" },
      }, { prefix = "<C-w>" })

      wk.register({
        c = "which_key_ignore",
        b = "which_key_ignore",
      }, { prefix = "g", mode = { "n", "v" } })
    end
  },

  {
    'tversteeg/registers.nvim',
    cmd = 'Registers',
    keys = {
      { '<C-r>', mode = 'i', desc = 'Reveal registers' },
      { '"', mode = 'n', desc = 'Reveal registers' },
      { '"', mode = 'x', desc = 'Reveal registers' },
    },
    opts = {
      window = {
        max_width = 100,
        highlight_cursorline = true,
        border = 'rounded',
        transparency = 0,
      }
    },
  },

  { "tenxsoydev/karen-yank.nvim", event = "VeryLazy", config = true, branch = "remove-cut-esc" },

  {
    'folke/todo-comments.nvim',
    event = "VeryLazy",
    dependencies = 'nvim-telescope/telescope.nvim',
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
      { '<LocalLeader>dt', '<cmd>TodoTelescope<CR>', desc = 'todo' },
      { '<leader>xt', '<cmd>TodoTrouble<CR>', desc = 'Todo (Trouble)' },
      { '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
      { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
      { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
    },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", alt = { "#to/do" } },
      NOTE = { icon = "󰍨 ", alt = { "INFO" } },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      HACK = { icon = " ", color = "warning" },
      PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      TEST = { icon = "󰕥 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      DBG = { icon = " " },
    },
    gui_style = {
      fg = "NONE",
      bg = "BOLD",
    },
    merge_keywords = true,
    highlight = {
      multiline = false,
      multiline_pattern = "^.",
      multiline_context = 10,
      before = "",
      keyword = "wide_fg",
      after = "",
      pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlightng (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
    colors = {
      default = { "DiagnosticInfo" },
      -- info = { "DiagnosticInfo"},
      -- hint = { "DiagnosticHint"},
      error = { "DiagnosticError" },
      warning = { "DiagnosticWarn" },
      test = { "DiagnosticOk" },
      dbg = { "@debug" },
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
  },

  {
    'folke/trouble.nvim',
    event = "VeryLazy",
    cmd = { 'Trouble', 'TroubleToggle' },
    opts = {
      position = "bottom",
      height = 9,
      mode = "loclist",
      use_diagnostic_signs = true
    },
    keys = {
      { '<leader>e', '<cmd>TroubleToggle document_diagnostics<CR>', noremap = true, desc = 'Document Diagnostics' },
      { '<leader>r', '<cmd>TroubleToggle workspace_diagnostics<CR>', noremap = true, desc = 'Workspace Diagnostics' },
      { '<leader>xq', '<cmd>TroubleToggle quickfix<CR>', noremap = true, desc = 'Trouble Quickfix' },
      { '<leader>xl', '<cmd>TroubleToggle loclist<CR>', noremap = true, desc = 'Trouble Loclist' },
    },
    config = function(_, opts)
      require("trouble").setup(opts)
      nx.map({
        { "<leader>dw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace Diagnostics" },
        { "<leader>dT", "<Cmd>TroubleToggle<CR>", desc = "Trouble Toggle" },
      })
    end,
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<Leader>gv', '<cmd>DiffviewOpen<CR>', desc = 'Diff View' }
    },
    opts = function()
      local actions = require('diffview.actions')
      vim.api.nvim_create_autocmd({'WinEnter', 'BufEnter'}, {
        group = vim.api.nvim_create_augroup('meg_diffview', {}),
        pattern = 'diffview:///panels/*',
        callback = function()
          vim.wo.winhighlight = 'CursorLine:WildMenu'
        end,
      })

      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {
            { 'n', 'q',       '<cmd>DiffviewClose<CR>' },
            { 'n', '<Tab>',   actions.select_next_entry },
            { 'n', '<S-Tab>', actions.select_prev_entry },
            { 'n', '<LocalLeader>a', actions.focus_files },
            { 'n', '<LocalLeader>e', actions.toggle_files },
          },
          file_panel = {
            {'n', 'q',     '<cmd>DiffviewClose<CR>' },
            {'n', 'h',     actions.prev_entry },
            {'n', 'o',     actions.focus_entry },
            {'n', 'gf',    actions.goto_file },
            {'n', 'sg',    actions.goto_file_split },
            {'n', 'st',    actions.goto_file_tab },
            {'n', '<C-r>', actions.refresh_files },
            {'n', ';e',    actions.toggle_files },
          },
          file_history_panel = {
            {'n', 'q', '<cmd>DiffviewClose<CR>' },
            {'n', 'o', actions.focus_entry },
            {'n', 'O', actions.options },
          },
        }
      }
    end
  },

  -----------------------------------------------------------------------------
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = {
      { '<C-\\>', mode = { 'n', 't' }, silent = true, function()
        local venv = vim.b['virtual_env']
        local term = require('toggleterm.terminal').Terminal:new({
          env = venv and { VIRTUAL_ENV = venv } or nil,
          count = vim.v.count > 0 and vim.v.count or 1,
        })
        term:toggle()
        end, desc = 'Toggle terminal' },
    },
    opts = {
      open_mapping = false,
      float_opts = {
        border = 'curved',
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'simrat39/symbols-outline.nvim',
    cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
    keys = {
      { '<Leader>o', '<cmd>SymbolsOutline<CR>', desc = 'Symbols Outline' },
    },
    opts = {
      width = 30,
      autofold_depth = 0,
      keymaps = {
        hover_symbol = 'K',
        toggle_preview = 'p',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('meg_outline', {}),
        pattern = 'Outline',
        callback = function()
          vim.wo.winhighlight = 'CursorLine:WildMenu'
          vim.wo.signcolumn = 'auto'
        end
      })
    end
  },

  -----------------------------------------------------------------------------
  {
    's1n7ax/nvim-window-picker',
    keys = {
      {
        'sp',
        function()
          local picked_window_id = require('window-picker').pick_window()
          if picked_window_id ~= nil then
            vim.api.nvim_set_current_win(picked_window_id)
          end
        end,
        desc = 'Pick window',
      },
      {
        'sw',
        function()
          local picked_window_id = require('window-picker').pick_window()
          if picked_window_id ~= nil then
            local current_winnr = vim.api.nvim_get_current_win()
            local current_bufnr = vim.api.nvim_get_current_buf()
            local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
            vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
            vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
          end
        end,
        desc = 'Swap picked window',
      },
    },
    opts = {
      use_winbar = 'smart',
      fg_color = '#ededed',
      current_win_hl_color = '#e35e4f',
      other_win_hl_color = '#44cc41',
    },
  },

  -----------------------------------------------------------------------------
  {
    'rest-nvim/rest.nvim',
    ft = 'http',
    keys = {
      { ',ht', '<Plug>RestNvim', desc = 'Execute HTTP request' },
    },
    opts = { skip_ssl_verification = true },
  },

  -----------------------------------------------------------------------------
  {
    'mickael-menu/zk-nvim',
    name = 'zk',
    ft = 'markdown',
    cmd = { 'ZkNew', 'ZkNotes', 'ZkTags', 'ZkMatch' },
    keys = {
      { '<leader>zn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = 'Zk New' },
      { '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = 'Zk Notes' },
      { '<leader>zt', '<Cmd>ZkTags<CR>', desc = 'Zk Tags' },
      { '<leader>zf', "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", desc = 'Zk Search' },
      { '<leader>zf', ":'<,'>ZkMatch<CR>", mode = 'x', desc = 'Zk Match' },
      { '<leader>zb', '<Cmd>ZkBacklinks<CR>', desc = 'Zk Backlinks' },
      { '<leader>zl', '<Cmd>ZkLinks<CR>', desc = 'Zk Links' },
    },
    opts = { picker = 'telescope' }
  },

  -----------------------------------------------------------------------------
  {
    'nvim-pack/nvim-spectre',
    keys = {
      {
        '<Leader>sp',
        function() require('spectre').open() end,
        desc = 'Spectre',
      },
      {
        '<Leader>sp',
        function() require('spectre').open_visual({ select_word=true }) end,
        mode = 'x',
        desc = 'Spectre Word',
      },
    },
    opts = {
      mapping = {
        ['toggle_gitignore'] = {
          map = 'tg',
          cmd = "<cmd>lua require('spectre').change_options('gitignore')<CR>",
          desc = 'toggle gitignore',
        },
      },
      find_engine = {
        ['rg'] = {
          cmd = 'rg',
          args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--max-columns=0',
            '--case-sensitive',
            '--hidden',
            '--no-ignore',
          },
          options = {
            ['ignore-case'] = {
              value = '--ignore-case',
              icon = '[I]',
              desc = 'ignore case',
            },
            ['hidden'] = {
              value = '--no-hidden',
              icon = '[H]',
              desc = 'hidden file',
            },
            ['gitignore'] = {
              value = '--ignore',
              icon = '[G]',
              desc = 'gitignore',
            },
          },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    'echasnovski/mini.bufremove',
    main = 'mini.bufremove',
    config = true,
    keys = {
      {
        '<leader>bd', function()
          require('mini.bufremove').delete(0, false)
        end,
        desc = 'Delete Buffer'
      },
    },
  },

  { "kwkarlwang/bufresize.nvim", event = "VeryLazy", config = true }, -- handle split window sizes on client resize
  {
    "gorbit99/codewindow.nvim",
    event = "VeryLazy",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({
        active_in_terminals = false, -- Should the minimap activate for terminal buffers
        auto_enable = false, -- Automatically open the minimap when entering a (non-excluded) buffer (accepts a table of filetypes)
        exclude_filetypes = {}, -- Choose certain filetypes to not show minimap on
        max_minimap_height = nil, -- The maximum height the minimap can take (including borders)
        max_lines = nil, -- If auto_enable is true, don't open the minimap for buffers which have more than this many lines.
        minimap_width = 17, -- The width of the text part of the minimap
        use_lsp = true, -- Use the builtin LSP to show errors and warnings
        use_treesitter = true, -- Use nvim-treesitter to highlight the code
        use_git = true, -- Show small dots to indicate git additions and deletions
        width_multiplier = 4, -- How many characters one dot represents
        z_index = 1, -- The z-index the floating window will be on
        show_cursor = true, -- Show the cursor position in the minimap
        window_border = { "▕", " ", " ", " ", " ", " ", "▕", "▕" }, -- The border style of the floating window (accepts all usual options)
      })

      nx.map({
        { "<leader>tm", codewindow.toggle_minimap, desc = "Toggle Minimap" },
        { "<leader>tM", codewindow.toggle_focus, desc = "Toggle Minimap Focus" },
      }, { wk_label = { sub_desc = "Toggle" } })
      nx.hl({ "CodewindowBorder", link = "FloatBorder" })
    end
  },

  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "oil", "neo-tree", "neo-tree-popup", "notify", "quickfix" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal" },
          },
        },
      })

      nx.hl({
        { "NvimWindoSwitchNC", bg = "StatusLineNC:bg" },
        { "NvimWindoSwitch", bg = "StatusLine:bg" },
      })
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    config = function()
      local smart_splits = require("smart-splits")
      smart_splits.setup()

      nx.map({
        { "<C-Left>", function() smart_splits.resize_left(2) end },
        { "<C-Right>", function() smart_splits.resize_right(2) end },
        { "<C-Down>", function() smart_splits.resize_down(2) end },
        { "<C-Up>", function() smart_splits.resize_up(2) end },
        { "<C-h>", smart_splits.move_cursor_left, desc = "Go to Left Window" },
        { "<C-l>", smart_splits.move_cursor_right, desc = "Go to Right Window" },
        { "<C-j>", smart_splits.move_cursor_down, desc = "Go to Below Window" },
        { "<C-k>", smart_splits.move_cursor_up, desc = "Go to Above Window" },
      })
    end,
  },
  {
    "anuvyklack/windows.nvim",
    dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
    event = "VeryLazy",
    config = function()
      local M = {}
      local windows = require("windows")
      vim.o.winwidth = 11
      vim.o.winminwidth = 11

      local config = {
        autowidth = {
          enable = false,
          winwidth = 0.618, -- Golden Ratio.
        },
        ignore = {
          buftype = { "quickfix", "popup" },
          filetype = { "NvimTree", "oil", "neo-tree", "undotree", "gundo", "sagarename", "alpha", "DiffviewFiles" },
        },
        animation = {
          enable = true,
          duration = 120,
          fps = 60,
          easing = "in_out_sine",
        },
      }

      if vim.g.loaded_gui then
        -- Lower fps seems smoother in e.g., neovide without multigrid.
        config.animation.fps = 30
        -- Use neovides builtin animations when multigrid is enabled.
        if vim.g.neovide and vim.g.multigrid then config.animation.enable = false end
      end

      local ignored_filetypes = config.ignore.filetype
      for _, key in ipairs(ignored_filetypes) do
        ignored_filetypes[key] = true
      end

      windows.setup(config)

      M.auto_maximize, M.auto_width = false, false
      ---Switch windows back and forth to trigger resize
      local function pseudo_switch()
        vim.schedule(
          function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>w<C-w><C-p>", true, false, true), "n", false)
          end
        )
      end

      local function enable_auto_maximize()
        M.auto_maximize = true
        vim.cmd("WindowsMaximize")
        -- vim.notify "Autowidth On"

        if M.auto_width then
          M.auto_width = false
          vim.cmd("WindowsDisableAutowidth")
        end
      end

      local function disable_auto_maximize()
        M.auto_maximize = false
        vim.cmd("WindowsEqualize")
        pseudo_switch()
        -- vim.notify "Autowidth Off"
      end

      local function toggle_auto_maximize()
        if ignored_filetypes[vim.bo.filetype] then return end
        if M.auto_maximize then
          disable_auto_maximize()
        else
          enable_auto_maximize()
        end
      end

      nx.cmd({
        { "WindowsToggleAutoMaximize", toggle_auto_maximize },
        -- overwrite default WindowsToggleAutowidth autocommand
        {
          "WindowsToggleAutowidth",
          function()
            if not M.auto_width then
              M.auto_width = true
              vim.cmd("WindowsEnableAutowidth")
              pseudo_switch()
              -- vim.notify "Autowidth On"
            else
              M.auto_width = false
              vim.cmd("WindowsDisableAutowidth")
              -- vim.notify "Autowidth Off"
            end

            if M.auto_maximize then M.auto_maximize = false end
          end,
        },
      })

      local timer = vim.loop.new_timer()

      nx.au({
        {
          "WinEnter",
          callback = function()
            if M.auto_maximize then
              vim.schedule(function()
                if vim.bo.filetype == "oil" then
                  vim.cmd("WindowsEqualize")
                  return
                end
                if ignored_filetypes[vim.bo.filetype] then return end
                vim.cmd("WindowsMaximize")
              end)
            end
          end,
        },
        {
          "VimResized",
          callback = function()
            if M.auto_width then
              vim.cmd("WindowsDisableAutowidth")

              if timer then
                timer:stop()
                timer:start(
                  250,
                  0,
                  vim.schedule_wrap(function()
                    vim.cmd("WindowsEnableAutowidth")
                    pseudo_switch()
                  end)
                )
              end
            elseif M.auto_maximize then
              disable_auto_maximize()

              if timer then
                timer:stop()
                timer:start(450, 0, vim.schedule_wrap(enable_auto_maximize))
              end
            end
          end,
        },
        {
          "FocusLost",
          callback = function()
            if M.auto_width then vim.cmd("WindowsDisableAutowidth") end
          end,
        },
        {
          "FocusGained",
          callback = function()
            if M.auto_width then vim.cmd("WindowsEnableAutowidth") end
          end,
        },
      }, { create_group = "WindowsCustomAutoWidth" })

      nx.map({
        { "<A-CR>", "<Cmd>WindowsToggleAutoMaximize<CR>", desc = "Toggle Window Maximization" },
        { "<A-kEnter>", "<Cmd>WindowsToggleAutoMaximize<CR>", desc = "Toggle Window Maximization" },
        { "<C-w>a", "<Cmd>WindowsToggleAutowidth<CR>", desc = "Toggle Window Auto Width" },
        {
          "<C-w>=",
          function()
            M.auto_width = false
            M.auto_maximize = false
            vim.cmd("WindowsDisableAutowidth")
            vim.cmd("WindowsEqualize")
          end,
        },
      })
    end,
  },

  -----------------------------------------------------------------------------
  {
    'mzlogin/vim-markdown-toc',
    cmd = { 'GenTocGFM', 'GenTocRedcarpet', 'GenTocGitLab', 'UpdateToc' },
    ft = 'markdown',
    init = function()
      vim.g.vmt_auto_update_on_save = 0
    end,
  },

  {
    "tomasky/bookmarks.nvim",
    opts = {
      save_file = vim.fn.stdpath("config") .. "/.bookmarks",
      	keywords = {
        ["@t"] = "", -- mark annotation startswith @t ,signs this icon as `Todo`
        ["@w"] = "", -- mark annotation startswith @w ,signs this icon as `Warn`
        ["@f"] = "", -- mark annotation startswith @f ,signs this icon as `Fix`
        ["@n"] = "󰆉", -- mark annotation startswith @n ,signs this icon as `Note`
      },
      signs = {
        add = { hl = "BufferAlternate", text = "", numhl = "BookMarksAddNr", linehl = "BookMarksAddLn" },
        ann = { hl = "BookMarksAnn", text = "󰆉", numhl = "BookMarksAnnNr", linehl = "BookMarksAnnLn" },
      },
    },
    config = function(_, opts)
      local bm = require("bookmarks")
      local actions = require("bookmarks.actions")

      nx.cmd({
        "BookmarksTelescope",
        function()
          actions.loadBookmarks()
          vim.defer_fn(function() require("telescope").extensions.bookmarks.list({ prompt_title = "Bookmarks" }) end, 50)
        end,
      })

      local function map_keys()
        nx.map({
          {
            "<leader>mm",
            function()
              bm.bookmark_toggle()
              actions.saveBookmarks()
            end,
            desc = "Bookmark toggle",
            wk_label = "Toggle",
          },
          {
            "<leader>ma",
            function()
              bm.bookmark_ann()
              actions.saveBookmarks()
            end,
            desc = "Annotate",
          },
          { "<leader>mq", bm.bookmark_list, desc = "Open Bookmarks in Quickfix List", wk_label = "Quickfix List" },
          { "<leader>mj", bm.bookmark_next, desc = "Next" },
          { "<leader>mk", bm.bookmark_prev, desc = "Prev" },
          { "<leader>mc", bm.bookmark_clean, desc = "Clean Buffer" },
          { "<leader>/m", "<Cmd>BookmarksTelescope<CR>", desc = "Search Bookmarks", wk_label = "Bookmarks" },
          { "<leader>m/", "<Cmd>BookmarksTelescope<CR>", desc = "Search Bookmarks", wk_label = "Search" },
        })
      end

      opts.on_attach = function(_) map_keys() end
      bm.setup(config)
    end,
  },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      require("harpoon").setup()
      local harpoon_ui = require("harpoon.ui")

      nx.map({
        { "mh/", function() harpoon_ui.toggle_quick_menu() end, desc = "Search Harpoons" },
        { "mh1", function() harpoon_ui.nav_file(1) end, desc = "Go to Harpoon #1" },
        { "mh2", function() harpoon_ui.nav_file(2) end, desc = "Go to Harpoon #2" },
        { "mh3", function() harpoon_ui.nav_file(3) end, desc = "Go to Harpoon #3" },
        { "mh4", function() harpoon_ui.nav_file(4) end, desc = "Go to Harpoon #4" },
        -- stylua: ignore
        { "mha", function() require("harpoon.mark").add_file() end, desc = "Harpoon Current File", wk_label =  "Add Current File" },
      }, { wk_label = { sub_desc = "Harpoon[s]?" } })

      nx.map({
        { "<C-p>", "<C-p>" },
        { { "<C-c>", "<Esc>" }, "<Cmd>close<CR>" },
      }, { buffer = 0, silent = true, ft = "harpoon" })

      nx.hl({ "HarpoonBorder", link = "FloatBorder" })
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern" },
      })

      nx.map({
        { "<leader>p", "<Cmd>Telescope projects<CR>", desc = "Projects" },
        { "<leader>/p", "<Cmd>Telescope projects<CR>", desc = "Search Projects", wk_label = "Projects" },
      })
    end,
  },

  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = false,
      cyclic = true,
      force_write_shada = true,
      refresh_interval = 150,
      -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
      -- marks, and bookmarks.
      -- can be either a table with all/none of the keys, or a single number, in which case
      -- the priority applies to all marks.
      -- default 10.
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      -- disables mark tracking for specific filetypes. default {}
      excluded_filetypes = { -- neccecary when using builtin marks - prior disabling "."
        "",
        "filetree",
        "toggleterm",
        "Outline",
        "NeogitCommitMessage",
        "NvimTree",
        "neo-tree-popup",
        "registers",
        "whichkey",
        "sagarename",
        "sagacodeaction",
        "lspsagafinder",
        -- probably deprecated
        "LspsagaDiagnostic",
        "LspsagaDefinition",
        "LspsagaImplement",
        "LspsagaFloaterm",
        "LspsagaHover",
        "LspsagaSignatureHelp",
      },
      -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
      -- sign/virttext. Bookmarks can be used to group together positions and quickly move
      -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
      -- default virt_text is "".
      bookmark_0 = {
        sign = "⚑",
        -- virt_text = "hello world"
      },
      mappings = {},
    },
    config = function(_, opts)
      opts.mappings = {
        set_bookmark0 = "m0",
      }

      nx.map({
        { "dml", "<Plug>(Marks-deleteline)", desc = "Delete Marks in Line" },
        { "dmb", "<Plug>(Marks-deletebuf)", desc = "Delete Marks in Buffer" },
        { "m/a", "<Cmd>MarksListAll<CR>", desc = "Search All Marks", wk_label = "All" },
        { "m/b", "<Cmd>MarksListBuf<CR>", desc = "Search Marks in Buffer", wk_label = "Buffer" },
        { "m/g", "<Cmd>MarksListGlobal<CR>", desc = "Search Global Marks", wk_label = "Global" },
        { "m[", "<Plug>(Marks-next)", desc = "Move to Next Mark", wk_label = "Next Mark" },
        { "m]", "<Plug>(Marks-prev)", desc = "Move to Previous Mark", wk_label = "Previous Mark" },
        { "mt", "<Cmd>MarksToggleSigns<CR>", desc = "Toggle Marks Signs", wk_label = "Toggle Signs" },
        { "mxl", "<Plug>(Marks-deleteline)", desc = "Delete Marks in Line", wk_label = "Line" },
        { "mxb", "<Plug>(Marks-deletebuf)", desc = "Delete Marks in Buffer", wk_label = "Buffer" },
      })

      require("marks").setup(opts)
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    config = function()
      require("bqf").setup({
        func_map = {
          pscrollup = "<C-y>",
          pscrolldown = "<C-e>",
        },
      })

      nx.hl({ "BqfPreviewBorder", link = "FloatBorder" })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        on_open = function(term)
          set_terminal_keymaps()
          vim.cmd("setlocal nonumber norelativenumber signcolumn=no")
          if term.direction == "tab" then
            vim.o.showtabline = 0
            vim.o.cmdheight = 0
          end
        end,
        on_close = function(term)
          if term.direction == "tab" then vim.o.showtabline = 2 end
        end,
        hide_numbers = false,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = false,
        shell = vim.o.shell,
        auto_scroll = false,
        autochdir = true,
        float_opts = {
          border = "rounded",
          winblend = vim.o.winblend,
        },
        highlights = {
          Normal = {
            link = "Normal",
          },
          FloatBorder = {
            link = "FloatBorder",
          },
        },
      })

      local Terminal = require("toggleterm.terminal").Terminal

      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        on_open = function(term) set_lazygit_keymaps(term) end,
        close_on_exit = true,
      })
      function _G.lazygit_toggle() lazygit:toggle() end

      local gitui = Terminal:new({
        cmd = "gitui",
        dir = "git_dir",
        on_open = function(term) set_lazygit_keymaps(term) end,
        close_on_exit = true,
      })
      function _G.gitui_toggle() gitui:toggle() end

      local ncdu = Terminal:new({ cmd = "ncdu", hidden = true, close_on_exit = true })
      function _G.ncdu_toggle() ncdu:toggle() end

      local btop = Terminal:new({ cmd = "btop", hidden = true, close_on_exit = true })
      function _G.btop_toggle() btop:toggle() end

      nx.map({
        -- Ctrl-Escape won't work in some TUIs, works in kitty and GUIs
        { "<C-Esc>", "<Cmd>ToggleTerm<CR>", { "t", "n" }, desc = "Toggle Terminal" },
        { "<leader>``", "<Cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
        { "<leader>t`", "<Cmd>ToggleTerm<CR>", desc = "Toggle Terminal", wk_label = "Terminal" },
        { "<leader>`h", "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", desc = "Horizontal" },
        { "<leader>`f", "<Cmd>ToggleTerm direction=float<CR>", desc = "Float" },
        { "<leader>`v", "<Cmd>ToggleTerm size=80 direction=vertical<CR>", desc = "Vertical" },
        { "<leader>`t", "<Cmd>ToggleTerm direction=tab<CR>", desc = "Tab" },
        -- Terminal quick access gui and kitty mappings
        -- Equivalents in kitty to e.g., `<C-F1>` is `<F25>`
        { { "<C-F1>", "<F25>", "<leader>`1" }, "<Cmd>1ToggleTerm<CR>", { "", "t" }, desc = "Toggle Terminal #1" },
        { { "<C-F2>", "<F26>", "<leader>`2" }, "<Cmd>2ToggleTerm<CR>", { "", "t" }, desc = "Toggle Terminal #2" },
        { { "<C-F3>", "<F27>", "<leader>`3" }, "<Cmd>3ToggleTerm<CR>", { "", "t" }, desc = "Toggle Terminal #3" },
        { { "<C-F4>", "<F28>", "<leader>`4" }, "<Cmd>4ToggleTerm<CR>", { "", "t" }, desc = "Toggle Terminal #4" },
        -- External injections
        { "<leader>gt", "<Cmd>lua lazygit_toggle()<CR>", "", desc = "Terminal UI" },
        { "<leader>`r", "<Cmd>lua btop_toggle()<CR>", desc = "Btop Resource Monitor" },
        { "<leader>`u", "<Cmd>lua ncdu_toggle()<CR>", desc = "NCurses Disk Usage" },
        -- Telescope
        { "<leader>`/", "<Cmd>Telescope termfinder<CR>", desc = "Search Terminals", wk_label = "Search" },
        { "<leader>/`", "<Cmd>Telescope termfinder<CR>", desc = "Search Terminals", wk_label = "Terminals" },
      })

      function _G.set_terminal_keymaps()
        nx.map({
          { "a", "A", "n" },
          { "i", "I", "n" },
          { "jk", "<C-\\><C-n>" },
          }, { buffer = 0, mode = "t" })
      end

      function _G.set_lazygit_keymaps(term) nx.map({ { "<C-j><C-k>", "<C-\\><C-n>", "t", buffer = term.bufnr } }) end
    end,
  },
  {
    "willothy/flatten.nvim",
    priority = 100,
    config = function()
      local toggleterm = require("toggleterm")

      require("flatten").setup({
        callbacks = {
          pre_open = function()
            -- Close toggleterm when an external open request is received
            toggleterm.toggle(0)
          end,
          post_open = function(bufnr, winnr, ft)
            if ft == "gitcommit" then
              -- If the file is a git commit, create one-shot autocmd to delete it on write
              -- If you just want the toggleable terminal integration, ignore this bit and only use the
              -- code in the else block
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = function()
                  -- This is a bit of a hack, but if you run bufdelete immediately
                  -- the shell can occasionally freeze
                  vim.defer_fn(function() vim.api.nvim_buf_delete(bufnr, {}) end, 50)
                end,
              })
            else
              -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
              -- This gives the appearance of the window opening independently of the terminal
              toggleterm.toggle(0)
              vim.api.nvim_set_current_win(winnr)
            end
          end,
          block_end = function()
            -- After blocking ends (for a git commit, etc), reopen the terminal
            toggleterm.toggle(0)
          end,
        },
      })
    end,
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      local function init()
        require("better_escape").setup({
          mapping = { "jk" },
        })
      end

      nx.au({ "InsertEnter", once = true, callback = init })
    end,
  }, -- remove delay from escape keys while typing in insert mode

  {
    "nat-418/boole.nvim",
    event = "VeryLazy",
    config = function()
      require("boole").setup({
        mappings = {
          increment = "<C-a>",
          decrement = "<C-x>",
        },
        additions = {
          { "const", "let" },
          { "left", "right" },
          { "one", "two", "three" },
          { "primary", "secondary", "tertiary", "quaternary", "quinary" },
        },
        allow_caps_additions = {
          { "enable", "disable" },
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
        },
      })
    end,
  }, -- extend increment / decrement to cycle through related words
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require("hlslens").setup({
        override_lens = function(render, posList, nearest, idx, relIdx)
          local sfw = vim.v.searchforward == 1
          local indicator, text, chunks
          local absRelIdx = math.abs(relIdx)
          if absRelIdx > 1 then
            indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "N" or "n")
          elseif absRelIdx == 1 then
            indicator = sfw ~= (relIdx == 1) and "N" or "n"
          else
            indicator = ""
          end

          local lnum, col = unpack(posList[idx])
          if nearest then
            local cnt = #posList
            if indicator ~= "" then
              text = ("[%s %d/%d]"):format(indicator, idx, cnt)
            else
              text = ("[%d/%d]"):format(idx, cnt)
              -- if vim.g.multigrid then text = text .. " /" .. vim.fn.getreg("/") end
            end
            chunks = { { " ", "Ignore" }, { text, "HlSearchNear" } }
          else
            text = ("[%s %d]"):format(indicator, idx)
            chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end,
      })

      nx.hl({ "HlSearchLens", link = "NoiceVirtualText" })
    end,
  },
  {
    "phaazon/hop.nvim",
    event = "VeryLazy",
    config = function()
      local hop = require("hop")
      local direction = require("hop.hint").HintDirection
      -- funnily using commands fixes hop with dotrepeat
      -- ATM it makes a difference in a command instead of mapping the function directly
      -- so these commands are just created to be called with keymaps
      nx.cmd({
        {
          "HopChar1t",
          function() hop.hint_char1({ direction = direction.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end,
        },
        {
          "HopChar1T",
          function() hop.hint_char1({ direction = direction.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end,
        },
      })

      nx.map({
        -- use commands instead of mapping functions directly as it is compatible with dot repeat
        { "s", "<Cmd>HopChar2<CR>" },
        { "S", "<Cmd>HopChar1<CR>" },
        { "<leader>s", "<Cmd>HopChar2<CR>", "", wk_label = "ignore" },
        { "<leader>S", "<Cmd>HopChar1<CR>", "", wk_label = "ignore" },
        { "<leader>j", "<Cmd>HopLineStartAC<cr>", "", wk_label = "ignore" },
        { "<leader>k", "<Cmd>HopLineStartBC<cr>", "", wk_label = "ignore" },
        { "f", "<Cmd>HopChar1CurrentLineAC<CR>", "" },
        { "F", "<Cmd>HopChar1CurrentLineBC<CR>", "" },
        { "t", "<Cmd>HopChar1t<CR>", "" },
        { "T", "<Cmd>HopChar1T<CR>", "" },
      })

      hop.setup()
    end,
  },
}
