vim.g.multigrid = vim.api.nvim_list_uis()[1].ext_multigrid
local load_textobjects = false
-- [ Modules ] -----------------------------------------------------------------

---@class MegModule : LazyPluginSpec
---@diagnostic disable-next-line: duplicate-doc-field
---@field config? fun()|boolean|string @add `string` as possible config type.
---@field eager? boolean
-- Problem childs that need to be loaded outside of `lazy.setup`
require("meg.plugins.visual-multi") -- `VM_maps` config won't work otherwise afaik

local modules = {
  -- Modules
  { dir = "meg/colorschemes", priority = 90, config = "colorschemes", eager = true },
--   { dir = "meg/client", priority = 95, config = "client", eager = true },
--   -- { dir = "meg/keymaps", priority = 80, config = "keymaps", eager = true },
--   --{ dir = "meg/autocmds", priority = 80, config = "autocmds", eager = true },
--   { dir = "meg/settings", priority = 80, config = "settings", eager = true },
--   { dir = "meg/abbr", priority = 80, config = "abbr", eager = true },
--   { dir = "meg/statusline", priority = 80, config = "statusline", eager = true },
--   { dir = "meg/lsp", priority = 80, config = "lsp" },
--
   -- Must have utilities
--   "lewis6991/impatient.nvim",
  {
    "tenxsoydev/nx.nvim",
    priority = 1000,
    config = function()
      _G.nx = require("nx")
    end,
    eager = true,
  },
  { "folke/lazy.nvim", tag = "v9.10.0" },
  { "nvim-lua/plenary.nvim" },
  { "rcarriga/nvim-notify", config = "plugins.notify" },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "zt", "zz", "zb" },
      })
    end,
  },
  "lambdalisue/suda.vim",
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "907th/vim-auto-save",
    config = function()
      vim.g.auto_save = 1
    end,
  },
  "nvim-tree/nvim-web-devicons",
  {
    "folke/trouble.nvim",
    config = function()
      vim.cmd([[autocmd WinEnter * if winnr('$') == 1 && &ft == 'Trouble' | q | endif]])
      require('trouble').setup({
        action_keys = {
          ["close"] = "<C-c>",
          ["cancel"] = "<C-k>",
          ["refresh"] = "r",
          ["jump"] = "<cr>",
          ["hover"] = "K",
          ["toggle_fold"] = "<space>",
          ["previous"] = "<C-p>",
          ["next"] = "<C-n>",
        }
      })
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
--   { "nvim-lua/popup.nvim" },
--   {
--     "mrjones2014/legendary.nvim", -- A command palette for keymaps, commands and autocmds
--     priority = 99,
--     dependencies = {
--       "kkharji/sqlite.lua",
--       "tenxsoydev/nx.nvim",
--     },
--     init = function()
--       require("legendary").keymaps({
--         {
--           "<C-p>",
--           require("legendary").find,
--           hide = true
--           description = "Open Legendary",
--           mode = { "n", "v" },
--         },
--       })
--     end,
--     config = function()
--       require("legendary").setup({
--         select_prompt = "Legendary",
--         include_builtin = false,
--         include_legendary_cmds = false,
--         lazy_nvim = { auto_register = true },
--         which_key = { auto_register = false },
--         autocmds = require("meg.autocmds"),
--       })
--     end,
--   },
   {
     "dstein64/vim-startuptime", -- Profile your Neovim startup time
     cmd = "StartupTime",
     config = "plugins.startuptime",
     eager = true,
   },
   {
     "folke/persistence.nvim", -- Session Management.
     event = "BufReadPre",
     config = "plugins.persistence"
   },
   -- Fuzzy Finder
   {
     "nvim-telescope/telescope.nvim",
     cmd = "Telescope",
     config = "plugins.telescope"
   },
--   {
--     "kevinhwang91/nvim-bqf", -- Better quickfix window,
--     ft = "qf",
--   },
   { "folke/which-key.nvim", config = "plugins.which-key", eager = true },
   { "wakatime/vim-wakatime", eager = true },
--   { "anuvyklack/hydra.nvim", eager = true, config = "plugins.hydra" },
--
--   -- Editor Plugins
--   {
--     "cameron-wags/rainbow_csv.nvim",
--     config = true,
--     ft = {
--       "csv",
--       "tsv",
--       "csv_semicolon",
--       "csv_whitespace",
--       "csv_pipe",
--       "rfc_csv",
--       "rfc_semicolon",
--     },
--     cmd = {
--       "RainbowDelim",
--       "RainbowDelimSimple",
--       "RainbowDelimQuoted",
--       "RainbowMultiDelim",
--     },
--   },
--   {
--     "mfussenegger/nvim-jdtls", -- Extensions for nicer Java development in Neovim
--     ft = "java",
--     init = function()
--       require("legendary").commands({
--         itemgroup = "Java",
--         icon = "",
--         description = "Java functionality...",
--         commands = {
--           {
--             "JdtCompile",
--             description = "Compile the current project",
--           },
--           {
--             "JdtUpdateConfig",
--             description = "Update the configuration of the current project",
--           },
--         },
--       })
--     end,
--     keys = {
--       {
--         "<LocalLeader>o",
--         function() require("jdtls").organize_imports() end,
--         desc = "Java: Organize imports",
--       },
--     },
--   },
--
   {
     "stevearc/oil.nvim", -- File manager
     config = "plugins.oil"
   },
--     opts = {
--       keymaps = {
--         ["<C-c>"] = false,
--         ["<C-s>"] = "actions.save",
--         ["q"] = "actions.close",
--         [">"] = "actions.toggle_hidden",
--       },
--       buf_options = {
--         buflisted = false,
--       },
--       float = {
--         border = "none",
--       },
--       skip_confirm_for_simple_edits = true,
--     },
--     keys = {
--       { "-", function() require("oil").toggle_float(".") end, desc = "Open File Explorer" },
--       { "_", function() require("oil").toggle_float() end, desc = "Open File Explorer to current file" },
--     },
--   },
--   {
--     "stevearc/aerial.nvim", -- Toggled list of classes, methods etc in current file
--     cmd = "AerialToggle",
--     keys = {
--       {
--         "<C-t>",
--         function() require("aerial").toggle() end,
--         mode = { "n", "x", "o" },
--         desc = "Toggle Aerial",
--       },
--     },
--     opts = {
--       backends = {
--         ["_"] = { "lsp", "treesitter", "markdown" },
--         ruby = { "treesitter" },
--       },
--       close_on_select = true,
--       layout = {
--         min_width = 30,
--         default_direction = "prefer_right",
--       },
--     },
--   },
--   {
--     "folke/flash.nvim",
--     keys = {
--       {
--         "f",
--         function() require("flash").jump() end,
--         mode = { "n", "x", "o" },
--         desc = "Flash - Jump forwards",
--       },
--       {
--         "F",
--         function() require("flash").treesitter() end,
--         mode = { "o", "x" },
--         desc = "Flash - Jump backwards",
--       },
--       {
--         "S",
--         mode = { "n", "o", "x" },
--         function() require("flash").treesitter() end,
--         desc = "Flash Treesitter",
--       },
--       {
--         "r",
--         function() require("flash").remote() end,
--         mode = "o",
--         desc = "Remote Flash",
--       },
--     },
--     {
--       "folke/todo-comments.nvim", -- Highlight and search for todo comments within the codebase
--       event = "BufEnter",
--       init = function()
--         require("legendary").keymaps({
--           { "<Leader>t", "<cmd>TodoTelescope<CR>", description = "Todo comments" },
--         })
--       end,
--       opts = {
--         signs = false,
--         highlight = {
--           keyword = "bg",
--         },
--         keywords = {
--           FIX = { icon = " " }, -- Custom fix icon
--         },
--       },
--     },
--     {
--       "ahmedkhalf/project.nvim", -- Automatically set the cwd to the project root
--       opts = {
--         ignore_lsp = { "efm", "null-ls" },
--         patterns = { "Gemfile" },
--       },
--       config = function(_, opts) require("project_nvim").setup(opts) end,
--     },
--   },
--
--   -- Coding Related Plugins
--   "tpope/vim-sleuth", -- Automatically detects which indents should be used in the current buffer
--   {
--     "kylechui/nvim-surround", -- Use vim commands to surround text, tags with brackets, parenthesis etc
--     config = true,
--   },
--   {
--     "numToStr/Comment.nvim", -- Comment out lines with gcc
--     keys = { "gcc", { "gc", mode = "v" } },
--     init = function()
--       require("legendary").keymaps({
--         {
--           ":Comment",
--           {
--             n = "gcc",
--             v = "gc",
--           },
--           description = "Toggle comment",
--         },
--       })
--     end,
--     config = true,
--   },
--   {
--     "ThePrimeagen/refactoring.nvim", -- Refactor code like Martin Fowler
--     lazy = true,
--     init = function()
--       require("legendary").keymaps({
--         {
--           itemgroup = "Refactoring",
--           icon = "",
--           description = "Refactor code...",
--           keymaps = {
--             {
--               "<LocalLeader>re",
--               function() require("telescope").extensions.refactoring.refactors() end,
--               description = "Open Refactoring.nvim",
--               mode = { "n", "v", "x" },
--             },
--             {
--               "<LocalLeader>rd",
--               function() require("refactoring").debug.printf({ below = false }) end,
--               description = "Insert Printf statement for debugging",
--             },
--             {
--               "<LocalLeader>rv",
--               {
--                 n = function() require("refactoring").debug.print_var({ normal = true }) end,
--                 x = function() require("refactoring").debug.print_var({}) end,
--               },
--               description = "Insert Print_Var statement for debugging",
--               mode = { "n", "v" },
--             },
--             {
--               "<LocalLeader>rc",
--               function() require("refactoring").debug.cleanup() end,
--               description = "Cleanup debug statements",
--             },
--           },
--         },
--       })
--     end,
--     config = true,
--   },
--   {
--     "zbirenbaum/copilot.lua", -- AI programming
--     event = "InsertEnter",
--     keys = {
--       {
--         "<C-a>",
--         function() require("copilot.suggestion").accept() end,
--         desc = "Copilot: Accept suggestion",
--         mode = { "i" },
--       },
--       {
--         "<C-x>",
--         function() require("copilot.suggestion").dismiss() end,
--         desc = "Copilot: Dismiss suggestion",
--         mode = { "i" },
--       },
--       {
--         "<C-n>",
--         function() require("copilot.suggestion").next() end,
--         desc = "Copilot: Next suggestion",
--         mode = { "i" },
--       },
--       {
--         "<C-\\>",
--         function() require("copilot.panel").open() end,
--         desc = "Copilot: Show Copilot panel",
--         mode = { "n", "i" },
--       },
--     },
--     init = function()
--       require("legendary").commands({
--         {
--           ":CopilotToggle",
--           function() require("copilot.suggestion").toggle_auto_trigger() end,
--           description = "Copilot: Toggle on/off for buffer",
--         },
--       })
--     end,
--     opts = {
--       panel = {
--         auto_refresh = true,
--       },
--       suggestion = {
--         auto_trigger = true, -- Suggest as we start typing
--         keymap = {
--           accept_word = "<C-l>",
--           accept_line = "<C-j>",
--         },
--       },
--     },
--   },
--   {
--     "mfussenegger/nvim-dap", -- Debug Adapter Protocol for Neovim
--     lazy = true,
--     dependencies = {
--       "theHamsta/nvim-dap-virtual-text", -- help to find variable definitions in debug mode
--       "rcarriga/nvim-dap-ui", -- Nice UI for nvim-dap
--       "suketa/nvim-dap-ruby", -- Debug Ruby
--     },
--     init = function()
--       require("legendary").keymaps({
--         {
--           itemgroup = "Debug",
--           description = "Debugging functionality...",
--           icon = "",
--           keymaps = {
--             {
--               "<F1>",
--               "<cmd>lua require('dap').toggle_breakpoint()<CR>",
--               description = "Set breakpoint",
--             },
--             { "<F2>", "<cmd>lua require('dap').continue()<CR>", description = "Continue" },
--             { "<F3>", "<cmd>lua require('dap').step_into()<CR>", description = "Step into" },
--             { "<F4>", "<cmd>lua require('dap').step_over()<CR>", description = "Step over" },
--             {
--               "<F5>",
--               "<cmd>lua require('dap').repl.toggle({height = 6})<CR>",
--               description = "Toggle REPL",
--             },
--             { "<F6>", "<cmd>lua require('dap').repl.run_last()<CR>", description = "Run last" },
--             {
--               "<F9>",
--               function()
--                 local _, dap = mw.safe_require("dap")
--                 dap.disconnect()
--                 require("dapui").close()
--               end,
--               description = "Stop",
--             },
--           },
--         },
--       })
--     end,
--     config = function()
--       local dap = require("dap")
--       require("dap-ruby").setup()
--
--       ---Show the nice virtual text when debugging
--       ---@return nil|function
--       local function virtual_text_setup()
--         local ok, virtual_text = mw.safe_require("nvim-dap-virtual-text")
--         if not ok then return end
--
--         return virtual_text.setup()
--       end
--
--       ---Show custom virtual text when debugging
--       ---@return nil
--       local function signs_setup()
--         vim.fn.sign_define("DapBreakpoint", {
--           text = "",
--           texthl = "DebugBreakpoint",
--           linehl = "",
--           numhl = "DebugBreakpoint",
--         })
--         vim.fn.sign_define("DapStopped", {
--           text = "",
--           texthl = "DebugHighlight",
--           linehl = "",
--           numhl = "DebugHighlight",
--         })
--       end
--
--       ---Slick UI which is automatically triggered when debugging
--       ---@param dap table
--       ---@return nil
--       local function ui_setup(dap)
--         local ok, dapui = mw.safe_require("dapui")
--         if not ok then return end
--
--         dapui.setup({
--           layouts = {
--             {
--               elements = {
--                 "scopes",
--                 "breakpoints",
--                 "stacks",
--               },
--               size = 35,
--               position = "left",
--             },
--             {
--               elements = {
--                 "repl",
--               },
--               size = 0.30,
--               position = "bottom",
--             },
--           },
--         })
--         dap.listeners.after.event_initialized["dapui_config"] = dapui.open
--         dap.listeners.before.event_terminated["dapui_config"] = dapui.close
--         dap.listeners.before.event_exited["dapui_config"] = dapui.close
--       end
--
--       dap.set_log_level("TRACE")
--
--       virtual_text_setup()
--       signs_setup()
--       ui_setup(dap)
--     end,
--   },
--   {
--     "stevearc/overseer.nvim", -- Task runner and job management
--     lazy = true,
--     opts = {
--       component_aliases = {
--         default_neotest = {
--           "on_output_summarize",
--           "on_exit_set_status",
--           "on_complete_dispose",
--         },
--       },
--       templates = { "java_build" },
--     },
--     init = function()
--       require("legendary").commands({
--         {
--           itemgroup = "Overseer",
--           icon = "省",
--           description = "Task running functionality...",
--           commands = {
--             {
--               ":OverseerRun",
--               description = "Run a task from a template",
--             },
--             {
--               ":OverseerBuild",
--               description = "Open the task builder",
--             },
--             {
--               ":OverseerToggle",
--               description = "Toggle the Overseer window",
--             },
--           },
--         },
--       })
--       require("legendary").keymaps({
--         itemgroup = "Overseer",
--         keymaps = {
--           {
--             "<Leader>o",
--             function()
--               local overseer = require("overseer")
--               local tasks = overseer.list_tasks({ recent_first = true })
--               if vim.tbl_isempty(tasks) then
--                 vim.notify("No tasks found", vim.log.levels.WARN)
--               else
--                 overseer.run_action(tasks[1], "restart")
--               end
--             end,
--             description = "Run the last Overseer task",
--           },
--         },
--       })
--     end,
--   },
--   {
--     "nvim-neotest/neotest",
--     lazy = true,
--     dependencies = {
--       "nvim-lua/plenary.nvim",
--       "nvim-treesitter/nvim-treesitter",
--       "antoinemadec/FixCursorHold.nvim",
--
--       -- Adapters
--       "nvim-neotest/neotest-plenary",
--       "olimorris/neotest-rspec",
--       "olimorris/neotest-phpunit",
--     },
--     init = function()
--       require("legendary").keymaps({
--         {
--           itemgroup = "Neotest",
--           icon = "ﭧ",
--           description = "Testing functionality...",
--           keymaps = {
--             -- Neotest plugin
--             { "<LocalLeader>t", '<cmd>lua require("neotest").run.run()<CR>', description = "Neotest: Test nearest" },
--             {
--               "<LocalLeader>tf",
--               '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
--               description = "Neotest: Test file",
--             },
--             {
--               "<LocalLeader>tl",
--               '<cmd>lua require("neotest").run.run_last()<CR>',
--               description = "Neotest: Run last test",
--             },
--             {
--               "<LocalLeader>ts",
--               function()
--                 local neotest = require("neotest")
--                 for _, adapter_id in ipairs(neotest.run.adapters()) do
--                   neotest.run.run({ suite = true, adapter = adapter_id })
--                 end
--               end,
--               description = "Neotest: Test suite",
--             },
--             { "`", '<cmd>lua require("neotest").summary.toggle()<CR>', description = "Neotest: Toggle test summary" },
--           },
--         },
--       })
--     end,
--     config = function()
--       require("neotest").setup({
--         adapters = {
--           require("neotest-plenary"),
--           require("neotest-rspec"),
--           require("neotest-phpunit"),
--         },
--         consumers = {
--           overseer = require("neotest.consumers.overseer"),
--         },
--         diagnostic = {
--           enabled = false,
--         },
--         log_level = 1,
--         icons = {
--           expanded = "",
--           child_prefix = "",
--           child_indent = "",
--           final_child_prefix = "",
--           non_collapsible = "",
--           collapsed = "",
--
--           passed = "",
--           running = "",
--           failed = "",
--           unknown = "",
--           skipped = "",
--         },
--         floating = {
--           border = "single",
--           max_height = 0.8,
--           max_width = 0.9,
--         },
--         summary = {
--           mappings = {
--             attach = "a",
--             expand = { "<CR>", "<2-LeftMouse>" },
--             expand_all = "e",
--             jumpto = "i",
--             output = "o",
--             run = "r",
--             short = "O",
--             stop = "u",
--           },
--         },
--       })
--     end,
--   },
--
--   -- UI Plugins
--   {
--     "nvim-tree/nvim-web-devicons",
--     {
--       "folke/edgy.nvim",
--       event = "VeryLazy",
--       init = function() vim.opt.splitkeep = "screen" end,
--       opts = {
--         animate = { enabled = false },
--         bottom = {
--           {
--             ft = "lazyterm",
--             title = "Terminal",
--             size = { height = mw.on_big_screen() and 20 or 0.2 },
--             filter = function(buf) return not vim.b[buf].lazyterm_cmd end,
--           },
--           { ft = "qf", title = "QuickFix" },
--           {
--             ft = "help",
--             size = { height = 20 },
--             -- only show help buffers
--             filter = function(buf) return vim.bo[buf].buftype == "help" end,
--           },
--           { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
--         },
--         right = {
--           { ft = "aerial", title = "Symbols", size = { width = 0.3 } },
--           { ft = "neotest-summary", title = "Neotest Summary", size = { width = 0.3 } },
--           { ft = "oil", title = "File Explorer", size = { width = 0.3 } },
--         },
--       },
--     },
--     {
--       "lukas-reineke/virt-column.nvim", -- Use characters in the color column
--       config = true,
--     },
--     {
--       "tzachar/local-highlight.nvim", -- Highlight word under cursor throughout the visible buffer
--       opts = {
--         file_types = { "lua", "javascript", "python", "ruby" },
--       },
--     },
--     {
--       "stevearc/dressing.nvim", -- Utilises Neovim UI hooks to manage inputs, selects etc
--       opts = {
--         input = {
--           default_prompt = "> ",
--           relative = "editor",
--           prefer_width = 50,
--           prompt_align = "center",
--           win_options = { winblend = 0 },
--         },
--         select = {
--           get_config = function(opts)
--             opts = opts or {}
--             local config = {
--               telescope = {
--                 layout_config = {
--                   width = 0.8,
--                 },
--               },
--             }
--             if opts.kind == "legendary.nvim" then
--               config.telescope.sorter = require("telescope.sorters").fuzzy_with_index_bias({})
--             end
--             return config
--           end,
--         },
--       },
--     },
--     {
--       "lewis6991/gitsigns.nvim", -- Git signs in the statuscolumn
--       opts = {
--         signs = {
--           add = { hl = "GitSignsAdd", text = "▌" },
--           change = { hl = "GitSignsChange", text = "▌" },
--           delete = { hl = "GitSignsDelete", text = "▁" },
--           topdelete = { hl = "GitSignsDelete", text = "▔" },
--           changedelete = { hl = "GitSignsChange", text = "▁" },
--           untracked = { hl = "GitSignsUntracked", text = "▌" },
--         },
--       },
--     },
--     {
--       "NvChad/nvim-colorizer.lua", -- Highlight hex and rgb colors within Neovim
--       cmd = "ColorizerToggle",
--       init = function()
--         require("legendary").commands({
--           {
--             ":ColorizerToggle",
--             description = "Colorizer toggle",
--           },
--         })
--       end,
--       opts = {
--         filetypes = {
--           "css",
--           eruby = { mode = "foreground" },
--           html = { mode = "foreground" },
--           "lua",
--           "javascript",
--           "vue",
--         },
--       },
--     },
--     {
--       "lukas-reineke/indent-blankline.nvim", -- Show indentation lines
--       opts = {
--         use_treesitter = true,
--         show_first_indent_level = false,
--         show_trailing_blankline_indent = false,
--
--         -- filetype_exclude = filetypes_to_exclude,
--         buftype_exclude = { "terminal", "nofile" },
--       },
--     },
--     {
--       "goolord/alpha-nvim", -- Dashboard for Neovim
--       priority = 5, -- Load after persisted.nvim
--       init = function()
--         require("legendary").commands({
--           {
--             ":Alpha",
--             description = "Show the Alpha dashboard",
--           },
--         })
--       end,
--       config = function()
--         local alpha = require("alpha")
--
--         require("alpha.term")
--         local dashboard = require("alpha.themes.dashboard")
--
--         -- Terminal header
--         dashboard.section.terminal.command = "cat | lolcat --seed=24 "
--         .. os.getenv("HOME")
--         .. "/.config/nvim/static/neovim.cat"
--         dashboard.section.terminal.width = 69
--         dashboard.section.terminal.height = 8
--
--         local function button(sc, txt, keybind, keybind_opts)
--           local b = dashboard.button(sc, txt, keybind, keybind_opts)
--           b.opts.hl = "AlphaButtonText"
--           b.opts.hl_shortcut = "AlphaButtonShortcut"
--           return b
--         end
--
--         dashboard.section.buttons.val = {
--           button("l", "   Load session", "<cmd>lua require('persisted').load()<CR>"),
--           button("n", "   New file", "<cmd>ene <BAR> startinsert <CR>"),
--           button("r", "   Recent files", "<cmd>Telescope frecency workspace=CWD<CR>"),
--           button("f", "   Find file", "<cmd>Telescope find_files hidden=true path_display=smart<CR>"),
--           button("s", "󱘣   Search files", "<cmd>Telescope live_grep path_display=smart<CR>"),
--           -- button("p", "   Projects", "<cmd>Telescope projects<CR>"),
--           button("u", "   Update plugins", "<cmd>lua require('lazy').sync()<CR>"),
--           button("q", "   Quit Neovim", "<cmd>qa!<CR>"),
--         }
--         dashboard.section.buttons.opts = {
--           spacing = 0,
--         }
--
--         -- Footer
--         local function footer()
--           local total_plugins = require("lazy").stats().count
--           local version = vim.version()
--           local nvim_version_info = "  Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch
--
--           return " " .. total_plugins .. " plugins" .. nvim_version_info
--         end
--
--         dashboard.section.footer.val = footer()
--         dashboard.section.footer.opts.hl = "AlphaFooter"
--
--         -- Layout
--         if mw.on_big_screen() then
--           dashboard.config.layout = {
--             { type = "padding", val = 5 },
--             dashboard.section.terminal,
--             { type = "padding", val = 5 },
--             dashboard.section.buttons,
--             { type = "padding", val = 2 },
--             dashboard.section.footer,
--           }
--         else
--           dashboard.config.layout = {
--             { type = "padding", val = 1 },
--             dashboard.section.terminal,
--             { type = "padding", val = 2 },
--             dashboard.section.buttons,
--             { type = "padding", val = 1 },
--             dashboard.section.footer,
--           }
--         end
--
--         dashboard.config.opts.noautocmd = false
--
--         alpha.setup(dashboard.opts)
--       end,
--     },
--   },
--
   -- Treesitter Plugins
   {
     "nvim-treesitter/nvim-treesitter", -- Smarter code understanding like syntax Highlight and navigation
     build = ":TSUpdate",
     dependencies = {
       {
         "nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects, select, move, swap, and peek support.
         init = function()
           require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
           load_textobjects = true
         end,
       }
     },
     cmd = { "TSUpdateSync" },
     keys = {
       { "<c-space>", desc = "Increment selection" },
       { "<bs>", desc = "Decrement selection", mode = "x" },
     },
     opts = {
       highlight = { enable = true },
       indent = { enable = true },
       ensure_installed = {
         "bash",
         "c",
         "html",
         "javascript",
         "jsdoc",
         "json",
         "lua",
         "luadoc",
         "luap",
         "markdown",
         "markdown_inline",
         "python",
         "query",
         "regex",
         "ruby",
         "tsx",
         "typescript",
         "vim",
         "vimdoc",
         "yaml",
       },
       incremental_selection = {
         enable = true,
         keymaps = {
           init_selection = "<C-space>",
           node_incremental = "<C-space>",
           scope_incremental = false,
           node_decremental = "<bs>",
         },
       },
     },
     ---@param opts TSConfig
     config = function(_, opts)
       if type(opts.ensure_installed) == "table" then
         ---@type table<string, boolean>
         local added = {}
         opts.ensure_installed = vim.tbl_filter(function(lang)
           if added[lang] then
             return false
           end
           added[lang] = true
           return true
         end, opts.ensure_installed)
       end
       require("nvim-treesitter.configs").setup(opts)

       if load_textobjects then
         -- PERF: no need to load the plugin, if we only need its queries for mini.ai
         if opts.textobjects then
           for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
             if opts.textobjects[mod] and opts.textobjects[mod].enable then
               local Loader = require("lazy.core.loader")
               Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
               local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
               require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
               break
             end
           end
         end
       end
     end,
   },
--       "JoosepAlviste/nvim-ts-context-commentstring", -- Smart commenting in multi language files - Enabled in Treesitter file
--       {
--         "windwp/nvim-ts-autotag", -- Autoclose and autorename HTML and Vue tags
--         config = true,
--       },
--       "RRethy/nvim-treesitter-endwise", -- Automatically add end keywords for Ruby, Lua, Python, and more
--       {
--         "windwp/nvim-autopairs", -- Autopair plugin
--         opts = {
--           close_triple_quotes = true,
--           check_ts = true,
--           enable_moveright = true,
--           fast_wrap = {
--             map = "<c-e>",
--           },
--         },
--         config = function(_, opts)
--           local autopairs = require("nvim-autopairs")
--
--           autopairs.setup(opts)
--
--           local Rule = require("nvim-autopairs.rule")
--           local ts_conds = require("nvim-autopairs.ts-conds")
--
--           autopairs.add_rules({
--             Rule("{{", "  }", "vue"):set_end_pair_length(2):with_pair(ts_conds.is_ts_node("text")),
--           })
--         end,
--       },
--       {
--         "abecodes/tabout.nvim", -- Tab out from parenthesis, quotes, brackets...
--         opts = {
--           tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
--           backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
--           completion = true, -- We use tab for completion so set this to true
--         },
--       },
--     },
--     config = function()
--       require("nvim-treesitter.configs").setup({
--         ensure_installed = "all",
--         ignore_install = { "phpdoc", "wing" }, -- list of parser which cause issues or crashes
--         highlight = { enable = true },
--         incremental_selection = {
--           enable = true,
--           keymaps = {
--             init_selection = "<M-w>",
--             scope_incremental = "<CR>",
--             node_incremental = "<Tab>", -- increment to the upper named parent
--             node_decremental = "<S-Tab>", -- decrement to the previous node
--           },
--         },
--         indent = { enable = true },
--
--         -- nvim-ts-autotag plugin
--         autotag = { enable = true },
--
--         -- nvim-treesitter-endwise plugin
--         endwise = { enable = true },
--
--         -- nvim-ts-context-commentstring plugin
--         context_commentstring = { enable = true },
--
--         -- playground
--         playground = {
--           enable = true,
--           disable = {},
--           updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--           persist_queries = false, -- Whether the query persists across vim sessions
--           keybindings = {
--             toggle_query_editor = "o",
--             toggle_hl_groups = "i",
--             toggle_injected_languages = "t",
--             toggle_anonymous_nodes = "a",
--             toggle_language_display = "I",
--             focus_language = "f",
--             unfocus_language = "F",
--             update = "R",
--             goto_node = "<cr>",
--             show_help = "?",
--           },
--         },
--
--         textobjects = {
--           select = {
--             enable = true,
--             lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--
--             keymaps = {
--               -- Use v[keymap], c[keymap], d[keymap] to perform any operation
--               ["af"] = "@function.outer",
--               ["if"] = "@function.inner",
--               ["ac"] = "@class.outer",
--             },
--           },
--         },
--       })
--     end,
--   },
--
--   -- Telescope Plugins
--   {
--     "nvim-telescope/telescope.nvim", -- Awesome fuzzy finder for everything
--     lazy = true,
--     cmd = "Telescope",
--     dependencies = {
--       "nvim-lua/plenary.nvim",
--       {
--         "debugloop/telescope-undo.nvim", -- Visualise undotree
--         init = function()
--           require("legendary").keymaps({
--             { "<LocalLeader>u", "<cmd>Telescope undo<CR>", description = "Telescope undo" },
--           })
--         end,
--       },
--       {
--         "nvim-telescope/telescope-fzf-native.nvim", -- Use fzf within Telescope
--         build = "make",
--       },
--       {
--         "nvim-telescope/telescope-frecency.nvim", -- Get frequently opened files
--         dependencies = {
--           "kkharji/sqlite.lua",
--         },
--       },
--     },
--     init = function()
--       local t = require("legendary.toolbox")
--       require("legendary").keymaps({
--         {
--           itemgroup = "Telescope",
--           description = "Gaze deeply into unknown regions using the power of the moon",
--           icon = "",
--           keymaps = {
--             {
--               "<C-f>",
--               t.lazy_required_fn("telescope.builtin", "find_files", { hidden = true }),
--               description = "Find files",
--             },
--             {
--               "<C-g>",
--               t.lazy_required_fn(
--                 "telescope.builtin",
--                 "live_grep",
--                 { prompt_title = "Open Files", path_display = { "shorten" }, grep_open_files = true }
--               ),
--               description = "Find in open files",
--             },
--             {
--               "<Leader>g",
--               t.lazy_required_fn("telescope.builtin", "live_grep", { prompt_title = "Search CWD", path_display = { "smart" } }),
--               description = "Search CWD",
--             },
--             {
--               "<C-b>",
--               t.lazy_required_fn("telescope.builtin", "buffers", { prompt_title = "Buffer List", path_display = { "smart" } }),
--               description = "List buffers",
--             },
--             {
--               "<Leader><Leader>",
--               "<cmd>lua require('telescope').extensions.frecency.frecency({ prompt_title = 'Recent Files', workspace = 'CWD' })<CR>",
--               description = "Find recent files",
--             },
--           },
--         },
--       })
--     end,
--     config = function()
--       local actions = require("telescope.actions")
--       local action_state = require("telescope.actions.state")
--       local custom_actions = {}
--
--       function custom_actions.multi_select(prompt_bufnr)
--         local function get_table_size(t)
--           local count = 0
--           for _ in pairs(t) do
--             count = count + 1
--           end
--           return count
--         end
--
--         local picker = action_state.get_current_picker(prompt_bufnr)
--         local num_selections = get_table_size(picker:get_multi_selection())
--
--         if num_selections > 1 then
--           actions.send_selected_to_qflist(prompt_bufnr)
--           actions.open_qflist()
--         else
--           actions.file_edit(prompt_bufnr)
--         end
--       end
--
--       local telescope = require("telescope")
--       telescope.setup({
--         defaults = {
--           -- Appearance
--           entry_prefix = "  ",
--           prompt_prefix = "   ",
--           selection_caret = "  ",
--           color_devicons = true,
--           path_display = { "smart" },
--           dynamic_preview_title = true,
--
--           sorting_strategy = "ascending",
--           layout_strategy = "horizontal",
--           layout_config = {
--             horizontal = {
--               height = mw.on_big_screen() and 0.6 or 0.95,
--               preview_width = 0.55,
--               prompt_position = "top",
--               width = 0.9,
--             },
--             center = {
--               anchor = "N",
--               width = 0.9,
--               preview_cutoff = 10,
--             },
--             vertical = {
--               height = mw.on_big_screen() and 0.4 or 0.9,
--               preview_height = 0.3,
--               width = 0.9,
--               preview_cutoff = 10,
--               prompt_position = "top",
--             },
--           },
--
--           -- Searching
--           set_env = { COLORTERM = "truecolor" },
--           file_ignore_patterns = {
--             ".git/",
--             "%.csv",
--             "%.jpg",
--             "%.jpeg",
--             "%.png",
--             "%.svg",
--             "%.otf",
--             "%.ttf",
--             "%.lock",
--             "__pycache__",
--             "%.sqlite3",
--             "%.ipynb",
--             "vendor",
--             "node_modules",
--             "dotbot",
--           },
--           file_sorter = require("telescope.sorters").get_fuzzy_file,
--
--           -- Mappings
--           mappings = {
--             i = {
--               ["<esc>"] = require("telescope.actions").close,
--               ["<C-e>"] = custom_actions.multi_select,
--               ["<C-c>"] = require("telescope.actions").delete_buffer,
--               ["<C-j>"] = require("telescope.actions").move_selection_next,
--               ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
--               ["<C-f>"] = require("telescope.actions").preview_scrolling_up,
--               ["<C-k>"] = require("telescope.actions").move_selection_previous,
--               ["<C-q>"] = require("telescope.actions").send_to_qflist,
--             },
--             n = {
--               ["q"] = require("telescope.actions").close,
--               ["<C-n>"] = require("telescope.actions").move_selection_next,
--               ["<C-p>"] = require("telescope.actions").move_selection_previous,
--             },
--           },
--         },
--
--         extensions = {
--           frecency = {
--             show_scores = false,
--             show_unindexed = false,
--             ignore_patterns = {
--               "*.git/*",
--               "*/tmp/*",
--               "*/node_modules/*",
--               "*/vendor/*",
--             },
--             -- workspaces = {
--             --   ["nvim"] = os.getenv("HOME_DIR") .. ".config/nvim",
--             --   ["dots"] = os.getenv("HOME_DIR") .. ".dotfiles",
--             --   ["project"] = os.getenv("PROJECT_DIR"),
--             -- },
--           },
--           fzf = {
--             fuzzy = true,
--             override_generic_sorter = true,
--             override_file_sorter = true,
--             case_mode = "smart_case",
--           },
--           undo = {
--             mappings = {
--               i = {
--                 ["<CR>"] = require("telescope-undo.actions").restore,
--                 ["<C-a>"] = require("telescope-undo.actions").yank_additions,
--                 ["<C-d>"] = require("telescope-undo.actions").yank_deletions,
--               },
--             },
--           },
--         },
--       })
--
--       -- Extensions
--       telescope.load_extension("fzf")
--       telescope.load_extension("undo")
--       telescope.load_extension("aerial")
--       telescope.load_extension("frecency")
--       telescope.load_extension("persisted")
--       telescope.load_extension("refactoring")
--     end,
--   },
--
--   -- LSP Plugins
--   {
--     "SmiteshP/nvim-navic", -- Winbar component showing current code context
--     opts = {
--       highlight = true,
--       separator = "  ",
--     },
--   },
--   {
--     "famiu/bufdelete.nvim", -- Easily close buffers whilst preserving your window layouts
--     cmd = "Bdelete",
--     init = function()
--       require("legendary").keymaps({
--         { "<C-c>", "<cmd>Bdelete<CR>", hide = true, description = "Close Buffer" }, -- bufdelete.nvim
--         { "<Tab>", "<cmd>bnext<CR>", hide = true, description = "Next buffer", opts = { noremap = false } }, -- Heirline.nvim
--         { "<S-Tab>", "<cmd>bprev<CR>", hide = true, description = "Previous buffer", opts = { noremap = false } }, -- Heirline.nvim
--       })
--     end,
--   },
--   {
--     "VonHeikemen/lsp-zero.nvim",
--     branch = "v2.x",
--     dependencies = {
--       -- LSP Support
--       "neovim/nvim-lspconfig",
--       {
--         "williamboman/mason.nvim",
--         build = function() pcall(vim.cmd, "MasonUpdate") end,
--       },
--       "williamboman/mason-lspconfig.nvim",
--
--       -- Autocompletion
--       "hrsh7th/nvim-cmp",
--       "hrsh7th/cmp-buffer",
--       "hrsh7th/cmp-path",
--       "hrsh7th/cmp-cmdline",
--       "saadparwaiz1/cmp_luasnip",
--       "hrsh7th/cmp-nvim-lsp",
--       "hrsh7th/cmp-nvim-lsp-signature-help",
--       "hrsh7th/cmp-nvim-lua",
--       "lukas-reineke/cmp-under-comparator",
--       {
--         "zbirenbaum/copilot-cmp",
--         config = function() require("copilot_cmp").setup() end,
--       },
--       "onsails/lspkind.nvim",
--
--       -- Snippets
--       "L3MON4D3/LuaSnip",
--       "rafamadriz/friendly-snippets",
--
--       -- Misc
--       {
--         "KostkaBrukowa/definition-or-references.nvim", -- Definition and references in a single command
--         config = function()
--           local function handle_references_response(result)
--             require("telescope.pickers")
--               .new({}, {
--                 prompt_title = "LSP References",
--                 finder = require("telescope.finders").new_table({
--                   results = vim.lsp.util.locations_to_items(result, "utf-16"),
--                   entry_maker = require("telescope.make_entry").gen_from_quickfix(),
--                 }),
--                 layout_strategy = "center",
--                 previewer = require("telescope.config").values.qflist_previewer({}),
--               })
--               :find()
--           end
--
--           require("definition-or-references").setup({
--             on_references_result = handle_references_response,
--           })
--         end,
--       },
--       {
--         "VidocqH/lsp-lens.nvim", -- Display references and definitions
--         config = true,
--       },
--     },
--     init = function()
--       require("legendary").commands({
--         {
--           ":Mason",
--           description = "Open Mason",
--         },
--         {
--           ":MasonUninstallAll",
--           description = "Uninstall all Mason packages",
--         },
--       })
--       require("legendary").keymaps({
--         itemgroup = "Completion",
--         icon = "",
--         description = "Completion related functionality...",
--         keymaps = {
--           {
--             "<Enter>",
--             description = "Confirms selection",
--           },
--           {
--             "<Up>",
--             description = "Go to previous item on the list",
--           },
--           {
--             "<Down>",
--             description = "Go to next item on the list",
--           },
--           {
--             "<Ctrl-e>",
--             description = "Toggle completion menu",
--           },
--           {
--             "<Ctrl-h>",
--             description = "Go to previous placeholder in snippet",
--           },
--           {
--             "<Ctrl-l>",
--             description = "Go to next placeholder in snippet",
--           },
--           {
--             "<Tab>",
--             description = "Enable completion when inside a word OR go to next item",
--           },
--           {
--             "<S-Tab>",
--             description = "Go to previous item",
--           },
--         },
--       })
--     end,
--     config = function()
--       vim.o.runtimepath = vim.o.runtimepath .. ",~/.dotfiles/languages/snippets"
--
--       local lsp = require("lsp-zero").preset({
--         set_lsp_keymaps = false,
--         manage_nvim_cmp = {
--           set_basic_mappings = true,
--         },
--       })
--
--       lsp.set_sign_icons({
--         error = " ",
--         warn = " ",
--         hint = " ",
--         info = " ",
--       })
--
--       lsp.ensure_installed({
--         "bashls",
--         "cssls",
--         "dockerls",
--         "efm",
--         "html",
--         "intelephense",
--         "jdtls",
--         "jsonls",
--         "lua_ls",
--         "pyright",
--         "solargraph",
--         -- "tailwindcss", -- Disabled due to high node CPU usage
--         "tsserver",
--         "vuels",
--         "yamlls",
--       })
--
--       -- we will use nvim-jdtls to setup the lsp
--       lsp.skip_server_setup({ "jdtls" })
--
--       lsp.set_server_config({
--         capabilities = {
--           textDocument = {
--             foldingRange = {
--               dynamicRegistration = false,
--               lineFoldingOnly = true,
--             },
--           },
--         },
--       })
--
--       local function autocmds(client, bufnr)
--         require("legendary").autocmds({
--           {
--             name = "LspOnAttachAutocmds",
--             clear = false,
--             {
--               { "CursorHold", "CursorHoldI" },
--               ":silent! lua vim.lsp.buf.document_highlight()",
--               opts = { buffer = bufnr },
--             },
--             {
--               "CursorMoved",
--               ":silent! lua vim.lsp.buf.clear_references()",
--               opts = { buffer = bufnr },
--             },
--           },
--         })
--       end
--
--       local function commands(client, bufnr)
--         -- Only need to set these once!
--         if vim.g.lsp_commands then return {} end
--
--         require("legendary").commands({
--           {
--             ":LspRestart",
--             description = "Restart any attached clients",
--           },
--           {
--             ":LspStart",
--             description = "Start the client manually",
--           },
--           {
--             ":LspInfo",
--             description = "Show attached clients",
--           },
--           {
--             "LspInstallAll",
--             function()
--               for _, name in pairs(mw.lsp.servers) do
--                 vim.cmd("LspInstall " .. name)
--               end
--             end,
--             description = "Install all servers",
--           },
--           {
--             "LspUninstallAll",
--             description = "Uninstall all servers",
--           },
--           {
--             "LspLog",
--             function() vim.cmd("edit " .. vim.lsp.get_log_path()) end,
--             description = "Show logs",
--           },
--         })
--
--         vim.g.lsp_commands = true
--       end
--
--       local function mappings(client, bufnr)
--         if
--           #vim.tbl_filter(
--             function(keymap) return (keymap.desc or ""):lower() == "rename symbol" end,
--             vim.api.nvim_buf_get_keymap(bufnr, "n")
--           ) > 0
--         then
--           return
--         end
--
--         local t = require("legendary.toolbox")
--
--         require("legendary").keymaps({
--           itemgroup = "LSP",
--           icon = "",
--           description = "LSP related functionality",
--           keymaps = {
--             {
--               "gf",
--               t.lazy_required_fn("telescope.builtin", "diagnostics", {
--                 layout_strategy = "center",
--                 bufnr = 0,
--               }),
--               description = "Find diagnostics",
--               opts = { noremap = true },
--             },
--             -- { "gd", vim.lsp.buf.definition, description = "Go to definition", opts = { buffer = bufnr } },
--             {
--               "gd",
--               require("definition-or-references").definition_or_references,
--               description = "Go to definition/reference",
--               opts = { silent = true },
--             },
--             { "gi", vim.lsp.buf.implementation, description = "Go to implementation", opts = { buffer = bufnr } },
--             { "gt", vim.lsp.buf.type_definition, description = "Go to type definition", opts = { buffer = bufnr } },
--             -- {
--             --   "gr",
--             --   t.lazy_required_fn("telescope.builtin", "lsp_references", {
--             --     layout_strategy = "center",
--             --   }),
--             --   description = "Find references",
--             --   opts = { buffer = bufnr },
--             -- },
--             {
--               "gl",
--               "<cmd>lua vim.diagnostic.open_float(0, { border = 'single', source = 'always' })<CR>",
--               description = "Line diagnostics",
--               opts = { buffer = bufnr },
--             },
--             {
--               "K",
--               vim.lsp.buf.hover,
--               description = "Show hover information",
--               opts = {
--                 buffer = bufnr,
--               },
--             },
--             {
--               "<LocalLeader>p",
--               t.lazy_required_fn("nvim-treesitter.textobjects.lsp_interop", "peek_definition_code", "@block.outer"),
--               description = "Peek definition",
--               opts = { buffer = bufnr },
--             },
--             {
--               "ga",
--               vim.lsp.buf.code_action,
--               description = "Show code actions",
--               opts = {
--                 buffer = bufnr,
--               },
--             },
--             {
--               "gs",
--               vim.lsp.buf.signature_help,
--               description = "Show signature help",
--               opts = {
--                 buffer = bufnr,
--               },
--             },
--             {
--               "<LocalLeader>rn",
--               vim.lsp.buf.rename,
--               description = "Rename symbol",
--               opts = {
--                 buffer = bufnr,
--               },
--             },
--
--             {
--               "[",
--               vim.diagnostic.goto_prev,
--               description = "Go to previous diagnostic item",
--               opts = { buffer = bufnr },
--             },
--             { "]", vim.diagnostic.goto_next, description = "Go to next diagnostic item", opts = { buffer = bufnr } },
--           },
--         })
--       end
--
--       lsp.on_attach(function(client, bufnr)
--         autocmds(client, bufnr)
--         commands(client, bufnr)
--         mappings(client, bufnr)
--
--         if client.name == "efm" then
--           client.server_capabilities.documentFormattingProvider = true
--           client.server_capabilities.documentFormattingRangeProvider = true
--         end
--
--         if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, bufnr) end
--       end)
--
--       lsp.format_mapping("gq", {
--         format_opts = {
--           async = false,
--           timeout_ms = 10000,
--         },
--         servers = {
--           ["efm"] = {
--             "css",
--             "fish",
--             "html",
--             "lua",
--             "java",
--             "javascript",
--             "json",
--             "typescript",
--             "markdown",
--             "php",
--             "python",
--             "sh",
--             "vue",
--             "yaml",
--           },
--           ["solargraph"] = { "ruby" },
--         },
--       })
--
--       lsp.setup()
--
--       vim.diagnostic.config({
--         severity_sort = true,
--         signs = true,
--         underline = false,
--         update_in_insert = true,
--         virtual_text = false,
--         -- virtual_text = {
--         --   prefix = "",
--         --   spacing = 0,
--         -- },
--       })
--
--       -- Setup better folding
--       local ok, ufo = pcall(require, "ufo")
--       if ok then require("ufo").setup() end
--
--       --Setup completion
--       local cmp = require("cmp")
--       local cmp_action = require("lsp-zero").cmp_action()
--       local luasnip = require("luasnip")
--
--       require("luasnip.loaders.from_vscode").lazy_load()
--
--       vim.opt.completeopt = { "menu", "menuone", "noselect" }
--
--       cmp.setup({
--         formatting = {
--           format = function(...) return require("lspkind").cmp_format({ mode = "symbol_text" })(...) end,
--         },
--         window = {
--           bordered = {
--             border = "none",
--             winhighlight = "Normal:CmpMenu,FloatBorder:CmpMenu,CursorLine:CmpCursorLine,Search:None",
--           },
--         },
--         mapping = {
--           -- <C-y> = Confirm snippet
--           -- <C-p> / <Up> = Previous item
--           -- <C-n> / <Down> = Next item
--
--           ["<Tab>"] = cmp_action.luasnip_supertab(),
--           ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
--
--           -- go to next placeholder in the snippet
--           ["<C-l>"] = cmp.mapping(function(fallback)
--             if luasnip.jumpable(1) then
--               luasnip.jump(1)
--             else
--               fallback()
--             end
--           end, { "i", "s" }),
--           -- go to previous placeholder in the snippet
--           ["<C-h>"] = cmp.mapping(function(fallback)
--             if luasnip.jumpable(-1) then
--               luasnip.jump(-1)
--             else
--               fallback()
--             end
--           end, { "i", "s" }),
--         },
--         sources = {
--           { name = "luasnip", priority = 100, max_item_count = 8 },
--           { name = "copilot", priority = 90, max_item_count = 8 },
--           { name = "nvim_lsp", priority = 90, keyword_length = 3, max_item_count = 8 },
--           { name = "path", priority = 20 },
--           { name = "buffer", priority = 10, keyword_length = 3, max_item_count = 8 },
--           { name = "nvim_lua" },
--           { name = "nvim_lsp_signature_help" },
--         },
--       })
--
--       cmp.setup.cmdline(":", {
--         mapping = cmp.mapping.preset.cmdline(),
--         sources = cmp.config.sources({
--           { name = "path" },
--           {
--             name = "cmdline",
--             option = {
--               ignore_cmds = { "Man", "!" },
--             },
--           },
--         }),
--         sorting = {
--           comparators = {
--             cmp.config.compare.offset,
--             cmp.config.compare.exact,
--             cmp.config.compare.score,
--             cmp.config.compare.recently_used,
--             require("cmp-under-comparator").under,
--             cmp.config.compare.kind,
--           },
--         },
--       })
--
--       cmp.setup.cmdline("/", {
--         mapping = cmp.mapping.preset.cmdline(),
--         sources = {
--           { name = "buffer" },
--         },
--       })
--     end,
--   },
   -- Colorschemes
   { "rose-pine/neovim", name = "rose-pine" },
