local lazy = require("meg.plugins.lazy")

vim.g.multigrid = vim.api.nvim_list_uis()[1].ext_multigrid

require("meg.plugins.visual-multi")

local modules = {
  { "MunifTanjim/nui.nvim" },
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua",
      "folke/flash.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      "TwIStOy/project.nvim",
    },
    config = "plugins.telescope",
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    init = function() vim.g.toggleterm_terminal_mapping = "<C-t>" end,
    config = "plugins.toggleterm",
  },
  {
    "tamton-aquib/duck.nvim",
    keys = {
      {
        "<Leader>dd",
        function() require("duck").hatch("🐈") end,
        mode = "n",
        noremap = true,
        silent = true,
        desc = "Hatch a duck",
      },
      {
        "<Leader>dk",
        '<cmd>lua require("duck").cook()<cr>',
        function() require("duck").cook() end,
        mode = "n",
        noremap = true,
        silent = true,
        desc = "Cook the duck",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    config = "plugins.diffview",
  },
  { "folke/flash.nvim", config = "plugins.flash" },
  {
    "akinsho/git-conflict.nvim",
    config = "plugins.git-conflict",
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
    },
  },
  { "echasnovski/mini.pairs", event = "VeryLazy", opts = {} },
  {
    "echasnovski/mini.move",
    allow_in_vscode = true,
    keys = {
      { "<C-h>", nil, mode = { "n", "v" } },
      { "<C-j>", nil, mode = { "n", "v" } },
      { "<C-k>", nil, mode = { "n", "v" } },
      { "<C-l>", nil, mode = { "n", "v" } },
    },
    opts = {
      mappings = {
        left = "<C-h>",
        right = "<C-l>",
        down = "<C-j>",
        up = "<C-k>",
        line_left = "<C-h>",
        line_right = "<C-l>",
        line_down = "<C-j>",
        line_up = "<C-k>",
      },
    },
    config = function(_, opts) require("mini.move").setup(opts) end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup({
        calm_down = false,
        nearest_only = false,
        nearest_float_when = "never",
      })
    end,
    keys = {
      { "*", "*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "#", "#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g*", "g*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g#", "g#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      {
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
    },
  },
  {
    "TwIStOy/nvim-lastplace",
    event = "BufReadPre",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = {
        "gitcommit",
        "gitrebase",
        "svn",
        "hgcommit",
      },
      lastplace_open_folds = false,
    },
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neoclip").setup({
        enable_persistent_history = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      })
      require("telescope").load_extension("neoclip")
    end,
  },
  {
    "yorickpeterse/nvim-pqf",
    lazy = true,
    opts = {
      show_multiple_lines = true,
    },
    config = true,
    main = "pqf",
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    allow_in_vscode = true,
    event = "BufReadPost",
    config = function() require("nvim-surround").setup({}) end,
  },
  {
    "jedrzejboczar/possession.nvim",
    cmd = {
      "SSave",
      "SLoad",
      "SDelete",
      "SList",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    eager = true,
    opts = {
      silent = true,
      commands = {
        save = "SSave",
        load = "SLoad",
        delete = "SDelete",
        list = "SList",
      },
    },
    config = true,
  },
  {
    "TwIStOy/project.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "PickRecentProject" },
    opts = {
      detection_methods = { "pattern" },
      patterns = {
        "BLADE_ROOT",
        "blast.json",
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
      },
      exclude_dirs = {
        "~/.cargo/*",
      },
      silent_chdir = false,
      open_callback = function()
        vim.schedule(function()
          if vim.fn.argc() == 0 and vim.o.lines >= 36 and vim.o.columns >= 80 then require("alpha").redraw() end
        end)
      end,
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)

      vim.api.nvim_create_user_command(
        "PickRecentProject",
        function()
          require("telescope").extensions.projects.projects({
            layout_strategy = "center",
            sorting_strategy = "ascending",
            layout_config = {
              anchor = "N",
              width = 0.5,
              prompt_position = "top",
              height = 0.5,
            },
            border = true,
            results_title = false,
            borderchars = {
              prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
              results = {
                "─",
                "│",
                "─",
                "│",
                "├",
                "┤",
                "╯",
                "╰",
              },
              preview = {
                "─",
                "│",
                "─",
                "│",
                "╭",
                "╮",
                "╯",
                "╰",
              },
            },
          })
        end,
        {}
      )
    end,
  },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = "80",
      disabled_filetypes = {
        "help",
        "NvimTree",
        "lazy",
        "mason",
        "help",
        "alpha",
      },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  { "sQVe/sort.nvim", cmd = { "Sort" }, config = true },
  {
    "lambdalisue/suda.vim",
    cmd = {
      "SudaRead",
      "SudaWrite",
    },
    init = function() vim.g["suda#nopass"] = 1 end,
  },
  {
    "junegunn/vim-easy-align",
    cmd = { "EasyAlign" },
    dependencies = {
      {
        "godlygeek/tabular",
        cmd = { "Tabularize" },
      },
    },
    keys = {
      { "<leader>ta", "<cmd>EasyAlign<CR>", desc = "easy-align" },
      { "<leader>ta", "<cmd>EasyAlign<CR>", mode = "x", desc = "easy-align" },
    },
  },
  {
    "osyo-manga/vim-jplus",
    allow_in_vscode = true,
    event = "BufReadPost",
    keys = { { "J", "<Plug>(jplus)", mode = { "n", "v" }, noremap = false } },
  },
  {
    "andymass/vim-matchup",
    enabled = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    init = function() -- code to run before plugin loaded
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 50
      vim.g.matchup_matchparen_deferred_hide_delay = 300
      vim.g.matchup_matchparen_hi_surround_always = 2
      vim.g.matchup_matchparen_offscreen = {
        method = "status_manual",
      }
      vim.g.matchup_delim_start_plaintext = 1
      vim.g.matchup_motion_override_Npercent = 0
      vim.g.matchup_motion_cursor_end = 0
      vim.g.matchup_mappings_enabled = 0
    end,
    config = function() -- code to run after plugin loaded
      vim.cmd([[hi! link MatchWord Underlined]])

      vim.cmd([[
        aug Matchup
        au!
        au TermOpen * let [b:matchup_matchparen_enabled, b:matchup_matchparen_fallback] = [0, 0]
        aug END
        ]])

      vim.api.nvim_set_keymap("n", "%", "<plug>(matchup-%)", { silent = true })
      vim.api.nvim_set_keymap("x", "%", "<plug>(matchup-%)", { silent = true })
      vim.api.nvim_set_keymap("o", "%", "<plug>(matchup-%)", { silent = true })
    end,
  },
  {
    "dhruvasagar/vim-table-mode",
    lazy = true,
    ft = { "markdown" },
    cmd = { "TableModeEnable", "TableModeDisable" },
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = { "json" },
    opts = { package_manager = "pnpm" },
    keys = {
      {
        "<Leader>ns",
        "<cmd>lua require('package-info').show()<CR>",
        desc = "Show package info",
        mode = "n",
        silent = true,
        noremap = true,
      },
      {
        "<leader>nd",
        "<cmd>lua require('package-info').delete()<cr>",
        desc = "Delete package",
        mode = "n",
        silent = true,
        noremap = true,
      },
      {
        "<leader>np",
        "<cmd>lua require('package-info').change_version()<cr>",
        desc = "Change package version",
        mode = "n",
        silent = true,
        noremap = true,
      },
      {
        "<leader>ni",
        "<cmd>lua require('package-info').install()<cr>",
        desc = "Install package",
        mode = "n",
        silent = true,
        noremap = true,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      local netrw_bufname

      pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })

      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        once = true,
        callback = function() pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" }) end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("oil.nvim", { clear = true }),
        pattern = "*",
        callback = function()
          vim.schedule(function()
            if vim.bo[0].filetype == "netrw" then return end
            local bufname = vim.api.nvim_buf_get_name(0)
            if vim.fn.isdirectory(bufname) == 0 then
              _, netrw_bufname = pcall(vim.fn.expand, "#:p:h")
              return
            end

            -- prevents reopening of file-browser if exiting without selecting a file
            if netrw_bufname == bufname then
              netrw_bufname = nil
              return
            else
              netrw_bufname = bufname
            end

            -- ensure no buffers remain with the directory name
            vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

            require("oil").open_float()
          end)
        end,
        desc = "oil.nvim replacement for netrw",
      })
    end,
    config = "plugins.oil",
  },
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    opts = {
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = true,
      },
      renderer = {
        full_name = true,
        group_empty = true,
        symlink_destination = false,
        indent_markers = {
          enable = true,
        },
        icons = {
          git_placement = "signcolumn",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      filters = {
        custom = {
          "^.git$",
        },
      },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true
    end,
    config = function(_, opts) require("nvim-tree").setup(opts) end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    event = "User BaseFile",
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = ":TSUpdate",
    config = "plugins.treesitter",
  },

  { dir = "meg/colorschemes", priority = 90, config = "colorschemes", eager = true },
  { dir = "meg/client", priority = 95, config = "client", eager = true },
  --    { dir = "meg/keymaps", priority = 80, config = "keymaps", eager = true },
  --  { dir = "meg/autocmds", priority = 80, config = "autocmds", eager = true },
  --  { dir = "meg/options", priority = 80, config = "options", eager = true },
  --   { dir = "meg/lsp", priority = 80, config = "lsp" },
  --
  { "Bekaboo/dropbar.nvim", event = "VeryLazy", config = "plugins.dropbar" },
  { "wakatime/vim-wakatime", priority = 90, eager = true },
  { "tenxsoydev/nx.nvim", priority = 100, config = function() _G.nx = require("nx") end, eager = true },
  { "famiu/bufdelete.nvim", lazy = true },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    allow_in_vscode = true,
    event = { "InsertEnter" },
    config = "plugins.luasnip",
    keys = {
      {
        "<C-e>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then ls.change_choice(1) end
        end,
        mode = { "i", "s", "n", "v" },
      },
      {
        "<C-b>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then ls.jumpable(-1) end
        end,
        mode = { "i", "s", "n", "v" },
      },
      {
        "<C-f>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then ls.expand_or_jump() end
        end,
        mode = { "i", "s", "n", "v" },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind.nvim",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "dmitmel/cmp-digraphs",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "rafamadriz/friendly-snippets",
      "kdheepak/cmp-latex-symbols",
      {
        "paopaol/cmp-doxygen",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-treesitter/nvim-treesitter-textobjects",
        },
      },
      "zbirenbaum/copilot-cmp",
    },
    config = "plugins.cmp",
  },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    config = "plugins.glance",
  },
  {
    "onsails/lspkind.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = "plugins.lspkind",
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("lspsaga").setup({
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = false,
          keys = { quit = { "q", "<Esc>" }, exec = "<CR>" },
        },
        lightbulb = { enable = false },
        symbol_in_winbar = { enable = false },
        ui = {},
      })
    end,
  },
  {
    "TwIStOy/neodim",
    event = "LspAttach",
    config = function()
      require("neodim").setup({
        alpha = 0.75,
        blend_color = "#000000",
        update_in_insert = { enable = false, delay = 100 },
        hide = { virtual_text = true, signs = false, underline = false },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = {
          "Mason",
          "MasonInstall",
          "MasonUninstall",
          "MasonUninstallAll",
          "MasonLog",
          "MasonUpdate",
          "MasonUpdateAll",
        },
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_uninstalled = "✗",
              package_pending = "⟳",
            },
          },
        },
        build = ":MasonUpdate",
        config = function(_, opts) require("mason").setup(opts) end,
      },
      {
        "williamboman/mason-lspconfig",
        cmd = { "LspInstall", "LspUninstall" },
      },
      "simrat39/symbols-outline.nvim",
      {
        "p00f/clangd_extensions.nvim",
        lazy = true,
      },
      { "simrat39/rust-tools.nvim", lazy = true },
      "SmiteshP/nvim-navic",
      "onsails/lspkind.nvim",
      "hrsh7th/nvim-cmp",
      "MunifTanjim/nui.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      local mlc = require("mason-lspconfig")
      mlc.setup({})

      local lsp_config = require("meg.lsp.config")
      lsp_config.setup_diagnostics()

      local nvim_lsp_configs = require("lspconfig")
      local user_opts = require("meg.lsp.sources").config()

      local utils = require("meg.utils")

      mlc.setup_handlers({
        function(server_name)
          local user_opt = user_opts[server_name]

          local opt = user_opt
          if user_opts == nil or utils.empty_tbl(user_opt) then opt = lsp_config.opt_builder() end

          nvim_lsp_configs[server_name].setup(opt)
        end,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "folke/lsp-colors.nvim" },
    cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
  },
  {
    "TwIStOy/right-click.nvim",
    allow_in_vscode = true,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      timeout = 3000,
      stages = "static",
      fps = 60,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    ft = {
      "vim",
      "lua",
    },
    cmd = {
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
      "ColorizerToggle",
    },
    opts = {
      filetypes = {
        "vim",
        "lua",
      },
      user_default_options = {
        RRGGBB = true,
        names = false,
        AARRGGBB = true,
        mode = "virtualtext",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
      local ft = vim.api.nvim_get_option_value("filetype", {
        buf = 0,
      })
      if ft == "vim" or ft == "lua" then require("colorizer").attach_to_buffer(0) end
    end,
  },
  {
    "folke/noice.nvim",
    event = { "ModeChanged", "BufReadPre", "InsertEnter" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        progress = { enabled = false, throttle = 1000 / 10 },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },
      messages = { enabled = false },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
    config = function(_, opts)
      vim.defer_fn(function() require("noice").setup(opts) end, 20)
    end,
  },

  --   --  { "tenxsoydev/size-matters.nvim", lazy = true },
  --   { "folke/lazy.nvim", tag = "v9.10.0" },
  --   { "nvim-tree/nvim-web-devicons", config = "plugins.devicons", eager = true },
  --   "nvim-lua/plenary.nvim",
  --
  { "goolord/alpha-nvim", config = "plugins.alpha", eager = true },
  --   --  { "windwp/windline.nvim", config = "plugins.windline", eager = true },
  --   --  { "gelguy/wilder.nvim", dependencies = "romgrk/fzy-lua-native", event = "CmdlineEnter", config = "plugins.wilder" },
  --   { "MunifTanjim/nui.nvim" },
  --   { "folke/noice.nvim", config = not vim.g.multigrid and "plugins.noice" or false },
  --   { "AckslD/messages.nvim", event = "VeryLazy", config = vim.g.multigrid and "plugins.messages" or false },
  --   { "rcarriga/nvim-notify", config = "plugins.notify", eager = true },
  --   --  { "nvim-neo-tree/neo-tree.nvim", dependencies = "MunifTanjim/nui.nvim", config = "plugins.neo-tree" },
  --   { "akinsho/toggleterm.nvim", event = "VeryLazy", config = "plugins.toggleterm" },
  --   { "willothy/flatten.nvim", priority = 100, config = "plugins.flatten" },
  { "numToStr/Comment.nvim", event = "VeryLazy", config = "plugins.comment" },
  { "folke/todo-comments.nvim", event = "VeryLazy", config = "plugins.todo-comments" },
  --   { "LudoPinelli/comment-box.nvim", event = "VeryLazy", config = "plugins.comment-box" },
  --   --  { "tversteeg/registers.nvim", event = "VeryLazy", config = "plugins.registers" },
  --   --  { "tenxsoydev/karen-yank.nvim", event = "VeryLazy", config = true },
  --   --
  --   --  -- Buffer- & Window Management -----------------------------------------------
  --   { "romgrk/barbar.nvim", event = "VeryLazy", config = "plugins.barbar" },
  --   { "kwkarlwang/bufresize.nvim", event = "VeryLazy", config = true }, -- handle split window sizes on client resize
  --   --  { "gorbit99/codewindow.nvim", event = "VeryLazy", config = "plugins.codewindow" },
  { "petertriho/nvim-scrollbar", event = "VeryLazy", config = "plugins.scrollbar" },
  --   --  { "s1n7ax/nvim-window-picker", event = "VeryLazy", config = "plugins.window-picker" },
  --   { "mrjones2014/smart-splits.nvim", event = "VeryLazy", config = "plugins.smart-splits" },
  --   { "m4xshen/smartcolumn.nvim", opts = {}, eventt = "VeryLazy" },
  --   --  {
  --   --    "anuvyklack/windows.nvim",
  --   --    dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
  --   --    event = "VeryLazy",
  --   --    config = "plugins.windows",
  --   --  },
  --   --  { "christoomey/vim-tmux-navigator", event = "VeryLazy", config = function() vim.keymap.del("", "<C-Bslash>") end },
  --   { "folke/zen-mode.nvim", event = "VeryLazy", config = "plugins.zen-mode" },
  --   --  { "nvimtools/none-ls.nvim", event = "VeryLazy" },
  --   --  { "sindrets/diffview.nvim", event = "VeryLazy", config = "plugins.diffview" },
  --   { "akinsho/git-conflict.nvim", event = "VeryLazy", config = "plugins.git-conflict" },
  --   { "f-person/git-blame.nvim", event = "VeryLazy" },
  --   { "ruifm/gitlinker.nvim", event = "VeryLazy", config = true },
  --   { "lewis6991/gitsigns.nvim", event = "VeryLazy", config = "plugins.gitsigns" },
  --   { "tobealive/neogit", branch = "fix-noice-commit-confirm-message", event = "VeryLazy", config = "plugins.neogit" },
  --   { "kair8m/git-worktree.nvim", event = "VeryLazy", config = "plugins.git-worktree" },
  --   { "toppair/peek.nvim", build = "deno task --quiet build:fast", event = "VeryLazy", config = "plugins.peek-nvim" },
  --   { "mattn/vim-gist", event = "VeryLazy", config = "plugins.gist" },
  --   { "mattn/webapi-vim" },
  --   --  { "chrisgrieser/nvim-spider", event = "VeryLazy" },
  --   --  { "Wansmer/treesj", event = "VeryLazy" },
  --   { "koenverburg/peepsight.nvim", event = "VeryLazy", config = "plugins.peepsight" },
  --   { "ray-x/starry.nvim", event = "VeryLazy" },
  --   {
  --     "ethanholz/nvim-lastplace",
  --     opts = {
  --       lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  --       lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
  --       lastplace_open_folds = true,
  --     },
  --   },
  --   {
  --     "nvim-treesitter/nvim-treesitter",
  --     build = ":TSUpdate",
  --     config = "plugins.treesitter",
  --   },
  { "nvim-treesitter/nvim-treesitter-context" },
  --   { "haringsrob/nvim_context_vt", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  --   { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  --   { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter/nvim-treesitter" },
  --   { "JoosepAlviste/nvim-ts-context-commentstring", dependencies = "nvim-treesitter/nvim-treesitter" },
  --   { "nvim-treesitter/playground", dependencies = "nvim-treesitter/nvim-treesitter" },
  --   --  {
  --   --    "mizlan/iswap.nvim",
  --   --    event = "VeryLazy",
  --   --    dependencies = "nvim-treesitter/nvim-treesitter",
  --   --    config = "plugins.iswap",
  --   --  },
  --   { "HiPhish/rainbow-delimiters.nvim", config = "plugins.rainbow-delimiters" },
  --   --  {
  --   --    "aarondiel/spread.nvim",
  --   --    event = "VeryLazy",
  --   --    dependencies = "nvim-treesitter/nvim-treesitter",
  --   --    config = "plugins.spread",
  --   --  },
  --   {
  --     "nvim-telescope/telescope.nvim",
  --     config = "plugins.telescope",
  --     tag = "0.1.4",
  --     dependencies = {
  --       { "nvim-lua/plenary.nvim" },
  --       { "nvim-lua/popup.nvim" },
  --       { "nvim-telescope/telescope-fzy-native.nvim", dependencies = "romgrk/fzy-lua-native", lazy = true },
  --       {
  --         "nvim-telescope/telescope-live-grep-args.nvim",
  --         version = "^1.0.0",
  --       },
  --     },
  --   },
  --   -- { "nvim-telescope/telescope-live-grep-args.nvim", lazy = true },
  --   -- { "nvim-telescope/telescope-media-files.nvim", lazy = true },
  --   -- { "gbrlsnchs/telescope-lsp-handlers.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, lazy = true },
  --   -- --  { "Maan2003/lsp_lines.nvim", lazy = true },
  --   -- {
  --   --   "nvim-telescope/telescope-file-browser.nvim",
  --   --   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  --   --   lazy = true,
  --   -- },
  --   -- { "kkharji/sqlite.lua", event = "VeryLazy" },
  --   -- { "smartpde/telescope-recent-files", lazy = true },
  --   -- { "nvim-telescope/telescope-smart-history.nvim", dependencies = { "kkharji/sqlite.lua" }, lazy = true },
  --   -- { "tknightz/telescope-termfinder.nvim", lazy = true },
  --   --  { "folke/neodev.nvim", config = true, lazy = true },
  --   { "neovim/nvim-lspconfig", config = "lsp.plugins.lspconfig" },
  --   { "jose-elias-alvarez/null-ls.nvim", config = "lsp.plugins.null-ls" }, -- inject external formatters and linters
  --   { "glepnir/lspsaga.nvim", event = "VeryLazy", config = "lsp.plugins.lspsaga" },
  --   --  { "j-hui/fidget.nvim", event = "VeryLazy", config = "lsp.plugins.fidget", tag = "legacy" },
  --    { "ray-x/lsp_signature.nvim", event = "VeryLazy", config = "lsp.plugins.lsp-signature" },
  --   --  { "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim", event = "VeryLazy", config = "lsp.plugins.lsp-toggle" },
  --   "b0o/SchemaStore.nvim",
  --   { "RRethy/vim-illuminate", dependencies = "nvim-treesitter/nvim-treesitter", config = "plugins.illuminate" },
  --   { "smjonas/inc-rename.nvim", branch = "main", config = "plugins.inc-rename" },
  --   --  -- Mason
  --   { "williamboman/mason.nvim", config = "lsp.plugins.mason" },
  --   --  -- stylua: ignore
  --   { "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
  --   { "jayp0521/mason-null-ls.nvim", dependencies = "williamboman/mason.nvim", config = true },
  --   { "jay-babu/mason-nvim-dap.nvim" },
  --   --  -- Language Specific
  --   -- { "simrat39/rust-tools.nvim", config = "lsp.plugins.rust-tools" },
  --   { "jose-elias-alvarez/typescript.nvim", lazy = true },
  --   { "onsails/lspkind.nvim", lazy = true },
  --   { "WhoIsSethDaniel/mason-tool-installer.nvim", event = "VeryLazy" },
  --   -- { "linux-cultist/venv-selector.nvim", config = "plugins.venv-selector", event = "VeryLazy" },
  --   { "kevinhwang91/nvim-bqf", event = "VeryLazy", config = "plugins.bqf" },
  --   { "folke/trouble.nvim", event = "VeryLazy", config = "plugins.trouble" },
  --   { "hrsh7th/nvim-cmp", event = "InsertEnter", config = "plugins.cmp" },
  --   "hrsh7th/cmp-buffer",
  --   "hrsh7th/cmp-path",
  --   "hrsh7th/cmp-cmdline",
  --   "hrsh7th/cmp-nvim-lsp",
  --   "chrisgrieser/cmp-nerdfont",
  --   "hrsh7th/cmp-nvim-lua",
  --   "hrsh7th/cmp-nvim-lsp-signature-help",
  --   "hrsh7th/cmp-nvim-lsp-document-symbol",
  --   { "Exafunction/codeium.vim", event = "InsertEnter", config = "plugins.codeium" },
  { "zbirenbaum/copilot.lua", config = "plugins.copilot" },
  --   { "zbirenbaum/copilot-cmp", dependencies = "zbirenbaum/copilot.lua", config = true },
  --   { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  --   -- Snippets
  --   { "L3MON4D3/LuaSnip", event = "VeryLazy", config = "plugins.luasnip" }, --snippet engine
  --   "saadparwaiz1/cmp_luasnip",
  --   { "tomasky/bookmarks.nvim", config = "plugins.bookmarks" },
  --   { "ThePrimeagen/harpoon", event = "VeryLazy", config = "plugins.harpoon" },
  --   { "olimorris/persisted.nvim", config = "plugins.persisted" },
  --   --  { "ahmedkhalf/project.nvim", config = "plugins.project" },
  --   --  { "chentoast/marks.nvim", event = "VeryLazy", config = "plugins.marks" },
  --   --  { "preservim/vim-markdown", config = "plugins.markdown", ft = "markdown" },
  --   --  { "dkarter/bullets.vim", ft = "markdown", config = "plugins.bullets" },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    event = "VeryLazy",
    config = "plugins.markdown-preview",
    ft = { "markdown" },
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
  },
  --   --  { "tenxsoydev/vim-markdown-checkswitch", ft = "markdown" },
  --   --  -- use nvim for PKM / Zettelkasten
  --   --  -- { "renerocksai/telekasten.nvim", config = "plugins.telekasten" },
  --   --  -- { "epwalsh/obsidian.nvim", config = "plugins.obsidian" },
  --   { "max397574/better-escape.nvim", event = "InsertEnter", config = "plugins.better-escape" }, -- remove delay from escape keys while typing in insert mode
  --   { "nat-418/boole.nvim", event = "VeryLazy", config = "plugins.boole" }, -- extend increment / decrement to cycle through related words
  --   { "stevearc/dressing.nvim", event = "VeryLazy", config = "plugins.dressing" },
  --   { "NMAC427/guess-indent.nvim", event = "VeryLazy", config = true },
  --   { "smoka7/hop.nvim", event = "VeryLazy", config = "plugins.hop" },
  --   { "kevinhwang91/nvim-hlslens", event = "VeryLazy", config = "plugins.hlslens" },
  --   { "edluffy/hologram.nvim", event = "VeryLazy" },
  --   { "lukas-reineke/indent-blankline.nvim", event = "VeryLazy", config = "plugins.indentline" },
  --   { "echasnovski/mini.nvim", config = "plugins.mini" },
  --   { "karb94/neoscroll.nvim", config = "plugins.neoscroll" },
  --   { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "windwp/nvim-autopairs", event = "VeryLazy", config = "plugins.autopairs" },
  --   { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = "plugins.colorizer" },
  --   { "RaafatTurki/hex.nvim", opts = {}, event = "VeryLazy" },
  { "windwp/nvim-spectre", event = "VeryLazy", config = "plugins.spectre" },
  --    { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async", config = "plugins.ufo" },
  --    { "michaelb/sniprun", event = "VeryLazy", build = "bash ./install.sh", config = "plugins.sniprun" },
  --   { "luukvbaal/statuscol.nvim", config = "plugins.statuscol" },
  --   { "levouh/tint.nvim", event = "VeryLazy", config = "plugins.tint" },
  --    { "tenxsoydev/tabs-vs-spaces.nvim", config = true, event = "VeryLazy" },
  --    { "andymass/vim-matchup", event = "VeryLazy", config = "plugins.matchup" }, -- highlight matching patterns and extend `%` navigation
  --   { "shellRaining/hlchunk.nvim", event = { "UIEnter" }, lazy = true, config = "plugins.hlchunk" },
  { "tpope/vim-repeat", event = "VeryLazy", lazy = true },
  --   { "tpope/vim-fugitive", lazy = true },
  --   { "kylechui/nvim-surround", version = "*", lazy = true, config = "plugins.surround" },
  --   { "andrewferrier/wrapping.nvim", lazy = true, config = "plugins.wrapping" },
  --   "mg979/vim-visual-multi", -- needs to be loaded outside of lazy.nvim for its global variable config values to work
  { "folke/which-key.nvim", event = "VeryLazy", config = "plugins.which-key" },
  --    { "smjonas/live-command.nvim", lazy = true, config = "plugins.live-command" },
  --    { "tamton-aquib/zone.nvim", lazy = true, config = "plugins.zone" },
  --   { "samodostal/image.nvim", lazy = true, config = true, config = "plugins.image" },
  --    { "simrat39/inlay-hints.nvim", lazy = true },
  --   { "mbbill/undotree", lazy = true, config = "plugins.undotree" },
  --    {
  --      "nvim-neotest/neotest",
  --      lazy = true,
  --      dependencies = {
  --        "nvim-lua/plenary.nvim",
  --        "nvim-treesitter/nvim-treesitter",
  --        "antoinemadec/FixCursorHold.nvim",
  --      },
  --      config = "plugins.neotest",
  --    },
  --
  { "dracula/vim", as = "dracula" },
  --   --  "folke/tokyonight.nvim",
  --   --  "olivercederborg/poimandres.nvim",
  --   --  { "spaceduck-theme/nvim", as = "spaceduck" },
  --   --  { "daschw/leaf.nvim" },
  --   --  { "slim-template/vim-slim", event = "FileType", ft = "slim" },
  --   {
  --     "michaelrommel/nvim-silicon",
  --     event = "VeryLazy",
  --     cmd = "Silicon",
  --     config = "plugins.silicon",
  --   },
  {
    "kristijanhusak/vim-carbon-now-sh",
    keys = {
      {
        "<F2>",
        ":CarbonNowSh<CR>",
        mode = { "v", "n" },
        desc = "Take code snapshot",
      },
    },
  },
  {
    "cseickel/diagnostic-window.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "LspAttach",
    init = function() vim.keymap.set("n", ";d", ":DiagWindowShow<CR>", { desc = "Show diagnostic window" }) end,
  },
  {
    "stevearc/conform.nvim",
    event = "LspAttach",
    config = "plugins.conform",
  },
}

-- { == Transform to LazySpec Table ==> =======================================

---Config load helper
---@param plugin_config string
---@param eager? "eager"
local function get(plugin_config, eager)
  if (plugin_config:match("plugins") or plugin_config:match("colorschemes")) and not plugin_config:match("meg") then
    plugin_config = "meg." .. plugin_config
  end

  if eager == "eager" then return function() require(plugin_config) end end

  return function()
    -- scheduled loading the majority of config files - results in 30-35% faster startup
    vim.schedule(function() require(plugin_config) end)
  end
end

for i, module in ipairs(modules) do
  if type(module) == "string" then goto continue end

  -- handle config string values (paths) else keep the module.config value
  if type(module.config) == "string" then
    if module.dir and module.dir:match("meg") and not module.config:match("meg") then
      module.config = "meg." .. module.config
    end
    if module.eager then
      ---@diagnostic disable-next-line: param-type-mismatch
      module.config = get(module.config, "eager")
    else
      ---@diagnostic disable-next-line: param-type-mismatch
      module.config = get(module.config)
    end
  end

  -- remove custom fields
  if module.eager then module.eager = nil end

  ::continue::
  modules[i] = module
end
-- <== }

-- { == Load Setup ==> ========================================================

lazy.setup(modules, {
  change_detection = { enabled = false },
  ui = { border = "rounded" },
  dev = { path = "~/code/neovim-plugins" },
  install = { missing = true },
  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "spellfile",
      },
    },
  },
})
--- <== }

-- { == Events ==> ============================================================

-- Add path for easy `gf` to the config file of a plugin in `get "<plugins.pluginname">` functions above
nx.au({
  "BufEnter",
  pattern = { vim.fn.stdpath("config") .. "*/init.lua" },
  callback = function()
    vim.opt_local.path = { ",,", vim.fn.stdpath("config") .. "/lua/meg/" }
    vim.cmd("setlocal inex=tr(v:fname,'.','/')")
  end,
})
-- <== }

--- { == Keymaps ==> ===========================================================

nx.map({ "<leader>P", "<Cmd>Lazy<CR>", desc = "Plugin Manager" })
--- <== }
