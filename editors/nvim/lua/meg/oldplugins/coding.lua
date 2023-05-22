-- Plugins: Coding

return {
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()

        local ls = require("luasnip")
        local s = ls.snippet
        local sn = ls.snippet_node
        local i = ls.insert_node
        local t = ls.text_node
        local c = ls.choice_node
        local fmt = require("luasnip.extras.fmt").fmt

        ls.config.set_config({
          history = true,
        })

        ls.add_snippets("v", {
          s("prt", fmt("println('{}')", { c(1, { sn(nil, { t("${"), i(1), t("}") }), t("") }) })),
          s("dbg", fmt("// DBG:\nprintln('{} <-')", { c(1, { sn(nil, { t("${"), i(1), t("}") }), t("") }) })),
        })

        nx.map({
          {
            "<C-n>",
            function()
              if ls.expand_or_jumpable() then ls.expand_or_jump() end
            end,
          },
          {
            "<C-p>",
            function()
              if ls.jumpable(-1) then ls.jump(-1) end
            end,
          },
          {
            "<C-g>",
            function()
              if ls.choice_active() then ls.change_choice(1) end
            end,
          },
          {
            "<C-t>",
            function()
              if ls.choice_active() then ls.change_choice(-1) end
            end,
          },
        }, { silent = true, mode = { "i", "s" } })
      end,
    },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp_kinds = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }

      local config = {
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "cmp_tabnine" },
          { name = "path" },
          { name = "nerdfont" },
          { name = "copilot" },
          -- { name = "emoji" },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            if entry.source.name == "cmp_tabnine" then item.kind = "Tabnine" end
            item.menu = item.kind

            local icon = cmp_kinds[item.kind]
            if entry.source.name == "cmp_tabnine" then icon = "⌬" end
            if entry.source.name == "copilot" then icon = "" end
            item.kind = icon

            return item
          end,
        },
        window = {
          completion = {
            border = "rounded",
            scrollbar = "║",
            winhighlight = "Normal:Normal", -- transparent bg
          },
          documentation = {
            border = "rounded",
            scrollbar = "║",
            winhighlight = "Normal:Normal",
          },
        },
        experimental = {
          ghost_text = false,
          -- native_menu = false,
        },
        mapping = {},
      }

      config.mapping = {
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<Up>"] = cmp.mapping.select_prev_item(),

        -- Misc
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),

        -- Invoke completion manually
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Confrim completion
        ["<C-l>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
        -- ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
        -- Use tab for codeium and it should fall back to cmp when it's inactive
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() and vim.g.codeium_enabled ~= 1 then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
          else
            fallback()
          end
        end, { "i", "s" }),
      }
      cmp.setup(config)
    end,
  },

  {
    'ziontee113/SnippetGenie',
    event = 'InsertEnter',
    dependencies = 'L3MON4D3/LuaSnip',
    opts = {
      snippets_directory = vim.fn.stdpath('config') .. '/snippets',
    },
  },

  -----------------------------------------------------------------------------
  {
    'danymat/neogen',
    keys = {
      {
        '<leader>cc',
        function() require('neogen').generate({}) end,
        desc = 'Neogen Comment',
      },
    },
    opts = { snippet_engine = 'luasnip' },
  },

  {
    'echasnovski/mini.splitjoin',
    main = 'mini.splitjoin',
    keys = {
      {
        'sj',
        '<cmd>lua MiniSplitjoin.join()<CR>',
        mode = { 'n', 'x' },
        desc = 'Join arguments'
      },
      {
        'sk',
        '<cmd>lua MiniSplitjoin.split()<CR>',
        mode = { 'n', 'x' },
        desc = 'Split arguments'
      },
    },
    opts = {
      mappings = { toggle = '' },
    },
  },

  {
    'AndrewRadev/linediff.vim',
    cmd = { 'Linediff', 'LinediffAdd' },
    keys = {
      { '<Leader>mdf', ':Linediff<CR>', mode = 'x', desc = 'Line diff' },
      { '<Leader>mda', ':LinediffAdd<CR>', mode = 'x', desc = 'Line diff add' },
      { '<Leader>mds', '<cmd>LinediffShow<CR>', desc = 'Line diff show' },
      { '<Leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
    }
  },

  {
    'AndrewRadev/dsf.vim',
    keys = {
      { 'dsf', '<Plug>DsfDelete', noremap = true, desc = 'Delete Surrounding Function' },
      { 'csf', '<Plug>DsfChange', noremap = true, desc = 'Change Surrounding Function' },
    },
    init = function()
      vim.g.dsf_no_mappings = 1
    end
  },

  -- Auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "chrisgrieser/cmp-nerdfont",
      "hrsh7th/cmp-nvim-lua",
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
          require("cmp_tabnine.config"):setup({
            max_lines = 1000,
            max_num_results = 20,
            sort = true,
            run_on_every_keystroke = true,
            snippet_placeholder = "..",
            ignored_file_types = { -- default is not to ignore
              -- uncomment to ignore in lua:
              -- lua = true
            },
            show_prediction_strength = false,
          })
        end,
      },
      {
        "Exafunction/codeium.vim",
        event = "InsertEnter",
        config = function()
          nx.au({ "FileType", pattern = "TelescopePrompt", callback = function() vim.cmd("Codeium DisableBuffer") end })
          nx.hl({ "CodeiumSuggestion", fg = "SpecialComment:fg", bold = false, italic = true })
          nx.map({ "<Tab>", function() return vim.fn["codeium#Accept"]() end, "i", expr = true })
          vim.cmd("Codeium Enable")
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
      {
        "zbirenbaum/copilot-cmp",
        dependencies = "zbirenbaum/copilot.lua",
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require('copilot_cmp')
          copilot_cmp.setup(opts)
          require('meg.lib.lsp').on_attach(function(client)
            if client.name == 'copilot' then
              copilot_cmp._on_insert_enter({})
            end
          end)
        end
      },
    },
    opts = function()
      local cmp = require("cmp")
      local confirm_copilot = cmp.mapping.confirm({
        select = true,
        behavior = cmp.ConfirmBehavior.Replace,
      })
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "copilot", group_index = 2, priority = 60 },
        }),
        formatting = {
          format = function(_, item)
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            require('copilot_cmp.comparators').prioritize,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          }
        }
      }
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup({
        mappings = {
          basic = true,
          extra = false,
          extended = false,
        }
      })

      local toggle = require("Comment.api").toggle
      nx.map({
        { "<C-/>", toggle.linewise.current, { "n", "i" }, desc = "Toggle Line Comment" },
        { "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "v", desc = "Toggle Line Comment" },
        { "<leader><C-/>", toggle.blockwise.current, desc = "Toggle Block Comment", wk_label = "ignore" },
        {
          "<leader><C-/>",
          function() toggle.blockwise(vim.fn.visualmode()) end,
          "v",
          desc = "Toggle Block Comment",
          wk_label = "ignore",
        },
        { "<C-_>", toggle.linewise.current, { "n", "i" }, desc = "Toggle Line Comment" },
        {
          "<C-_>",
          "<Esc><Cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
          "v",
          desc = "Toggle Line Comment",
        },
        {
          "<leader><C-_>",
          function() toggle.blockwise() end,
          desc = "Toggle Block Comment",
          wk_label = "ignore",
        },
        {
          "<leader><C-_>",
          function() toggle.blockwise(vim.fn.visualmode()) end,
          "v",
          desc = "Toggle Block Comment",
          wk_label = "ignore",
        },
      })
    end,
  },

  -- Better text objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
    init = function()
      -- load keymaps through which-key here
    end,
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- surround
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    config = true,
    keys = {
      { "<LocalLeader>re", function() require("telescope").extensions.refactoring.refactors() end, desc = "Open Refactoring.nvim", mode = { "n", "v", "x" }},
      { "<LocalLeader>rd", function() require("refactoring").debug.printf({ below = false }) end, desc = "Insert Printf statement for debugging" },
      {
        "<LocalLeader>rvn",
        function()
          require("refactoring").debug.print_var({ normal = true })
        end,
        desc = "Insert Print_var statement for debugging",
        mode = { "n", "v" }
      },
      {
        "<LocalLeader>rvx",
        function()
          require("refactoring").debug.print_var({})
        end,
        desc = "Insert Print_var statement for debugging",
        mode = { "n", "v" },
      },
      {
        "<LocalLeader>rc",
        function() require("refactoring").debug.cleanup() end,
        desc = "Cleanup debug statements"
      }
    }
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text", -- help to find variable definitions in debug mode
      "rcarriga/nvim-dap-ui", -- Nice UI for nvim-dap
    },
    keys = {
      { "<F1>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Set breakpoint" },
      { "<F2>", "<cmd>lua require('dap').continue()<CR>", desc = "Continue" },
      { "<F3>", "<cmd>lua require('dap').step_into()<CR>", desc = "Step into" },
      { "<F4>", "<Cmd>lua require('dap').step_over()<CR>", desc = "Step over" },
      {
        "<F5>",
        "<cmd>lua require('dap').toggle({ height = 6 })<CR>",
        desc = "Toggle REPL",
      },
      { "<F6>", "<cmd>lua require('dap').repl.run_last()<CR>", desc = "Run last" },
      {
        "<F9>",
        function()
          local ok, dap = pcall(require, "dap")
          if ok then
            dap.disconnect()
            require("dapui").close()
          end
        end,
        desc = "Stop",
      }
    },
    config = function()
      local dap = require("dap")


      ---Show the nice virtual text when debugging
      ---@return nil|function
      local function virtual_text_setup()
        local ok, virtual_text = om.safe_require("nvim-dap-virtual-text")
        if not ok then return end

        return virtual_text.setup()
      end

      ---Show custom virtual text when debugging
      ---@return nil
      local function signs_setup()
        vim.fn.sign_define("DapBreakpoint", {
          text = "",
          texthl = "DebugBreakpoint",
          linehl = "",
          numhl = "DebugBreakpoint",
        })
        vim.fn.sign_define("DapStopped", {
          text = "",
          texthl = "DebugHighlight",
          linehl = "",
          numhl = "DebugHighlight",
        })
      end

      ---Custom Ruby debugging config
      ---@param dap table
      ---@return nil
      local function ruby_setup(dap)
        dap.adapters.ruby = function(callback, config)
          local script

          if config.current_line then
            script = config.script .. ":" .. vim.fn.line(".")
          else
            script = config.script
          end

          callback({
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
              command = "bundle",
              args = { "exec", "rdbg", "--open", "--port", "${port}", "-c", "--", config.command, script },
            },
          })
        end

        dap.configurations.ruby = {
          {
            type = "ruby",
            name = "debug rspec current_line",
            request = "attach",
            localfs = true,
            command = "rspec",
            script = "${file}",
            current_line = true,
          },
          {
            type = "ruby",
            name = "debug current file",
            request = "attach",
            localfs = true,
            command = "ruby",
            script = "${file}",
          },
        }
      end

      ---Slick UI which is automatically triggered when debugging
      ---@param dap table
      ---@return nil
      local function ui_setup(dap)
        local ok, dapui = om.safe_require("dapui")
        if not ok then return end

        dapui.setup({
          layouts = {
            {
              elements = {
                "scopes",
                "breakpoints",
                "stacks",
              },
              size = 35,
              position = "left",
            },
            {
              elements = {
                "repl",
              },
              size = 0.30,
              position = "bottom",
            },
          },
        })
        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close
      end

      dap.set_log_level("TRACE")

      virtual_text_setup()
      signs_setup()
      ruby_setup(dap)
      ui_setup(dap)
    end,
  },
  {
    'sgur/vim-editorconfig',
    lazy = false,
    init = function ()
      vim.g.editorconfig_verbose = 1
      vim.g.editorconfig_blacklist = {
        filetype = {
          'git.*', 'fugitive', 'help', 'lsp-.*', 'any-jump', 'gina-.*'
        },
        pattern = {'\\.un~$'}
      }
    end
  },
  {
    'mattn/emmet-vim',
    ft = { 'html', 'css', 'vue', 'javascript', 'javascriptreact', 'svelte' },
    init = function()
      vim.g.user_emmet_mode = 'i'
      vim.g.user_emmet_install_global = 0
      vim.g.user_emmet_install_command = 0
      vim.g.user_emmet_complete_tag = 0
    end,
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('meg_emmet', {}),
        pattern = {
          'html', 'css', 'vue', 'javascript', 'javascriptreact', 'svelte'
        },
        callback = function()
          vim.cmd [[
EmmetInstall
imap <silent><buffer> <C-y> <Plug>(emmet-expand-abbr)
]]
        end
      })
    end
  },
  {
    'b3nj5m1n/kommentary',
    event = 'FileType',
    keys = {
      { '<Leader>v', '<Plug>kommentary_line_default' },
      { '<Leader>v', '<Plug>kommentary_visual_default<C-c>', mode = 'x' },
      { '<Leader>V', '<Plug>kommentary_visual_increase<C-c', mode = 'x' },
    },
    config = function()
      -- Setup context-aware commenting via nvim-ts-context-commentstring
      -- See also lua/plugins/treesitter.lua
      local update_commentstring = {
        hook_function = function()
          -- See https://github.com/JoosepAlviste/nvim-ts-context-commentstring
          require('ts_context_commentstring.internal').update_commentstring({})
        end,
        single_line_comment_string = 'auto',
        multi_line_comment_strings = 'auto',
      }

      local k = require('kommentary.config')
      k.configure_language('typescriptreact', update_commentstring)
      k.configure_language('javascriptreact', update_commentstring)
      k.configure_language('html', update_commentstring)
      k.configure_language('svelte', update_commentstring)
      k.configure_language('markdown', update_commentstring)

      k.configure_language('lua', {
        single_line_comment_string = '--',
        multi_line_comment_strings = { '--[[', ']]' },
        prefer_single_line_comments = true,
      })
    end,
  },
  {
    'machakann/vim-sandwich',
    keys = {
      -- See https://github.com/machakann/vim-sandwich/blob/master/macros/sandwich/keymap/surround.vim
      { 'ds', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)', silent = true },
      { 'dss', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)', silent = true },
      { 'cs', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)', silent = true },
      { 'css', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)', silent = true },
      { 'sa', '<Plug>(operator-sandwich-add)', silent = true, mode = { 'n', 'x', 'o' }},
      { 'ir', '<Plug>(textobj-sandwich-auto-i)', silent = true, mode = { 'x', 'o' }},
      { 'ab', '<Plug>(textobj-sandwich-auto-a)', silent = true, mode = { 'x', 'o' }},
    },
    init = function()
      vim.g.sandwich_no_default_key_mappings = 1
    end
  },
  -- Task runner and job management
  {
    "stevearc/overseer.nvim",
    opts = {
      component_aliases = {
        default_neotest = {
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_dispose",
        },
      },
      templates = { "java_build" },
    },
    init = function()
      -- create overseer commands here
    end,
    keys = {
      {
        "<Leader>o",
        function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,desc = "Run the last Overseer task",
      }
    }
  },

  -- Test runner
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",

      -- Adapters
      "nvim-neotest/neotest-plenary",
      "olimorris/neotest-rspec",
      "olimorris/neotest-phpunit",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-plenary"),
          require("neotest-rspec"),
          require("neotest-phpunit"),
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        diagnostic = {
          enabled = false,
        },
        log_level = 1,
        icons = {
          expanded = "",
          child_prefix = "",
          child_indent = "",
          final_child_prefix = "",
          non_collapsible = "",
          collapsed = "",

          passed = "",
          running = "",
          failed = "",
          unknown = "",
          skipped = "",
        },
        floating = {
          border = "single",
          max_height = 0.8,
          max_width = 0.9,
        },
        summary = {
          mappings = {
            attach = "a",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            output = "o",
            run = "r",
            short = "O",
            stop = "u",
          },
        },
      })
    end
  },

  {
    "preservim/vim-markdown",
    config = function()
      nx.set({
        vim_markdown_no_default_keymappings = 1,
        vim_markdown_new_list_item_indent = 0,
        vim_markdown_folding_style_pythonic = 1,
        vim_markdown_folding_level = 4,
      })
    end,
  },
  {
    "dkarter/bullets.vim",
    ft = "markdown",
    config = function()
      nx.set({
        bullets_set_mappings = 0,
        -- bullets_custom_mappings = { { "nmap", "<leader>x", "<nop>" }, { "nmap", ">", "<nop>" } },
        -- bullets_outline_levels = { 'ROM', 'ABC', 'num', 'abc', 'rom', 'std-', 'std*', 'std+' },
        bullets_outline_levels = { "num", "abc", "std*" },
        -- bullets_checkbox_markers = " ○●✓",
        bullets_checkbox_markers = " x",
        bullets_nested_checkboxes = 0,
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    event = "VeryLazy",
    config = function()
      nx.set({
        mkdp_theme = "dark",
        mkdp_auto_close = false,
      })
      nx.map({ "<leader>tp", "<Cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Toggle Markdown Preview" })
    end,
  },
  { "tenxsoydev/vim-markdown-checkswitch", ft = "markdown" },
}
