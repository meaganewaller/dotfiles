return {
  { "folke/neodev.nvim", config = true },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig.ui.windows").default_options.border = "rounded"
      nx.map({
        { "<leader>lI", "<Cmd>LspInfo<CR>", desc = "Info" },
        { "<leader>lR", "<Cmd>LspRestart<CR>", desc = "Restart" },
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local fmt = null_ls.builtins.formatting

      null_ls.register({
        name = "nimpretty_t",
        method = null_ls.methods.FORMATTING,
        filetypes = { "nim" },
        generator = null_ls.formatter({
          command = "nimpretty_t",
          args = { "$FILENAME", "--maxLineLen=100" },
          to_temp_file = true,
        }),
      })

      null_ls.register({
        name = "vfmt",
        method = null_ls.methods.FORMATTING,
        filetypes = { "v", "vlang" },
        generator = null_ls.formatter({
          command = "v",
          args = { "fmt", "-w", "$FILENAME" },
          to_temp_file = true,
        }),
      })

      null_ls.setup({
        debug = false,
        sources = {
          fmt.prettierd.with({
            filetypes = { "markdown", "json", "jsonc", "typescript", "vue", "yaml" },
            extra_args = { "--use-tabs", "--printWidth: 120", "--semi", "--single-quote" },
          }),
          fmt.rustfmt,
          fmt.stylua,
          fmt.yapf,
        },
      })
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "VeryLazy",
    config = function()
      local config = {
        ui = {
          border = "rounded",
          code_action = "",
          kind = {
            Folder = { "", "" },
          },
        },
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = false,
        },
        rename = {
          -- after all we'll use default lsp_rename with dressing
          in_select = false,
        },
        finder = {
          keys = {}, -- See keymaps section below
        },
        outline = {
          keys = {},
        },
        callhierarchy = {
          keys = {},
        },
        symbol_in_winbar = {
          enable = true,
          separator = " › ",
          hide_keyword = true,
          show_file = true,
          folder_level = 3,
          respect_root = false,
        },
      }

      config.finder.keys = {
        expand_or_jump = "<CR>",
        quit = { "q", "<C-c>", "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
      }
      config.outline.keys = {
        expand_or_jump = "<CR>",
      }
      config.callhierarchy.keys = {
        jump = "<CR>",
      }

      require("lspsaga").setup(config)
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    config = function()
      local fidget = require("fidget")
      local config = {
        text = {
          done = "",
        },
        window = {
          blend = 0, -- interferes with transparency in TUI
        },
        sources = {
          ltex = {
            ignore = true,
          },
        },
      }

      if vim.g.loaded_gui then config.window.blend = 100 end
      fidget.setup(config)
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_signature").setup({
        debug = false, -- set to true to enable debug logging
        log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
        -- default is  ~/.cache/nvim/lsp_signature.log
        verbose = false, -- show debug line number

        bind = true, -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
        doc_lines = 0, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
        -- set to 0 if you DO NOT want any API comments be shown
        -- This setting only take effect in insert mode, it does not affect signature help in normal
        -- mode, 10 by default

        floating_window = false, -- show hint in a floating window, set to false for virtual text only mode

        floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
        -- will set to true when fully tested, set to false will use whichever side has more space
        -- this setting will be helpful if you do not want the PUM and floating win overlap

        floating_window_off_x = 1, -- adjust float windows x position.
        floating_window_off_y = 1, -- adjust float windows y position.

        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = true, -- virtual hint enable
        hint_prefix = "󰅏 ", -- default: 🐼 Panda for parameter
        hint_scheme = "Comment",
        hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
        max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
        -- to view the hiding contents
        max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        handler_opts = {
          border = "rounded",
        },

        always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

        auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
        extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

        padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

        transparency = nil, -- disabled by default, allow floating win transparent value 1~100
        shadow_blend = 36, -- if you using shadow as border use this set the opacity
        shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
        timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
        toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
      })
    end,
  },
  {
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    event = "VeryLazy",
    config = function()
      require("toggle_lsp_diagnostics").init({ virtual_text = false })

      -- Keymaps ====================================================================

      nx.map({
        { "<leader>dtT", "<Cmd>ToggleDiag<CR>", desc = "Toggle Diagnostics" },
        { "<leader>dtd", "<Cmd>ToggleDiagDefault<CR>", desc = "Toggle Diagnostics Default" },
        { "<leader>dtv", "<Plug>(toggle-lsp-diag-vtext)", desc = "Toggle Virtual Text" },
      })
      nx.map({
        { "<leader>tdT", "<Cmd>ToggleDiag<CR>", desc = "Toggle Diagnostics" },
        { "<leader>tdd", "<Cmd>ToggleDiagDefault<CR>", desc = "Toggle Diagnostics Default" },
        { "<leader>tdv", "<Plug>(toggle-lsp-diag-vtext)", desc = "Toggle Virtual Text" },
      }, { wk_label = { sub_desc = "Toggle" } })
    end,
  },
  "b0o/SchemaStore.nvim",
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded"
        }
      })

      nx.map({ "<Leader>lM", "<cmd>Mason<CR>"})
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      -- { == Configuration ==> =====================================================

      mason_lspconfig.setup({
        -- ensure_installed = { "lua_ls" },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      local function on_attach(client, bufnr)
        require("meg.lib.lsp").on_attach(client, bufnr)
        require("meg.lib.lsp.lspsaga").on_attach(client, bufnr)
      end

      mason_lspconfig.setup_handlers({
        function(server)
          local opts = {
            capabilities = capabilities,
            on_attach = on_attach,
          }

          -- Handled by rust-tools.
          if server == "rust_analyzer" then goto continue end

          -- Insert server settings from settings file if present.
          -- The name of the settings file must match the name of the language server.
          local server_settings_ok, server_settings = pcall(require, "nxvim.lsp.settings." .. server)
          if server_settings_ok then opts = vim.tbl_deep_extend("keep", server_settings, opts) end

          -- Or add settings inline.
          --
          -- The json|ts provideFormatter setting below triggers for gopls when it shouldn't, therefore we continue from here.
          if server == "gopls" then goto setup end
          -- Use prettierd as formatter.
          if server == "jsonls" or "tsserver" then opts.init_options = { provideFormatter = false } end

          ::setup::
          lspconfig[server].setup(opts)
          ::continue::
        end,
      })
      -- <== }

      --- { == Keymaps ==> ===========================================================

      nx.map({
        { "<leader>l+", ":LspStart ", desc = "Select Language Server to Start", wk_label = "Start LSP" },
        { "<leader>l-", ":LspStop ", desc = "Select Language Server to Stop", wk_label = "Stop LSP" },
      })
    end,
  },
  { "jayp0521/mason-null-ls.nvim", config = true },
}
