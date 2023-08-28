local function setup_typescript_tools()
  local api = require("typescript-tools.api")

  require("typescript-tools").setup({
    -- on_attach = function() ... end,
    handlers = {
      ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
      -- Ignore 'This may be converted to an async function' diagnostics.
        { 80006 }
      ),
    },
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,
      -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      publish_diagnostic_on = "insert_leave",
      -- array of strings("fix_all"|"add_missing_imports"|"remove_unused")
      -- specify commands exposed as code_actions
      expose_as_code_action = {},
      -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      -- not exists then standard path resolution strategy is applied
      tsserver_path = nil,
      -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
      -- (see 💅 `styled-components` support section)
      tsserver_plugins = {
        -- for TypeScript v4.9+
        "@styled/typescript-styled-plugin",
        -- or for older TypeScript versions
        -- "typescript-styled-plugin",
      },
      -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
      -- memory limit in megabytes or "auto"(basically no limit)
      tsserver_max_memory = "auto",
      -- described below
      tsserver_file_preferences = {},
      tsserver_format_options = {},
    },
  })
end

local function setup_comment()
  require("Comment").setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
      ---Line-comment toggle keymap
      line = "gcc",
      ---Block-comment toggle keymap
      block = "gbc",
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
      ---Line-comment keymap
      line = "gc",
      ---Block-comment keymap
      block = "gb",
    },
    ---LHS of extra mappings
    extra = {
      ---Add comment on the line above
      above = "gcO",
      ---Add comment on the line below
      below = "gco",
      ---Add comment at the end of line
      eol = "gcA",
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
      ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
      basic = true,
      ---Extra mapping; `gco`, `gcO`, `gcA`
      extra = true,
    },
    ---Function to call after (un)comment
    post_hook = nil,
    ---Function to call before (un)comment
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    -- pre_hook = function(ctx)
    -- 	local U = require("Comment.utils")
    --
    -- 	local location = nil
    -- 	if ctx.ctype == U.ctype.block then
    -- 		location = require("ts_context_commentstring.utils").get_cursor_location()
    -- 	elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
    -- 		location = require("ts_context_commentstring.utils").get_visual_start_location()
    -- 	end
    --
    -- 	return require("ts_context_commentstring.internal").calculate_commentstring({
    -- 		key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
    -- 		location = location,
    -- 	})
    -- end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    servers = nil,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<Leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  -- LSP Addons
  { "nvim-lua/popup.nvim" },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          insert_only = true,
          start_in_insert = true,
          border = "rounded",
          relative = "cursor",
          prefer_width = 10,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 10, 0.1 },
          win_options = {
            winblend = 0,
            winhighlight = "",
          },
          mappings = {
            n = {
              ["<Esc>"] = "Close",
              ["<CR>"] = "Confirm",
            },
            i = {
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
              ["<Up>"] = "HistoryPrev",
              ["<Down>"] = "HistoryNext",
            },
          },
          override = function(conf) return conf end,
          get_config = nil,
        },
        select = {
          -- Set to false to disable the vim.ui.select implementation
          enabled = true,

          -- Priority list of preferred vim.select implementations
          backend = { "telescope", "nui", "fzf", "builtin" },

          -- Options for nui Menu
          nui = {
            position = {
              row = 1,
              col = 0,
            },
            size = nil,
            relative = "cursor",
            border = {
              style = "rounded",
              text = {
                top_align = "right",
              },
            },
            buf_options = {
              swapfile = false,
              filetype = "DressingSelect",
            },
            max_width = 80,
            max_height = 40,
          },

          -- Options for built-in selector
          builtin = {
            -- These are passed to nvim_open_win
            wnchor = "SW",
            border = "rounded",
            -- 'editor' and 'win' will default to being centered
            relative = "cursor",

            win_options = {
              -- Window transparency (0-100)
              winblend = 5,
              -- Change default highlight groups (see :help winhl)
              winhighlight = "",
            },

            -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- the min_ and max_ options can be a list of mixed types.
            -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
            width = nil,
            max_width = { 140, 0.8 },
            min_width = { 10, 0.2 },
            height = nil,
            max_height = 0.9,
            min_height = { 2, 0.05 },

            -- Set to `false` to disable
            mappings = {
              ["<Esc>"] = "Close",
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
            },

            override = function(conf)
              -- This is the config that will be passed to nvim_open_win.
              -- Change values here to customize the layout
              return conf
            end,
          },

          -- see :help dressing_get_config
          get_config = function(opts)
            if opts.kind == "codeaction" then
              return {
                backend = "builtin",
                nui = {
                  relative = "cursor",
                  max_width = 80,
                  min_height = 2,
                },
              }
            end
          end,
        },
      })
    end,
  },
  "onsails/lspkind-nvim",
  "ray-x/lsp_signature.nvim",
  "nvimdev/lspsaga.nvim",
  {
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function() setup_typescript_tools() end,
    event = { "BufReadPre", "BufNewFile" },
    ft = { "typescript", "typescriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    config = true,
  },
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    keys = {
      { "gd", "<cmd>Glance definitions<CR>",      desc = "LSP Definition" },
      { "gr", "<cmd>Glance references<CR>",       desc = "LSP References" },
      { "gm", "<cmd>Glance implementations<CR>",  desc = "LSP Implementations" },
      { "gy", "<cmd>Glance type_definitions<CR>", desc = "LSP Type Definitions" },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-tree.lua" },
    },
    config = function() require("lsp-file-operations").setup() end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    config = function() setup_comment() end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({
        position = "bottom",           -- position of the list can be: bottom, top, left, right
        height = 10,                   -- height of the trouble list when position is top or bottom
        width = 50,                    -- width of the list when position is left or right
        icons = true,                  -- use devicons for filenames
        mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "",             -- icon used for open folds
        fold_closed = "",           -- icon used for closed folds
        group = true,                  -- group results by file
        padding = true,                -- add an extra new line on top of the list
        action_keys = {
          -- key mappings for actions in the trouble list
          -- map to {} to remove a mapping, for example:
          -- close = {},
          close = "q",                     -- close the list
          cancel = "<esc>",                -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r",                   -- manually refresh
          jump = { "<cr>", "<tab>" },      -- jump to the diagnostic or open / close folds
          open_split = { "<c-x>" },        -- open buffer in new split
          open_vsplit = { "<c-v>" },       -- open buffer in new vsplit
          open_tab = { "<c-t>" },          -- open buffer in new tab
          jump_close = { "o" },            -- jump to the diagnostic and close the list
          toggle_mode = "m",               -- toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "P",            -- toggle auto_preview
          hover = "K",                     -- opens a small popup with the full multiline message
          preview = "p",                   -- preview the diagnostic location
          close_folds = { "zM", "zm" },    -- close all folds
          open_folds = { "zR", "zr" },     -- open all folds
          toggle_fold = { "zA", "za" },    -- toggle fold of current file
          previous = "k",                  -- preview item
          next = "j",                      -- next item
        },
        indent_lines = true,               -- add an indent guide below the fold icons
        auto_open = false,                 -- automatically open the list when you have diagnostics
        auto_close = false,                -- automatically close the list when you have no diagnostics
        auto_preview = true,               -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false,                 -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
        signs = {
          -- icons / text used for a diagnostic
          error = "  ",
          warning = "  ",
          hint = "  ",
          information = "  ",
        },
        use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
      })
    end,
  },
}