--   --
--   -- -- Marks & Session
--   -- { "tomasky/bookmarks.nvim", config = "plugins.bookmarks" },
--   -- { "olimorris/persisted.nvim", config = "plugins.persisted" },
--   -- { "rmagatti/auto-session", config = "plugins.auto-session" },
--   -- { "ahmedkhalf/project.nvim", config = "plugins.project" },
--   --
--   -- { "chentoast/marks.nvim", event = "VeryLazy", config = "plugins.marks" },
--   -- { "ThePrimeagen/harpoon", event = "VeryLazy", config = "plugins.harpoon" },
--   --
--   -- -- Yank & Register Handling
--   -- {
--   --   "tversteeg/registers.nvim",
--   --   event = "VeryLazy",
--   --   config = "plugins.registers",
--   --   commit = "0a461e635403065b3f9a525bd77eff30759cfba0",
--   -- },
--   -- { "tenxsoydev/karen-yank.nvim", event = "VeryLazy", config = true, branch = "remove-cut-esc" },
--   --
--   -- -- Markdown
--   -- { "preservim/vim-markdown", config = "plugins.markdown" },
--   -- { "dkarter/bullets.vim", ft = "markdown", config = "plugins.bullets" },
--   -- {
--   --   "iamcco/markdown-preview.nvim",
--   --   build = "cd app && npm install",
--   --   event = "VeryLazy",
--   --   config = "plugins.markdown-preview",
--   -- },
--   -- { "tenxsoydev/vim-markdown-checkswitch", ft = "markdown" },
}

