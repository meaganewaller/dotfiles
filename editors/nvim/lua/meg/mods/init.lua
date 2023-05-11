return {
  -- ( CORE ) ------------------------------------------------------------------
  {
    {
      "dstein64/vim-startuptime",
      cmd = { "StartupTime" },
      config = function()
        vim.g.startuptime_tries = 15
      end,
    },
  },

  -- ( UI ) --------------------------------------------------------------------
  {
    {
      "rktjmp/lush.nvim",
      lazy = false,
      priority = 1000,
    },
    {
      "mcchrish/zenbones.nvim",
      lazy = false,
      priority = 999,
      dependencies = "rktjmp/lush.nvim",
    },
    {
      "catppuccin/nvim",
      lazy = false,
      name = "catppuccin",
      config = function()
        local transparent_background = true

        require("catppuccin").setup({
          flavour = "mocha", -- Can be one of: latte, frappe, macchiato, mocha
          background = { light = "latte", dark = "mocha" },
          dim_inactive = {
            enabled = false,
            -- Dim inactive splits/windows/buffers.
            -- NOT recommended if you use old palette (a.k.a., mocha).
            shade = "dark",
            percentage = 0.15,
          },
          transparent_background = transparent_background,
          show_end_of_buffer = false, -- show the '~' characters after the end of buffers
          term_colors = true,
          compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
          styles = {
            comments = { "italic" },
            properties = { "italic" },
            functions = { "bold" },
            keywords = { "italic" },
            operators = { "bold" },
            conditionals = { "bold" },
            loops = { "bold" },
            booleans = { "bold", "italic" },
            numbers = {},
            types = {},
            strings = {},
            variables = {},
          },
          integrations = {
            treesitter = true,
            native_lsp = {
              enabled = true,
              virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
              },
              underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
              },
            },
            aerial = false,
            alpha = false,
            barbar = false,
            beacon = false,
            cmp = true,
            coc_nvim = false,
            dap = { enabled = true, enable_ui = true },
            dashboard = false,
            fern = false,
            fidget = true,
            gitgutter = false,
            gitsigns = true,
            harpoon = false,
            hop = true,
            illuminate = true,
            indent_blankline = { enabled = true, colored_indent_levels = false },
            leap = false,
            lightspeed = false,
            lsp_saga = true,
            lsp_trouble = true,
            markdown = true,
            mason = true,
            mini = false,
            navic = { enabled = false },
            neogit = false,
            neotest = false,
            neotree = { enabled = false, show_root = true, transparent_panel = false },
            noice = false,
            notify = true,
            nvimtree = true,
            overseer = false,
            pounce = false,
            semantic_tokens = true,
            symbols_outline = false,
            telekasten = false,
            telescope = true,
            treesitter_context = false,
            ts_rainbow = true,
            vim_sneak = false,
            vimwiki = false,
            which_key = true,
          },
          color_overrides = {
            mocha = {
              rosewater = "#F5E0DC",
              flamingo = "#F2CDCD",
              mauve = "#DDB6F2",
              pink = "#F5C2E7",
              red = "#F28FAD",
              maroon = "#E8A2AF",
              peach = "#F8BD96",
              yellow = "#FAE3B0",
              green = "#ABE9B3",
              blue = "#96CDFB",
              sky = "#89DCEB",
              teal = "#B5E8E0",
              lavender = "#C9CBFF",

              text = "#D9E0EE",
              subtext1 = "#BAC2DE",
              subtext0 = "#A6ADC8",
              overlay2 = "#C3BAC6",
              overlay1 = "#988BA2",
              overlay0 = "#6E6C7E",
              surface2 = "#6E6C7E",
              surface1 = "#575268",
              surface0 = "#302D41",

              base = "#1E1E2E",
              mantle = "#1A1826",
              crust = "#161320",
            },
          },
          highlight_overrides = {
            mocha = function(cp)
              return {
                -- For base configs.
                NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.base },
                CursorLineNr = { fg = cp.green },
                Search = { bg = cp.surface1, fg = cp.pink, style = { "bold" } },
                IncSearch = { bg = cp.pink, fg = cp.surface1 },
                Keyword = { fg = cp.pink },
                Type = { fg = cp.blue },
                Typedef = { fg = cp.yellow },
                StorageClass = { fg = cp.red, style = { "italic" } },

                -- For native lsp configs.
                DiagnosticVirtualTextError = { bg = cp.none },
                DiagnosticVirtualTextWarn = { bg = cp.none },
                DiagnosticVirtualTextInfo = { bg = cp.none },
                DiagnosticVirtualTextHint = { fg = cp.rosewater, bg = cp.none },

                DiagnosticHint = { fg = cp.rosewater },
                LspDiagnosticsDefaultHint = { fg = cp.rosewater },
                LspDiagnosticsHint = { fg = cp.rosewater },
                LspDiagnosticsVirtualTextHint = { fg = cp.rosewater },
                LspDiagnosticsUnderlineHint = { sp = cp.rosewater },

                -- For fidget.
                FidgetTask = { bg = cp.none, fg = cp.surface2 },
                FidgetTitle = { fg = cp.blue, style = { "bold" } },

                -- For trouble.nvim
                TroubleNormal = { bg = cp.base },

                -- For lsp semantic tokens
                ["@lsp.type.comment"] = { fg = cp.overlay0 },
                ["@lsp.type.enum"] = { link = "@type" },
                ["@lsp.type.property"] = { link = "@property" },
                ["@lsp.type.macro"] = { link = "@constant" },
                ["@lsp.typemod.function.defaultLibrary"] = { fg = cp.blue, style = { "bold", "italic" } },
                ["@lsp.typemod.function.defaultLibrary.c"] = { fg = cp.blue, style = { "bold" } },
                ["@lsp.typemod.function.defaultLibrary.cpp"] = { fg = cp.blue, style = { "bold" } },
                ["@lsp.typemod.method.defaultLibrary"] = { link = "@lsp.typemod.function.defaultLibrary" },
                ["@lsp.typemod.variable.defaultLibrary"] = { fg = cp.flamingo },

                -- For treesitter.
                ["@field"] = { fg = cp.rosewater },
                ["@property"] = { fg = cp.yellow },

                ["@include"] = { fg = cp.teal },
                -- ["@operator"] = { fg = cp.sky },
                ["@keyword.operator"] = { fg = cp.sky },
                ["@punctuation.special"] = { fg = cp.maroon },

                -- ["@float"] = { fg = cp.peach },
                -- ["@number"] = { fg = cp.peach },
                -- ["@boolean"] = { fg = cp.peach },

                ["@constructor"] = { fg = cp.lavender },
                -- ["@constant"] = { fg = cp.peach },
                -- ["@conditional"] = { fg = cp.mauve },
                -- ["@repeat"] = { fg = cp.mauve },
                ["@exception"] = { fg = cp.peach },

                ["@constant.builtin"] = { fg = cp.lavender },
                -- ["@function.builtin"] = { fg = cp.peach, style = { "italic" } },
                -- ["@type.builtin"] = { fg = cp.yellow, style = { "italic" } },
                ["@type.qualifier"] = { link = "@keyword" },
                ["@variable.builtin"] = { fg = cp.red, style = { "italic" } },

                -- ["@function"] = { fg = cp.blue },
                ["@function.macro"] = { fg = cp.red, style = {} },
                ["@parameter"] = { fg = cp.rosewater },
                ["@keyword"] = { fg = cp.red, style = { "italic" } },
                ["@keyword.function"] = { fg = cp.maroon },
                ["@keyword.return"] = { fg = cp.pink, style = {} },

                -- ["@text.note"] = { fg = cp.base, bg = cp.blue },
                -- ["@text.warning"] = { fg = cp.base, bg = cp.yellow },
                -- ["@text.danger"] = { fg = cp.base, bg = cp.red },
                -- ["@constant.macro"] = { fg = cp.mauve },

                -- ["@label"] = { fg = cp.blue },
                ["@method"] = { fg = cp.blue, style = { "italic" } },
                ["@namespace"] = { fg = cp.rosewater, style = {} },

                ["@punctuation.delimiter"] = { fg = cp.teal },
                ["@punctuation.bracket"] = { fg = cp.overlay2 },
                -- ["@string"] = { fg = cp.green },
                -- ["@string.regex"] = { fg = cp.peach },
                ["@type"] = { fg = cp.yellow },
                ["@variable"] = { fg = cp.text },
                ["@tag.attribute"] = { fg = cp.mauve, style = { "italic" } },
                ["@tag"] = { fg = cp.peach },
                ["@tag.delimiter"] = { fg = cp.maroon },
                ["@text"] = { fg = cp.text },

                -- ["@text.uri"] = { fg = cp.rosewater, style = { "italic", "underline" } },
                -- ["@text.literal"] = { fg = cp.teal, style = { "italic" } },
                -- ["@text.reference"] = { fg = cp.lavender, style = { "bold" } },
                -- ["@text.title"] = { fg = cp.blue, style = { "bold" } },
                -- ["@text.emphasis"] = { fg = cp.maroon, style = { "italic" } },
                -- ["@text.strong"] = { fg = cp.maroon, style = { "bold" } },
                -- ["@string.escape"] = { fg = cp.pink },

                -- ["@property.toml"] = { fg = cp.blue },
                -- ["@field.yaml"] = { fg = cp.blue },

                -- ["@label.json"] = { fg = cp.blue },

                ["@function.builtin.bash"] = { fg = cp.red, style = { "italic" } },
                ["@parameter.bash"] = { fg = cp.yellow, style = { "italic" } },

                ["@field.lua"] = { fg = cp.lavender },
                ["@constructor.lua"] = { fg = cp.flamingo },
                ["@variable.builtin.lua"] = { fg = cp.flamingo, style = { "italic" } },

                ["@constant.java"] = { fg = cp.teal },

                ["@property.typescript"] = { fg = cp.lavender, style = { "italic" } },
                -- ["@constructor.typescript"] = { fg = cp.lavender },

                -- ["@constructor.tsx"] = { fg = cp.lavender },
                -- ["@tag.attribute.tsx"] = { fg = cp.mauve },

                ["@type.css"] = { fg = cp.lavender },
                ["@property.css"] = { fg = cp.yellow, style = { "italic" } },

                ["@type.builtin.c"] = { fg = cp.yellow, style = {} },

                ["@property.cpp"] = { fg = cp.text },
                ["@type.builtin.cpp"] = { fg = cp.yellow, style = {} },

                -- ["@symbol"] = { fg = cp.flamingo },
              }
            end,
          },
        })
      end,
    },
    {
      "sainnhe/edge",
      lazy = true,
      config = function()
        vim.g.edge_style = "aura"
        vim.g.edge_enable_italic = 1
        vim.g.edge_disable_italic_comment = 1
        vim.g.edge_show_eob = 1
        vim.g.edge_better_performance = 1
        vim.g.edge_transparent_background = 2
      end,
    },
    {
      "nvim-tree/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup()
      end,
    },
    {
      "NvChad/nvim-colorizer.lua",
      event = { "BufReadPre" },
      config = function()
        require("colorizer").setup({
          filetypes = { "*", "!lazy", "!gitcommit", "!NeogitCommitMessage", "!dirbuf" },
          buftype = { "*", "!prompt", "!nofile", "!dirbuf" },
          user_default_options = {
            RGB = false, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- "Name" codes like Blue or blue
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            AARRGGBB = true, -- 0xAARRGGBB hex codes
            rgb_fn = true, -- CSS rgb() and rgba() functions
            hsl_fn = true, -- CSS hsl() and hsla() functions
            -- css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
            -- Available modes for `mode`: foreground, background,  virtualtext
            mode = "background", -- Set the display mode.
            virtualtext = "■",
          },
          -- all the sub-options of filetypes apply to buftypes
          buftypes = {},
        })

        _G.meg.augroup("Colorizer", {
          {
            event = { "BufReadPost" },
            command = function()
              if _G.meg.is_chonky(vim.api.nvim_get_current_buf()) then
                vim.cmd("ColorizerDetachFromBuffer")
              end
            end,
          },
        })
      end,
    },
    { "lukas-reineke/virt-column.nvim", config = { char = "│" }, event = "VimEnter" },
    {
      "mbbill/undotree",
      cmd = "UndotreeToggle",
      keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "undotree: toggle" } },
      config = function()
        vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
      end,
    },
    {
      "chrisgrieser/replacer.nvim",
      ft = "qf",
      -- keys = {
      --   { "<leader>R", function() require("replacer").run() end, desc = "qf: replace in qflist" },
      --   { "<C-r>", function() require("replacer").run() end, desc = "qf: replace in qflist" },
      -- },
      init = function()
        -- save & quit via "q"
        meg.augroup("ReplacerFileType", {
          pattern = "replacer",
          callback = function()
            meg.nmap("q", vim.cmd.write, { desc = " Finish replacing", buffer = true, nowait = true })
          end,
        })

        -- { "<leader>R", function() require("replacer").run() end, desc = "qf: replace in qflist" },
        -- { "<C-r>", function() require("replacer").run() end, desc = "qf: replace in qflist" },
      end,
    },
    {
      "j-hui/fidget.nvim",
      lazy = true,
      event = "LspAttach",
      config = function()
        require("fidget").setup({
          window = { blend = 0 },
          sources = {
            ["null-ls"] = { ignore = true },
          },
        })
      end,
    },
    {
      "zbirenbaum/neodim",
      lazy = true,
      event = "LspAttach",
      config = function()
        local blend_color = require("meg.utils.plugins").hl_to_rgb("Normal", true)

        require("neodim").setup({
          alpha = 0.45,
          blend_color = blend_color,
          update_in_insert = {
            enable = true,
            delay = 100,
          },
          hide = {
            virtual_text = true,
            signs = false,
            underline = false,
          },
        })
      end,
    },
    {
      "karb94/neoscroll.nvim",
      lazy = true,
      event = "BufReadPost",
      config = function()
        require("neoscroll").setup({
          -- All these keys will be mapped to their corresponding default scrolling animation
          mappings = {
            "<C-u>",
            "<C-d>",
            "<C-b>",
            "<C-f>",
            "<C-y>",
            "<C-e>",
            "zt",
            "zz",
            "zb",
          },
          hide_cursor = true, -- Hide cursor while scrolling
          stop_eof = true, -- Stop at <EOF> when scrolling downwards
          use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
          respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
          cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
          easing_function = nil, -- Default easing function
          pre_hook = nil, -- Function to run before the scrolling animation starts
          post_hook = nil, -- Function to run after the scrolling animation ends
        })
      end,
    },
    {
      "shaunsingh/nord.nvim",
      lazy = true,
      config = function()
        vim.g.nord_contrast = true
        vim.g.nord_borders = false
        vim.g.nord_cursorline_transparent = true
        vim.g.nord_disable_background = false
        vim.g.nord_enable_sidebar_background = true
        vim.g.nord_italic = true
      end,
    },
    {
      "folke/paint.nvim",
      lazy = true,
      event = { "CursorHold", "CursorHoldI" },
      config = function()
        require("paint").setup({
          ---type PaintHighlight[]
          highlights = {
            {
              -- filter can be a table of buffer options that should match,
              -- or a function called with buf as param that should return true.
              -- The example below will paint @something in comments with Constant
              filter = { filetype = "lua" },
              pattern = "%s*%-%-%-%s*(@%w+)",
              hl = "Constant",
            },
            {
              filter = { filetype = "python" },
              pattern = "%s*([_%w]+:)",
              hl = "Constant",
            },
          },
        })
      end,
    },
    {
      "dstein64/nvim-scrollview",
      lazy = true,
      event = "BufReadPost",
      config = function()
        require("scrollview").setup({})
      end,
    },
    {
      "edluffy/specs.nvim",
      lazy = true,
      event = "CursorMoved",
      config = function()
        require("specs").setup({
          show_jumps = true,
          min_jump = 10,
          popup = {
            delay_ms = 0, -- delay before popup displays
            inc_ms = 10, -- time increments used for fade/resize effects
            blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
            width = 10,
            winhl = "PMenu",
            fader = require("specs").pulse_fader,
            resizer = require("specs").shrink_resizer,
          },
          ignore_filetypes = {},
          ignore_buftypes = { nofile = true },
        })
      end,
    },
  },

  -- ( LSP ) -------------------------------------------------------------------
  -- {
  --   "neovim/nvim-lspconfig",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     { "nvim-lua/lsp_extensions.nvim" },
  --     {
  --       "jose-elias-alvarez/typescript.nvim",
  --       ft = { "typescript", "typescriptreact" },
  --       dependencies = { "jose-elias-alvarez/null-ls.nvim" },
  --       config = function()
  --         -- require("typescript").setup({ server = require("meg.servers")("tsserver") })
  --         require("null-ls").register({
  --           sources = { require("typescript.extensions.null-ls.code-actions") },
  --         })
  --       end,
  --     },
  --     { "MunifTanjim/nui.nvim" },
  --     { "williamboman/mason-lspconfig.nvim" },
  --     { "b0o/schemastore.nvim" },
  --     { "mrshmllow/document-color.nvim", event = "BufReadPre" },
  --     {
  --       "mhanberg/output-panel.nvim",
  --       keys = {
  --         {
  --           "<localleader>lop",
  --           ":OutputPanel<CR>",
  --           desc = "lsp: open output panel",
  --         },
  --       },
  --       cmd = { "OutputPanel" },
  --       config = function()
  --         require("output_panel").setup()
  --       end,
  --     },
  --     {
  --       "elixir-tools/elixir-tools.nvim",
  --       ft = { "elixir", "eex", "heex", "surface" },
  --       config = function()
  --         local elixir = require("elixir")
  --         local elixirls = require("elixir.elixirls")
  --
  --         elixir.setup({
  --           elixirls = {
  --             -- cmd = fmt("%s/lsp/elixir-ls/%s", vim.env.XDG_DATA_HOME, "language_server.sh"),
  --             settings = elixirls.settings({
  --               dialyzerEnabled = true,
  --               dialyzerFormat = "dialyxir_long", -- alts: dialyxir_short
  --               dialyzerwarnopts = {},
  --               fetchDeps = false,
  --               enableTestLenses = false,
  --               suggestSpecs = true,
  --             }),
  --             log_level = vim.lsp.protocol.MessageType.Log,
  --             message_level = vim.lsp.protocol.MessageType.Log,
  --             on_attach = function(client, bufnr)
  --               vim.keymap.set("n", "<localleader>efp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
  --               vim.keymap.set("n", "<localleader>etp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
  --               vim.keymap.set("v", "<localleader>eem", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
  --             end,
  --           },
  --         })
  --       end,
  --       dependencies = {
  --         "nvim-lua/plenary.nvim",
  --       },
  --     },
  --     {
  --       "Fildo7525/pretty_hover",
  --       event = "LspAttach",
  --       opts = { border = meg.get_border() },
  --     },
  --     {
  --       "lewis6991/hover.nvim",
  --       keys = { "K", "gK" },
  --       config = function()
  --         require("hover").setup({
  --           init = function()
  --             require("hover.providers.lsp")
  --             require("hover.providers.gh")
  --             require("hover.providers.gh_user")
  --             require("hover.providers.jira")
  --             require("hover.providers.man")
  --             require("hover.providers.dictionary")
  --           end,
  --           preview_opts = {
  --             border = require("meg.globals").get_border(),
  --           },
  --           -- Whether the contents of a currently open hover window should be moved
  --           -- to a :h preview-window when pressing the hover keymap.
  --           preview_window = true,
  --           title = false,
  --         })
  --       end,
  --     },
  --   },
  -- },
  {
    "megalithic/dirbuf.nvim",
    keys = {
      {
        "<leader>ed",
        function()
          local buf = vim.api.nvim_buf_get_name(0)
          -- vim.cmd([[vertical topleft split|vertical resize 60]])
          vim.cmd([[vertical rightbelow split]])
          require("dirbuf").open(buf)
        end,
        desc = "dirbuf: toggle",
      },
      {
        "<leader>ee",
        function()
          local buf = vim.api.nvim_buf_get_name(0)
          -- vim.cmd([[vertical topleft split|vertical resize 60]])
          require("dirbuf").open(buf)
        end,
        desc = "dirbuf: toggle",
      },
    },
    cmd = { "Dirbuf", "DirbufQuit", "DirbufSync" },
    opts = {
      sort_order = "directories_first",
      devicons = true,
    },
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    url = "https://gitlab.com/yorickpeterse/nvim-pqf",
    event = "BufReadPre",
    config = function()
      local icons = require("meg.icons")
      require("pqf").setup({
        signs = {
          error = icons.lsp.error,
          warning = icons.lsp.warn,
          info = icons.lsp.info,
          hint = icons.lsp.hint,
        },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = {
      auto_open = false,
      use_diagnostic_signs = true, -- en
    },
  },

  -- ( Development ) -----------------------------------------------------------
  {
    "kevinhwang91/nvim-hclipboard",
    event = "InsertCharPre",
    config = function()
      require("hclipboard").start()
    end,
  },
  -- {
  --   "mg979/vim-visual-multi",
  --   keys = { { "<C-e>", mode = { "n", "x" } }, "\\j", "\\k" },
  --   enabled = false,
  --   event = { "BufReadPost", "BufNewFile" },
  --   init = function()
  --     vim.g.VM_highlight_matches = "underline"
  --     vim.g.VM_theme = "codedark"
  --     vim.g.VM_maps = {
  --       ["Find Word"] = "<C-E>",
  --       ["Find Under"] = "<C-E>",
  --       ["Find Subword Under"] = "<C-E>",
  --       ["Select Cursor Down"] = "\\j",
  --       ["Select Cursor Up"] = "\\k",
  --     }
  --   end,
  -- },
  {
    "mg979/vim-visual-multi",
    lazy = false,
    init = function()
      vim.g.VM_highlight_matches = "underline"
      vim.g.VM_theme = "codedark"
      vim.g.VM_maps = {
        ["Find Word"] = "<M-e>",
        ["Find Under"] = "<M-e>",
        ["Find Subword Under"] = "<M-e>",
        ["Select Cursor Down"] = "\\j",
        ["Select Cursor Up"] = "\\k",
      }
    end,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = function()
      local M = {}
      M.snippet_engine = "luasnip"
      M.languages = {}
      M.languages.python = { template = { annotation_convention = "google_docstrings" } }
      M.languages.typescript = { template = { annotation_convention = "tsdoc" } }
      M.languages.typescriptreact = M.languages.typescript
      return M
    end,
  },
  {
    -- TODO: https://github.com/avucic/dotfiles/blob/master/nvim_user/.config/nvim/lua/user/configs/dadbod.lua
    "kristijanhusak/vim-dadbod-ui",
    dependencies = "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
      -- _G.meg.nnoremap("<leader>db", "<cmd>DBUIToggle<CR>", "dadbod: toggle")
    end,
  },
  { "alvan/vim-closetag", ft = { "elixir", "heex", "html", "liquid", "javascriptreact", "typescriptreact" } },
  {
    "andymass/vim-matchup",
    event = "BufReadPre",
    config = function()
      vim.g.matchup_surround_enabled = true
      vim.g.matchup_matchparen_deferred = true
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
        -- fullwidth = true,
        highlight = "Normal",
        border = "none",
      }
    end,
  },
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = function()
      require("numb").setup()
    end,
  },
  { "tpope/vim-eunuch", cmd = { "Move", "Rename", "Remove", "Delete", "Mkdir", "SudoWrite", "Chmod" } },
  {
    "tpope/vim-abolish",
    event = "CmdlineEnter",
    keys = {
      {
        "<C-s>",
        ":S/<C-R><C-W>//<LEFT>",
        mode = "n",
        silent = false,
        desc = "abolish: replace word under the cursor (line)",
      },
      {
        "<C-s>",
        ":%S/<C-r><C-w>//c<left><left>",
        mode = "n",
        silent = false,
        desc = "abolish: replace word under the cursor (file)",
      },
      {
        "<C-r>",
        [["zy:'<'>S/<C-r><C-o>"//c<left><left>]],
        mode = "x",
        silent = false,
        desc = "abolish: replace word under the cursor (visual)",
      },
    },
  },
  { "tpope/vim-rhubarb", event = { "VeryLazy" } },
  { "tpope/vim-repeat", lazy = false },
  { "tpope/vim-unimpaired", event = { "VeryLazy" } },
  { "tpope/vim-apathy", event = { "VeryLazy" } },
  { "tpope/vim-scriptease", event = { "VeryLazy" }, cmd = { "Messages", "Mess", "Noti" } },
  { "lambdalisue/suda.vim", event = { "VeryLazy" } },
  {
    "EinfachToll/DidYouMean",
    event = { "BufNewFile" },
    init = function()
      vim.g.dym_use_fzf = true
    end,
  },
  { "wsdjeg/vim-fetch", lazy = false }, -- vim path/to/file.ext:12:3
  { "ConradIrwin/vim-bracketed-paste" }, -- FIXME: delete?
  {
    "linty-org/readline.nvim",
    keys = {
      {
        "<C-f>",
        function()
          require("readline").forward_word()
        end,
        mode = "!",
      },
      {
        "<C-b>",
        function()
          require("readline").backward_word()
        end,
        mode = "!",
      },
      {
        "<C-a>",
        function()
          require("readline").beginning_of_line()
        end,
        mode = "!",
      },
      {
        "<C-e>",
        function()
          require("readline").end_of_line()
        end,
        mode = "!",
      },
      {
        "<M-d>",
        function()
          require("readline").kill_word()
        end,
        mode = "!",
      },
      {
        "<M-BS>",
        function()
          require("readline").backward_kill_word()
        end,
        mode = "!",
      },
      {
        "<C-w>",
        function()
          require("readline").unix_word_rubout()
        end,
        mode = "!",
      },
      {
        "<C-k>",
        function()
          require("readline").kill_line()
        end,
        mode = "!",
      },
      {
        "<C-u>",
        function()
          require("readline").backward_kill_line()
        end,
        mode = "!",
      },
    },
  },
  { "axelvc/template-string.nvim", ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" } },

  -- ( Motions/Textobjects ) ---------------------------------------------------
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter", "AndrewRadev/splitjoin.vim" },
    cmd = { "TSJSplit", "TSJJoin", "TSJToggle", "SplitjoinJoin", "SplitjoinSplit" },
    keys = { "gs", "gj", "gS", "gJ" },
    config = function()
      require("treesj").setup({ use_default_keymaps = false, max_join_length = 150 })

      local langs = require("treesj.langs")["presets"]

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "*",
        callback = function()
          if langs[vim.bo.filetype] then
            meg.nnoremap("gS", ":TSJSplit<cr>", { desc = "Split lines", buffer = true })
            meg.nnoremap("gJ", ":TSJJoin<cr>", { desc = "Join lines", buffer = true })
            meg.nnoremap("gs", ":TSJSplit<cr>", { desc = "Split lines", buffer = true })
            meg.nnoremap("gj", ":TSJJoin<cr>", { desc = "Join lines", buffer = true })
          else
            meg.nnoremap("gS", ":SplitjoinSplit<cr>", { desc = "Split lines", buffer = true })
            meg.nnoremap("gJ", ":SplitjoinJoin<cr>", { desc = "Join lines", buffer = true })
            meg.nnoremap("gs", ":SplitjoinSplit<cr>", { desc = "Split lines", buffer = true })
            meg.nnoremap("gj", ":SplitjoinJoin<cr>", { desc = "Join lines", buffer = true })
          end
        end,
      })
    end,
  },
  {
    "abecodes/tabout.nvim",
    event = { "InsertEnter" },
    keys = { "<Tab>", "<S-Tab>", "<C-t>", "<C-d>" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
    config = function()
      require("tabout").setup({
        tabkey = "", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "", -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        enable_backwards = true,
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
        exclude = {}, -- tabout will ignore these filetypes
      })
    end,
  },

  -- ( Notes/Docs ) ------------------------------------------------------------
  { "iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },
  {
    "ekickx/clipboard-image.nvim",
    ft = "markdown",
    config = true,
  },
  {
    "evanpurkhiser/image-paste.nvim",
    ft = "markdown",
    keys = {
      {
        "<C-v>",
        function()
          require("image-paste").paste_image()
        end,
        mode = "i",
      },
    },
    config = {
      imgur_client_id = "2974b259fd073e2",
    },
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    config = function()
      local peek = require("peek")
      peek.setup({})

      _G.meg.command("Peek", function()
        if not peek.is_open() and vim.bo[vim.api.nvim_get_current_buf()].filetype == "markdown" then
          peek.open()
          -- vim.fn.system([[hs -c 'require("wm.snap").send_window_right(hs.window.find("Peek preview"))']])
          -- vim.fn.system([[hs -c 'require("wm.snap").send_window_left(hs.application.find("kitty"):mainWindow())']])
        else
          peek.close()
        end
      end)
    end,
  },
  -- {
  --   "gaoDean/autolist.nvim",
  --   ft = { "markdown" },
  --   config = function()
  --     local autolist = require("autolist")
  --     autolist.setup()
  --     autolist.create_mapping_hook("i", "<CR>", autolist.new)
  --     autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
  --     autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
  --     autolist.create_mapping_hook("n", "o", autolist.new)
  --     autolist.create_mapping_hook("n", "O", autolist.new_before)
  --     autolist.create_mapping_hook("n", ">>", autolist.indent)
  --     autolist.create_mapping_hook("n", "<<", autolist.indent)
  --     autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
  --     autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")
  --     autolist.create_mapping_hook("n", "<C-c>", autolist.invert_entry, "")
  --     vim.api.nvim_create_autocmd("TextChanged", {
  --       pattern = "*",
  --       callback = function() vim.cmd.normal({ autolist.force_recalculate(nil, nil), bang = false }) end,
  --     })
  --   end,
  -- },
  { "ellisonleao/glow.nvim", ft = { "markdown" } },
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown" },
    dependencies = "nvim-treesitter",
    config = function()
      require("headlines").setup({
        markdown = {
          source_pattern_start = "^```",
          source_pattern_end = "^```$",
          dash_pattern = "-",
          dash_highlight = "Dash",
          dash_string = "", -- alts:  靖並   ﮆ 
          headline_pattern = "^#+",
          headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
          codeblock_highlight = "CodeBlock",
        },
        yaml = {
          dash_pattern = "^---+$",
          dash_highlight = "Dash",
        },
      })
    end,
  },

  -- ( Syntax/Languages ) ------------------------------------------------------
  { "ii14/emmylua-nvim", ft = "lua" },
  { "elixir-editors/vim-elixir", ft = { "markdown" } }, -- nvim exceptions thrown when not installed
  "kchmck/vim-coffee-script",
  "briancollins/vim-jst",
  { "imsnif/kdl.vim", ft = "kdl" },
  { "chr4/nginx.vim", ft = "nginx" },
  { "fladson/vim-kitty", ft = "kitty" },
  {
    "SirJson/fzf-gitignore",
    config = function()
      vim.g.fzf_gitignore_no_maps = true
    end,
  },
  {
    "mrossinek/zen-mode.nvim",
    cmd = { "ZenMode" },
    keys = { { "<localleader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    opts = {
      window = {
        options = {
          foldcolumn = "0",
          number = false,
          relativenumber = false,
          scrolloff = 999,
          signcolumn = "no",
        },
      },
      plugins = {
        tmux = {
          enabled = true,
        },
        wezterm = {
          enabled = true,
          font = "+8",
        },
      },
    },
  },
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT" },
    config = function()
      local border = { style = meg.icons.border.blank, highlight = "CmpBorderedWindow_FloatBorder" }
      require("chatgpt").setup({
        popup_window = {
          border = border,
        },
        popup_input = {
          border = border,
          submit = "<C-s>",
        },
        settings_window = {
          border = border,
        },
        chat = {
          keymaps = {
            close = {
              "<C-c>",--[[ , '<Esc>' ]]
            },
          },
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  { "wakatime/vim-wakatime", lazy = false },
}