local function get(plugin_config, eager)
  if (plugin_config:match("plugins") or plugin_config:match("colorschemes")) and not plugin_config:match("meg") then
    plugin_config = "meg." .. plugin_config
  end

  if eager == "eager" then
    return function()
      require(plugin_config)
    end
  end

  return function()
    -- scheduled loading the majority of config files - results in 30-35% faster startup
    vim.schedule(function()
      require(plugin_config)
    end)
  end
end

for i, module in ipairs(modules) do
  if type(module) == "string" then
    goto continue
  end

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
  if module.eager then
    module.eager = nil
  end

  ::continue::
  modules[i] = module
end

require("lazy").setup(modules, {
  ui = {
    border = mw.ui.borders.round,
    custom_keys = {
      ["<Leader>ll"] = function(plugin)
        require("lazy.util").float_term({ "lazygit", "log" }, {
          cwd = plugin.dir,
        })
      end,
    },
  },
  dev = { path = "~/code/neovim-plugins/" },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
--
-- nx.au({
--   "BufEnter",
--   pattern = { vim.fn.stdpath("config") .. "*/init.lua" },
--   callback = function()
--     vim.opt_local.path = { ",,", vim.fn.stdpath("config") .. "/lua/meg/" }
--     vim.cmd("setlocal inex=tr(v:fname,'.','/')")
--   end,
-- })
--
-- nx.map({ "<leader>P", "<Cmd>Lazy<CR>", desc = "Plugin Manager" })
--
-- require("meg.commands")
-- require("meg.functions")
